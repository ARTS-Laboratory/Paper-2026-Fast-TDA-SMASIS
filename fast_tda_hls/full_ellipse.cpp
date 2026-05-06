#include <hls_stream.h>
#include <hls_math.h>
#include <stdint.h>

typedef int16_t accel_data_t;
typedef float   internal_t;

#define WINDOW_SIZE             100
#define ACCELEROMETER_RANGE     16
#define LOG_ACCELEROMETER_RANGE 4
#define LOG_SCALE_FACTOR        ((sizeof(accel_data_t) * 8) - 1 - LOG_ACCELEROMETER_RANGE)

// ===================================================================
// Jacobi eigen-decomposition (placed first, as you requested)
void jacobi_eigen_3x3(internal_t M[3][3], internal_t V[3][3]) {
#pragma HLS INLINE off
#pragma HLS ARRAY_PARTITION variable=M complete dim=0
#pragma HLS ARRAY_PARTITION variable=V complete dim=0

    for (int i = 0; i < 3; i++) {
#pragma HLS LOOP_NAME Init_Eigenvectors
#pragma HLS LOOP_TRIPCOUNT min=1 max=1 avg=1
#pragma HLS UNROLL
        for (int j = 0; j < 3; j++) {
#pragma HLS UNROLL
            V[i][j] = (i == j) ? 1.0f : 0.0f;
        }
    }

    constexpr internal_t tol = 1e-7f;
    constexpr int max_iter = 8;        // ← reduced (this is the biggest latency saver)

    for (int iter = 0; iter < max_iter; iter++) {
#pragma HLS LOOP_NAME Jacobi_Main_Iteration
#pragma HLS LOOP_TRIPCOUNT min=1 max=8 avg=4
#pragma HLS PIPELINE II=1
        int p = 0, q = 1;
        internal_t max_off = 0.0f;

        for (int i = 0; i < 2; i++) {
            for (int j = i + 1; j < 3; j++) {
#pragma HLS LOOP_NAME Find_Largest_Off_Diagonal
#pragma HLS UNROLL
                internal_t val = hls::fabsf(M[i][j]);
                if (val > max_off) { max_off = val; p = i; q = j; }
            }
        }
        if (max_off < tol) break;

        internal_t A_pp = M[p][p];
        internal_t A_qq = M[q][q];
        internal_t A_pq = M[p][q];

        internal_t theta = 0.5f * hls::atan2f(2.0f * A_pq, (A_qq - A_pp) + 1e-8f);
        if (theta >  0.785398f) theta =  0.785398f;
        if (theta < -0.785398f) theta = -0.785398f;

        internal_t c = hls::cosf(theta);
        internal_t s = hls::sinf(theta);

        for (int i = 0; i < 3; i++) {
#pragma HLS LOOP_NAME Apply_Rotation_To_M
#pragma HLS UNROLL
            if (i != p && i != q) {
                internal_t M_ip = M[i][p];
                internal_t M_iq = M[i][q];
                M[i][p] = c * M_ip - s * M_iq;
                M[p][i] = M[i][p];
                M[i][q] = s * M_ip + c * M_iq;
                M[q][i] = M[i][q];
            }
        }

        internal_t M_pp = c*c*A_pp - 2.0f*s*c*A_pq + s*s*A_qq;
        internal_t M_qq = s*s*A_pp + 2.0f*s*c*A_pq + c*c*A_qq;

        M[p][p] = M_pp; M[q][q] = M_qq;
        M[p][q] = M[q][p] = 0.0f;

        for (int i = 0; i < 3; i++) {
#pragma HLS LOOP_NAME Update_Eigenvectors
#pragma HLS UNROLL
            internal_t V_ip = V[i][p];
            internal_t V_iq = V[i][q];
            V[i][p] = c * V_ip - s * V_iq;
            V[i][q] = s * V_ip + c * V_iq;
        }
    }
}

