// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
// Tool Version Limit: 2024.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XSCATTER_MATRIX_H
#define XSCATTER_MATRIX_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xscatter_matrix_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XScatter_matrix_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XScatter_matrix;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XScatter_matrix_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XScatter_matrix_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XScatter_matrix_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XScatter_matrix_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XScatter_matrix_Initialize(XScatter_matrix *InstancePtr, UINTPTR BaseAddress);
XScatter_matrix_Config* XScatter_matrix_LookupConfig(UINTPTR BaseAddress);
#else
int XScatter_matrix_Initialize(XScatter_matrix *InstancePtr, u16 DeviceId);
XScatter_matrix_Config* XScatter_matrix_LookupConfig(u16 DeviceId);
#endif
int XScatter_matrix_CfgInitialize(XScatter_matrix *InstancePtr, XScatter_matrix_Config *ConfigPtr);
#else
int XScatter_matrix_Initialize(XScatter_matrix *InstancePtr, const char* InstanceName);
int XScatter_matrix_Release(XScatter_matrix *InstancePtr);
#endif

void XScatter_matrix_Start(XScatter_matrix *InstancePtr);
u32 XScatter_matrix_IsDone(XScatter_matrix *InstancePtr);
u32 XScatter_matrix_IsIdle(XScatter_matrix *InstancePtr);
u32 XScatter_matrix_IsReady(XScatter_matrix *InstancePtr);
void XScatter_matrix_EnableAutoRestart(XScatter_matrix *InstancePtr);
void XScatter_matrix_DisableAutoRestart(XScatter_matrix *InstancePtr);


void XScatter_matrix_InterruptGlobalEnable(XScatter_matrix *InstancePtr);
void XScatter_matrix_InterruptGlobalDisable(XScatter_matrix *InstancePtr);
void XScatter_matrix_InterruptEnable(XScatter_matrix *InstancePtr, u32 Mask);
void XScatter_matrix_InterruptDisable(XScatter_matrix *InstancePtr, u32 Mask);
void XScatter_matrix_InterruptClear(XScatter_matrix *InstancePtr, u32 Mask);
u32 XScatter_matrix_InterruptGetEnabled(XScatter_matrix *InstancePtr);
u32 XScatter_matrix_InterruptGetStatus(XScatter_matrix *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
