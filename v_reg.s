.data
.balign 1
a:
	.byte 1,2,3,4
	.byte 1,2,3,4
	.byte 1,1,1,1
	.byte 1,1,1,1
.balign 1
b:
	.byte 2,2,2,2
	.byte 2,2,2,2
	.byte 2,2,2,2
	.byte 2,2,2,2

.balign 1
c:
	.byte 3,3,3,3
	.byte 3,3,3,3
	.byte 3,3,3,3
	.byte 3,3,3,3
.balign 1
var:
	.byte 0

.text
.global main
// expression (((a*(64-m)+b*m)+32)>>6)
main:
	mov r3,#4 		// w=8
	mov r6,#4 		// mask_stride=8
	mov r1,#4 		// dst_stride=8
	mov r4,#4 		// h=8
	ldr r8,addr_var		// just a variable to load values like 64 and 32
	mov r7,#64
	str r7,[r8]
	ldr r0,addr_a		// r0<-dst=a
	ldr r2,addr_b		// r2<-tmp=m
	ldr r5,addr_c		// r5<-mask=m
	vmov.i8 	d22,#64
	add 		r12,r0,r1
	lsl 		r1,r1,#1
loop:
	vld1.32		{d0[0]},[r0]	//dst
	vld1.32		{d1[]},[r2],r3 // tmp
	vld1.32		{d2[]},[r5],r3 // mask
	subs 		r4,r4,#2
	vsub.i8		d3,d22,d2
	vld1.32 	{d4[]},[r12]	//dst
	vld1.32		{d5[]},[r2],r3 // tmp
	vld1.32 	{d6[]},[r5],r3 // mask
	vsub.i8		d7,d22,d6
	vmull.u8 	q8,d1,d2
	vmlal.u8 	q8,d0,d3
	vmull.u8 	q9,d5,d6
	vmlal.u8 	q9,d4,d7
	vrshrn.i16 	d20,q8,#6
	vrshrn.i16 	d21,q9,#6
	vst1.u8 	{d20[0]},[r0],r1
	vst1.32		{d21[0]},[r12,:32],r1
	bgt	loop
	bx lr
addr_a: .word a
addr_b: .word b
addr_c:	.word c
addr_var: .word var