//  CLEAN KERNEL - raw incremental scatter + full ellipse extraction
extern "C" void scatter_matrix(hls::stream<accel_data_t>& accel, internal_t S_tilde[9]) {
#pragma HLS INTERFACE axis port=accel
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS ARRAY_PARTITION variable=S_tilde complete

    static internal_t accel_buffer[6][WINDOW_SIZE];
    static int buffer_index = 0;

#pragma HLS dependence variable=buffer_index inter false   // ← THIS IS THE KEY LINE

#pragma HLS PIPELINE II=1
#pragma HLS RESET variable=accel_buffer    

    static internal_t prev = 0.0f;
    static internal_t current = 0.0f;

    static internal_t S[6][6] = {{0}};
#pragma HLS ARRAY_PARTITION variable=S complete dim=0

    accel_data_t raw_sample = accel.read();

    prev = current;
    internal_t input_val = (internal_t)raw_sample;
    internal_t accel_scale = (internal_t)(1 << LOG_SCALE_FACTOR);
    current = input_val / accel_scale;

    internal_t v_old[6] = {
        accel_buffer[0][buffer_index], accel_buffer[1][buffer_index],
        accel_buffer[2][buffer_index], accel_buffer[3][buffer_index],
        accel_buffer[4][buffer_index], accel_buffer[5][buffer_index]
    };

    internal_t v_new[6] = {
        current*current, current*prev, prev*prev,
        current, prev, 1.0f
    };

    // Raw incremental scatter
    for (int i = 0; i < 6; i++) {
#pragma HLS LOOP_NAME Update_Scatter_Matrix
#pragma HLS LOOP_TRIPCOUNT min=6 max=6 avg=6
#pragma HLS UNROLL
        for (int j = 0; j < 6; j++) {
#pragma HLS UNROLL
            S[i][j] += v_new[i]*v_new[j] - v_old[i]*v_old[j];
        }
    }

    // Extract blocks
    internal_t S_pp[3][3], S_pq[3][3], S_qq[3][3];
#pragma HLS ARRAY_PARTITION variable=S_pp complete dim=0
#pragma HLS ARRAY_PARTITION variable=S_pq complete dim=0
#pragma HLS ARRAY_PARTITION variable=S_qq complete dim=0
    
    // Extract Schur blocks
    for (int i = 0; i < 3; i++) {
#pragma HLS UNROLL
#pragma HLS LOOP_NAME Extract_Schur_Blocks
        for (int j = 0; j < 3; j++) {
#pragma HLS UNROLL
            S_pp[i][j] = S[i][j];
            S_pq[i][j] = S[i][j+3];
            S_qq[i][j] = S[i+3][j+3];
        }
    }

    // Schur complement
    internal_t trace_qq = S_qq[0][0] + S_qq[1][1] + S_qq[2][2];
    constexpr internal_t BASE_EPS = 0.1f;
    internal_t eps = BASE_EPS * (1.0f + 0.01f * trace_qq);

    internal_t a = S_qq[0][0] + eps, b = S_qq[0][1], c = S_qq[0][2];
    internal_t d = S_qq[1][0], e = S_qq[1][1] + eps, f = S_qq[1][2];
    internal_t g = S_qq[2][0], h = S_qq[2][1], i_val = S_qq[2][2] + eps;

    internal_t det = a*(e*i_val - f*f) - b*(b*i_val - f*c) + c*(b*f - e*c);
    internal_t inv_det = (hls::fabsf(det) < 1e-6f) ? 0.0f : 1.0f / det;

    internal_t inv_qq[3][3] = {{0}};
#pragma HLS ARRAY_PARTITION variable=inv_qq complete dim=0

    if (inv_det != 0.0f) {
        inv_qq[0][0] = (e*i_val - f*f) * inv_det;
        inv_qq[0][1] = (c*f - b*i_val) * inv_det;
        inv_qq[0][2] = (b*f - c*e) * inv_det;
        inv_qq[1][0] = (f*c - d*i_val) * inv_det;
        inv_qq[1][1] = (a*i_val - c*c) * inv_det;
        inv_qq[1][2] = (c*d - a*f) * inv_det;
        inv_qq[2][0] = (d*f - e*c) * inv_det;
        inv_qq[2][1] = (b*c - a*f) * inv_det;
        inv_qq[2][2] = (a*e - b*b) * inv_det;
    }
    
    // Compute S_reduced = S_pp - S_pq * inv(S_qq)
    internal_t S_reduced[3][3] = {{0}};
#pragma HLS ARRAY_PARTITION variable=S_reduced complete dim=0
    for (int i = 0; i < 3; i++) {
#pragma HLS UNROLL
        for (int j = 0; j < 3; j++) {
#pragma HLS UNROLL
            internal_t tmp = 0.0f;
            for (int k = 0; k < 3; k++) {
#pragma HLS UNROLL
                tmp += S_pq[i][k] * inv_qq[k][j];
            }
            S_reduced[i][j] = S_pp[i][j] - tmp;
        }
    }
    
    // Apply invD transformation
    internal_t invD[3][3] = {{0.0f, 0.5f, 0.0f}, {0.5f, 0.0f, 0.0f}, {0.0f, 0.0f, -1.0f}};
    internal_t A[3][3] = {{0}};
#pragma HLS ARRAY_PARTITION variable=A complete dim=0

    for (int i = 0; i < 3; i++) {
#pragma HLS LOOP_NAME Apply_invD_Transformation
#pragma HLS UNROLL
        for (int j = 0; j < 3; j++) {
#pragma HLS UNROLL
            internal_t s = 0.0f;
            for (int k = 0; k < 3; k++) {
#pragma HLS UNROLL
                s += invD[i][k] * S_reduced[k][j];
            }
            A[i][j] = s;
        }
    }

    internal_t V[3][3];
    jacobi_eigen_3x3(A, V);

  
    // ELLIPSE PARAMETER EXTRACTION
    #pragma HLS LOOP_NAME Extract_Ellipse_Params
    #pragma HLS LOOP_TRIPCOUNT min=1 max=1 avg=1
    int idx = 1;
    internal_t a_coeff = V[0][idx];
    internal_t bb      = V[1][idx];   // b/2
    internal_t c_coeff = V[2][idx];

    internal_t constraint = 4*a_coeff*c_coeff - bb*bb;
    internal_t ellipse_scale = (constraint > 0.0f) ? 1.0f / hls::sqrtf(constraint) : 1.0f;

    S_tilde[0] = a_coeff * ellipse_scale;          // a
    S_tilde[1] = 2 * bb * ellipse_scale;           // b
    S_tilde[2] = c_coeff * ellipse_scale;          // c
    S_tilde[3] = 2 * V[0][idx] * ellipse_scale;    // d
    S_tilde[4] = 2 * V[1][idx] * ellipse_scale;    // e
    S_tilde[5] = V[2][idx] * ellipse_scale;        // f
    S_tilde[6] = 0.0f;
    S_tilde[7] = 0.0f;
    S_tilde[8] = 0.0f;

    // Update buffer
    for (int i = 0; i < 6; i++) {
#pragma HLS UNROLL
        accel_buffer[i][buffer_index] = v_new[i];
    }

    buffer_index = (buffer_index + 1) % WINDOW_SIZE;
}