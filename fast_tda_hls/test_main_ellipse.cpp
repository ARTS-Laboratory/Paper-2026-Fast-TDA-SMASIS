#include <hls_stream.h>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <vector>
#include <string>

typedef int16_t accel_data_t;
typedef float   internal_t;

// Your kernel
extern "C" void scatter_matrix(hls::stream<accel_data_t>& accel, internal_t S_tilde[9]);

int main() {
    // 1. Load raw CSV from MATLAB
    std::ifstream input_file("hls_test_input.csv");
    if (!input_file.is_open()) {
        std::cerr << "ERROR: Could not open hls_test_input.csv\n";
        return 1;
    }

    std::vector<float> raw_samples;
    std::string line;
    while (std::getline(input_file, line)) {
        if (line.empty()) continue;
        raw_samples.push_back(std::stof(line));
    }
    input_file.close();

    std::cout << "Loaded " << raw_samples.size() << " raw samples from MATLAB\n\n";

    // 2. Prepare result file
    std::ofstream result_file("hls_test_results.csv");
    result_file << "sample_index,s_tilde0,s_tilde1,s_tilde2,s_tilde3,s_tilde4,s_tilde5,s_tilde6,s_tilde7,s_tilde8\n";

    // 3. Streaming simulation
    hls::stream<accel_data_t> accel_stream;
    internal_t S_tilde[9] = {0};

    std::cout << "Running kernel with ×24 scaling...\n";

    for (size_t i = 0; i < raw_samples.size(); ++i) {
        // === SCALING YOU ASKED FOR ===
        float raw = raw_samples[i];
        accel_data_t scaled = static_cast<accel_data_t>(raw * 24.0f);   // ← your scaling

        accel_stream.write(scaled);

        // Call kernel once per sample (streaming style)
        scatter_matrix(accel_stream, S_tilde);

        // Capture result every 100 samples (full window)
        if ((i + 1) % 100 == 0) {
            result_file << (i + 1);
            for (int j = 0; j < 9; ++j) {
                result_file << "," << std::fixed << std::setprecision(8) << S_tilde[j];
            }
            result_file << "\n";

            if ((i + 1) % 1000 == 0) {
                std::cout << "Processed " << (i + 1) << " samples...\n";
            }
        }
    }

    result_file.close();
    std::cout << "\n✅ Done!\n";
    std::cout << "Results saved to hls_test_results.csv\n";
    std::cout << "Compare this with your hls_golden_coeffs.csv in MATLAB\n";

    return 0;
}