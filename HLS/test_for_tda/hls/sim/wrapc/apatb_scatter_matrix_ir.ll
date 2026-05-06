; ModuleID = 'C:/Users/Charlton.Rolle/Documents/test_for_tda/test_for_tda/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.hls::stream<short, 0>" = type { i16 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #1

; Function Attrs: noinline willreturn
define void @apatb_scatter_matrix_ir(%"class.hls::stream<short, 0>"* noalias nocapture nonnull dereferenceable(2) %accel, float* noalias nocapture nonnull "fpga.decayed.dim.hint"="9" "partition" %S_tilde) local_unnamed_addr #2 {
entry:
  %accel_copy = alloca i16, align 512
  call void @llvm.sideeffect() #10 [ "stream_interface"(i16* %accel_copy, i32 0) ]
  %S_tilde_copy_0 = alloca float, align 512
  %S_tilde_copy_1 = alloca float, align 512
  %S_tilde_copy_2 = alloca float, align 512
  %S_tilde_copy_3 = alloca float, align 512
  %S_tilde_copy_4 = alloca float, align 512
  %S_tilde_copy_5 = alloca float, align 512
  %S_tilde_copy_6 = alloca float, align 512
  %S_tilde_copy_7 = alloca float, align 512
  %S_tilde_copy_8 = alloca float, align 512
  %0 = bitcast float* %S_tilde to [9 x float]*
  call void @copy_in(%"class.hls::stream<short, 0>"* nonnull %accel, i16* nonnull align 512 %accel_copy, [9 x float]* nonnull %0, float* nonnull align 512 %S_tilde_copy_0, float* nonnull align 512 %S_tilde_copy_1, float* nonnull align 512 %S_tilde_copy_2, float* nonnull align 512 %S_tilde_copy_3, float* nonnull align 512 %S_tilde_copy_4, float* nonnull align 512 %S_tilde_copy_5, float* nonnull align 512 %S_tilde_copy_6, float* nonnull align 512 %S_tilde_copy_7, float* nonnull align 512 %S_tilde_copy_8)
  call void @apatb_scatter_matrix_hw(i16* %accel_copy, float* %S_tilde_copy_0, float* %S_tilde_copy_1, float* %S_tilde_copy_2, float* %S_tilde_copy_3, float* %S_tilde_copy_4, float* %S_tilde_copy_5, float* %S_tilde_copy_6, float* %S_tilde_copy_7, float* %S_tilde_copy_8)
  call void @copy_back(%"class.hls::stream<short, 0>"* %accel, i16* %accel_copy, [9 x float]* %0, float* %S_tilde_copy_0, float* %S_tilde_copy_1, float* %S_tilde_copy_2, float* %S_tilde_copy_3, float* %S_tilde_copy_4, float* %S_tilde_copy_5, float* %S_tilde_copy_6, float* %S_tilde_copy_7, float* %S_tilde_copy_8)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<short, 0>"(i16* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<short, 0>"* noalias "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<short, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<short, 0>"(i16* align 512 %dst, %"class.hls::stream<short, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<short, 0>"(i16* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<short, 0>"* noalias nocapture "unpacked"="1") unnamed_addr #4 {
entry:
  %2 = alloca %"class.hls::stream<short, 0>"
  %3 = alloca i16
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<short, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_2(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<short, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<short, 0>"* %1 to i8*
  call void @fpga_fifo_pop_2(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<short, 0>", %"class.hls::stream<short, 0>"* %2
  %.evi = extractvalue %"class.hls::stream<short, 0>" %8, 0
  store i16 %.evi, i16* %3
  %9 = bitcast i16* %3 to i8*
  %10 = bitcast i16* %0 to i8*
  call void @fpga_fifo_push_2(i8* %9, i8* %10)
  br label %empty, !llvm.loop !20

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a9f32([9 x float]* "orig.arg.no"="0" %dst, [9 x float]* readonly "orig.arg.no"="1" %src, i64 "orig.arg.no"="2" %num) local_unnamed_addr #5 {
entry:
  %0 = icmp eq [9 x float]* %src, null
  %1 = icmp eq [9 x float]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %dst.addr = getelementptr [9 x float], [9 x float]* %dst, i64 0, i64 %for.loop.idx2
  %src.addr = getelementptr [9 x float], [9 x float]* %src, i64 0, i64 %for.loop.idx2
  %3 = load float, float* %src.addr, align 4
  store float %3, float* %dst.addr, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<short, 0>.335"(%"class.hls::stream<short, 0>"* noalias "unpacked"="0" %dst, i16* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<short, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<short, 0>.338"(%"class.hls::stream<short, 0>"* nonnull %dst, i16* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<short, 0>.338"(%"class.hls::stream<short, 0>"* noalias nocapture "unpacked"="0", i16* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #4 {
entry:
  %2 = alloca i16
  %3 = alloca %"class.hls::stream<short, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i16* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_2(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i16* %2 to i8*
  %7 = bitcast i16* %1 to i8*
  call void @fpga_fifo_pop_2(i8* %6, i8* %7)
  %8 = load volatile i16, i16* %2
  %.ivi = insertvalue %"class.hls::stream<short, 0>" undef, i16 %8, 0
  store %"class.hls::stream<short, 0>" %.ivi, %"class.hls::stream<short, 0>"* %3
  %9 = bitcast %"class.hls::stream<short, 0>"* %3 to i8*
  %10 = bitcast %"class.hls::stream<short, 0>"* %0 to i8*
  call void @fpga_fifo_push_2(i8* %9, i8* %10)
  br label %empty, !llvm.loop !22

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a9f32.349.350(float* "orig.arg.no"="0" "unpacked"="0.0" %dst_0, float* "orig.arg.no"="0" "unpacked"="0.1" %dst_1, float* "orig.arg.no"="0" "unpacked"="0.2" %dst_2, float* "orig.arg.no"="0" "unpacked"="0.3" %dst_3, float* "orig.arg.no"="0" "unpacked"="0.4" %dst_4, float* "orig.arg.no"="0" "unpacked"="0.5" %dst_5, float* "orig.arg.no"="0" "unpacked"="0.6" %dst_6, float* "orig.arg.no"="0" "unpacked"="0.7" %dst_7, float* "orig.arg.no"="0" "unpacked"="0.8" %dst_8, [9 x float]* readonly "orig.arg.no"="1" %src, i64 "orig.arg.no"="2" %num) #5 {
entry:
  %0 = icmp eq [9 x float]* %src, null
  %1 = icmp eq float* %dst_0, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.exit ]
  %src.addr = getelementptr [9 x float], [9 x float]* %src, i64 0, i64 %for.loop.idx2
  %3 = load float, float* %src.addr, align 4
  switch i64 %for.loop.idx2, label %dst.addr.case.8 [
    i64 0, label %dst.addr.case.0
    i64 1, label %dst.addr.case.1
    i64 2, label %dst.addr.case.2
    i64 3, label %dst.addr.case.3
    i64 4, label %dst.addr.case.4
    i64 5, label %dst.addr.case.5
    i64 6, label %dst.addr.case.6
    i64 7, label %dst.addr.case.7
  ]

dst.addr.case.0:                                  ; preds = %for.loop
  store float %3, float* %dst_0, align 4
  br label %dst.addr.exit

dst.addr.case.1:                                  ; preds = %for.loop
  store float %3, float* %dst_1, align 4
  br label %dst.addr.exit

dst.addr.case.2:                                  ; preds = %for.loop
  store float %3, float* %dst_2, align 4
  br label %dst.addr.exit

dst.addr.case.3:                                  ; preds = %for.loop
  store float %3, float* %dst_3, align 4
  br label %dst.addr.exit

dst.addr.case.4:                                  ; preds = %for.loop
  store float %3, float* %dst_4, align 4
  br label %dst.addr.exit

dst.addr.case.5:                                  ; preds = %for.loop
  store float %3, float* %dst_5, align 4
  br label %dst.addr.exit

dst.addr.case.6:                                  ; preds = %for.loop
  store float %3, float* %dst_6, align 4
  br label %dst.addr.exit

dst.addr.case.7:                                  ; preds = %for.loop
  store float %3, float* %dst_7, align 4
  br label %dst.addr.exit

dst.addr.case.8:                                  ; preds = %for.loop
  %4 = icmp eq i64 %for.loop.idx2, 8
  call void @llvm.assume(i1 %4)
  store float %3, float* %dst_8, align 4
  br label %dst.addr.exit

dst.addr.exit:                                    ; preds = %dst.addr.case.8, %dst.addr.case.7, %dst.addr.case.6, %dst.addr.case.5, %dst.addr.case.4, %dst.addr.case.3, %dst.addr.case.2, %dst.addr.case.1, %dst.addr.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @onebyonecpy_hls.p0a9f32.348.351(float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.0" %dst_0, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.1" %dst_1, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.2" %dst_2, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.3" %dst_3, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.4" %dst_4, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.5" %dst_5, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.6" %dst_6, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.7" %dst_7, float* noalias align 512 "orig.arg.no"="0" "unpacked"="0.8" %dst_8, [9 x float]* noalias readonly "orig.arg.no"="1" %src) #6 {
entry:
  %0 = icmp eq float* %dst_0, null
  %1 = icmp eq [9 x float]* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @arraycpy_hls.p0a9f32.349.350(float* nonnull %dst_0, float* %dst_1, float* %dst_2, float* %dst_3, float* %dst_4, float* %dst_5, float* %dst_6, float* %dst_7, float* %dst_8, [9 x float]* nonnull %src, i64 9)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal void @copy_in(%"class.hls::stream<short, 0>"* noalias "orig.arg.no"="0" "unpacked"="0", i16* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0", [9 x float]* noalias readonly "orig.arg.no"="2" "unpacked"="2", float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.0" %_0, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.1" %_1, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.2" %_2, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.3" %_3, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.4" %_4, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.5" %_5, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.6" %_6, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.7" %_7, float* noalias align 512 "orig.arg.no"="3" "unpacked"="3.8" %_8) #7 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<short, 0>"(i16* align 512 %1, %"class.hls::stream<short, 0>"* %0)
  call void @onebyonecpy_hls.p0a9f32.348.351(float* align 512 %_0, float* align 512 %_1, float* align 512 %_2, float* align 512 %_3, float* align 512 %_4, float* align 512 %_5, float* align 512 %_6, float* align 512 %_7, float* align 512 %_8, [9 x float]* %2)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @arraycpy_hls.p0a9f32.357.358([9 x float]* "orig.arg.no"="0" %dst, float* readonly "orig.arg.no"="1" "unpacked"="1.0" %src_0, float* readonly "orig.arg.no"="1" "unpacked"="1.1" %src_1, float* readonly "orig.arg.no"="1" "unpacked"="1.2" %src_2, float* readonly "orig.arg.no"="1" "unpacked"="1.3" %src_3, float* readonly "orig.arg.no"="1" "unpacked"="1.4" %src_4, float* readonly "orig.arg.no"="1" "unpacked"="1.5" %src_5, float* readonly "orig.arg.no"="1" "unpacked"="1.6" %src_6, float* readonly "orig.arg.no"="1" "unpacked"="1.7" %src_7, float* readonly "orig.arg.no"="1" "unpacked"="1.8" %src_8, i64 "orig.arg.no"="2" %num) #5 {
entry:
  %0 = icmp eq float* %src_0, null
  %1 = icmp eq [9 x float]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.exit ]
  %dst.addr = getelementptr [9 x float], [9 x float]* %dst, i64 0, i64 %for.loop.idx2
  switch i64 %for.loop.idx2, label %src.addr.case.8 [
    i64 0, label %src.addr.case.0
    i64 1, label %src.addr.case.1
    i64 2, label %src.addr.case.2
    i64 3, label %src.addr.case.3
    i64 4, label %src.addr.case.4
    i64 5, label %src.addr.case.5
    i64 6, label %src.addr.case.6
    i64 7, label %src.addr.case.7
  ]

src.addr.case.0:                                  ; preds = %for.loop
  %_0 = load float, float* %src_0, align 4
  br label %src.addr.exit

src.addr.case.1:                                  ; preds = %for.loop
  %_1 = load float, float* %src_1, align 4
  br label %src.addr.exit

src.addr.case.2:                                  ; preds = %for.loop
  %_2 = load float, float* %src_2, align 4
  br label %src.addr.exit

src.addr.case.3:                                  ; preds = %for.loop
  %_3 = load float, float* %src_3, align 4
  br label %src.addr.exit

src.addr.case.4:                                  ; preds = %for.loop
  %_4 = load float, float* %src_4, align 4
  br label %src.addr.exit

src.addr.case.5:                                  ; preds = %for.loop
  %_5 = load float, float* %src_5, align 4
  br label %src.addr.exit

src.addr.case.6:                                  ; preds = %for.loop
  %_6 = load float, float* %src_6, align 4
  br label %src.addr.exit

src.addr.case.7:                                  ; preds = %for.loop
  %_7 = load float, float* %src_7, align 4
  br label %src.addr.exit

src.addr.case.8:                                  ; preds = %for.loop
  %3 = icmp eq i64 %for.loop.idx2, 8
  call void @llvm.assume(i1 %3)
  %_8 = load float, float* %src_8, align 4
  br label %src.addr.exit

src.addr.exit:                                    ; preds = %src.addr.case.8, %src.addr.case.7, %src.addr.case.6, %src.addr.case.5, %src.addr.case.4, %src.addr.case.3, %src.addr.case.2, %src.addr.case.1, %src.addr.case.0
  %4 = phi float [ %_0, %src.addr.case.0 ], [ %_1, %src.addr.case.1 ], [ %_2, %src.addr.case.2 ], [ %_3, %src.addr.case.3 ], [ %_4, %src.addr.case.4 ], [ %_5, %src.addr.case.5 ], [ %_6, %src.addr.case.6 ], [ %_7, %src.addr.case.7 ], [ %_8, %src.addr.case.8 ]
  store float %4, float* %dst.addr, align 4
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @onebyonecpy_hls.p0a9f32.356.359([9 x float]* noalias "orig.arg.no"="0" %dst, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.0" %src_0, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.1" %src_1, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.2" %src_2, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.3" %src_3, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.4" %src_4, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.5" %src_5, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.6" %src_6, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.7" %src_7, float* noalias readonly align 512 "orig.arg.no"="1" "unpacked"="1.8" %src_8) #6 {
entry:
  %0 = icmp eq [9 x float]* %dst, null
  %1 = icmp eq float* %src_0, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @arraycpy_hls.p0a9f32.357.358([9 x float]* nonnull %dst, float* nonnull %src_0, float* %src_1, float* %src_2, float* %src_3, float* %src_4, float* %src_5, float* %src_6, float* %src_7, float* %src_8, i64 9)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal void @copy_out(%"class.hls::stream<short, 0>"* noalias "orig.arg.no"="0" "unpacked"="0", i16* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0", [9 x float]* noalias "orig.arg.no"="2" "unpacked"="2", float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.0" %_0, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.1" %_1, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.2" %_2, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.3" %_3, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.4" %_4, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.5" %_5, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.6" %_6, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.7" %_7, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.8" %_8) #8 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<short, 0>.335"(%"class.hls::stream<short, 0>"* %0, i16* align 512 %1)
  call void @onebyonecpy_hls.p0a9f32.356.359([9 x float]* %2, float* align 512 %_0, float* align 512 %_1, float* align 512 %_2, float* align 512 %_3, float* align 512 %_4, float* align 512 %_5, float* align 512 %_6, float* align 512 %_7, float* align 512 %_8)
  ret void
}

declare void @apatb_scatter_matrix_hw(i16*, float*, float*, float*, float*, float*, float*, float*, float*, float*)

; Function Attrs: argmemonly noinline willreturn
define internal void @copy_back(%"class.hls::stream<short, 0>"* noalias "orig.arg.no"="0" "unpacked"="0", i16* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0", [9 x float]* noalias "orig.arg.no"="2" "unpacked"="2", float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.0" %_0, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.1" %_1, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.2" %_2, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.3" %_3, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.4" %_4, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.5" %_5, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.6" %_6, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.7" %_7, float* noalias readonly align 512 "orig.arg.no"="3" "unpacked"="3.8" %_8) #8 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<short, 0>.335"(%"class.hls::stream<short, 0>"* %0, i16* align 512 %1)
  call void @onebyonecpy_hls.p0a9f32.356.359([9 x float]* %2, float* align 512 %_0, float* align 512 %_1, float* align 512 %_2, float* align 512 %_3, float* align 512 %_4, float* align 512 %_5, float* align 512 %_6, float* align 512 %_7, float* align 512 %_8)
  ret void
}

define void @scatter_matrix_hw_stub_wrapper(i16*, float*, float*, float*, float*, float*, float*, float*, float*, float*) #9 {
entry:
  %10 = alloca %"class.hls::stream<short, 0>"
  %11 = alloca [9 x float]
  call void @copy_out(%"class.hls::stream<short, 0>"* %10, i16* %0, [9 x float]* %11, float* %1, float* %2, float* %3, float* %4, float* %5, float* %6, float* %7, float* %8, float* %9)
  %12 = bitcast [9 x float]* %11 to float*
  call void @scatter_matrix_hw_stub(%"class.hls::stream<short, 0>"* %10, float* %12)
  call void @copy_in(%"class.hls::stream<short, 0>"* %10, i16* %0, [9 x float]* %11, float* %1, float* %2, float* %3, float* %4, float* %5, float* %6, float* %7, float* %8, float* %9)
  ret void
}

declare void @scatter_matrix_hw_stub(%"class.hls::stream<short, 0>"* noalias nocapture nonnull, float* noalias nocapture nonnull)

declare i1 @fpga_fifo_not_empty_2(i8*)

declare void @fpga_fifo_pop_2(i8*, i8*)

declare void @fpga_fifo_push_2(i8*, i8*)

attributes #0 = { inaccessiblememonly nounwind willreturn }
attributes #1 = { nounwind willreturn }
attributes #2 = { noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #3 = { argmemonly noinline willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #4 = { argmemonly noinline willreturn "fpga.wrapper.func"="streamcpy_hls" }
attributes #5 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #6 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #7 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyin" }
attributes #8 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyout" }
attributes #9 = { "fpga.wrapper.func"="stub" }
attributes #10 = { inaccessiblememonly nounwind willreturn "xlx.port.bitwidth"="16" "xlx.source"="user" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}
!datalayout.transforms.on.top = !{!5}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = !{!6, !8, !10}
!6 = !{!7}
!7 = !{!"1", [9 x float]* null}
!8 = !{!9}
!9 = !{!"array_partition", !"type=Complete", !"dim=1"}
!10 = !{!11, !12, !13, !14, !15, !16, !17, !18, !19}
!11 = !{!"1.0", float* null}
!12 = !{!"1.1", float* null}
!13 = !{!"1.2", float* null}
!14 = !{!"1.3", float* null}
!15 = !{!"1.4", float* null}
!16 = !{!"1.5", float* null}
!17 = !{!"1.6", float* null}
!18 = !{!"1.7", float* null}
!19 = !{!"1.8", float* null}
!20 = distinct !{!20, !21}
!21 = !{!"llvm.loop.rotate.disable"}
!22 = distinct !{!22, !21}
