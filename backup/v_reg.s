.data
.balign 1
a:
	.byte 1,1,1,1,1,1,1,1
.balign 1
b:
	.byte 2,2,2,2,2,2,2,2
.balign 1
c:
	.byte 3,3,3,3,3,3,3,3
.balign 1
var:
	.byte 0
.text
.global main
main:
	ldr r4,addr_var
	mov r3,#64
	str r3,[r4]
	ldr r0,addr_a
	ldr r1,addr_b
	ldr r2,addr_c
	vld1.u8 {d0},[r0] // d0->a
	vld1.u8 {d1},[r1]! // d1->b
	vld1.u8 {d2},[r2]! // d2->m
	vld1.u8 {d3[]},[r4]
	vmul.I8 d1,d1,d2
	vsub.I8 d2,d3,d2
	vmul.I8 d0,d0,d2
	vadd.I8 d0,d0,d1
	mov r3,#32
	str r3,[r4]
	vld1.u8 {d3[]},[r4]
	vadd.I8 d0,d0,d3
	vshr.u8 d0,d0,#6
	vst1.u8 {d0},[r0]
	bx lr

addr_a: .word a
addr_b: .word b
addr_c:	.word c
addr_var: .word var
