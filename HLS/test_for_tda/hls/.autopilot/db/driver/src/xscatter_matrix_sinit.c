// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xscatter_matrix.h"

extern XScatter_matrix_Config XScatter_matrix_ConfigTable[];

#ifdef SDT
XScatter_matrix_Config *XScatter_matrix_LookupConfig(UINTPTR BaseAddress) {
	XScatter_matrix_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XScatter_matrix_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XScatter_matrix_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XScatter_matrix_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XScatter_matrix_Initialize(XScatter_matrix *InstancePtr, UINTPTR BaseAddress) {
	XScatter_matrix_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XScatter_matrix_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XScatter_matrix_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XScatter_matrix_Config *XScatter_matrix_LookupConfig(u16 DeviceId) {
	XScatter_matrix_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSCATTER_MATRIX_NUM_INSTANCES; Index++) {
		if (XScatter_matrix_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XScatter_matrix_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XScatter_matrix_Initialize(XScatter_matrix *InstancePtr, u16 DeviceId) {
	XScatter_matrix_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XScatter_matrix_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XScatter_matrix_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

