// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xscatter_matrix.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XScatter_matrix_CfgInitialize(XScatter_matrix *InstancePtr, XScatter_matrix_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XScatter_matrix_Start(XScatter_matrix *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_AP_CTRL) & 0x80;
    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XScatter_matrix_IsDone(XScatter_matrix *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XScatter_matrix_IsIdle(XScatter_matrix *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XScatter_matrix_IsReady(XScatter_matrix *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XScatter_matrix_EnableAutoRestart(XScatter_matrix *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XScatter_matrix_DisableAutoRestart(XScatter_matrix *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_AP_CTRL, 0);
}

void XScatter_matrix_InterruptGlobalEnable(XScatter_matrix *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_GIE, 1);
}

void XScatter_matrix_InterruptGlobalDisable(XScatter_matrix *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_GIE, 0);
}

void XScatter_matrix_InterruptEnable(XScatter_matrix *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_IER);
    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_IER, Register | Mask);
}

void XScatter_matrix_InterruptDisable(XScatter_matrix *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_IER);
    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_IER, Register & (~Mask));
}

void XScatter_matrix_InterruptClear(XScatter_matrix *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XScatter_matrix_WriteReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_ISR, Mask);
}

u32 XScatter_matrix_InterruptGetEnabled(XScatter_matrix *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_IER);
}

u32 XScatter_matrix_InterruptGetStatus(XScatter_matrix *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XScatter_matrix_ReadReg(InstancePtr->Control_BaseAddress, XSCATTER_MATRIX_CONTROL_ADDR_ISR);
}

