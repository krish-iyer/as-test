.data
.balign 1
a:
	.byte 1,1,1,1,1,1,1,1
	.byte 1,1,1,1,1,1,1,1
	.byte 1,1,1,1,1,1,1,1
	.byte 1,1,1,1,1,1,1,1
	.byte 1,1,1,1,1,1,1,1
	.byte 1,1,1,1,1,1,1,1
	.byte 1,1,1,1,1,1,1,1
	.byte 1,1,1,1,1,1,1,1

.balign 1
b:
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2
	.byte 2,2,2,2,2,2,2,2

.balign 1
c:
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3
	.byte 3,3,3,3,3,3,3,3

.balign 1
var:
	.byte 0
.text
.global main
// expression (((a*(64-m)+b*m)+32)>>6)
main:
	mov r3,#8 		// w=8
	mov r6,#8 		// mask_stride=8
	mov r1,#8 		// dst_stride=8
	mov r4,#8 		// h=8
	ldr r8,addr_var		// just a variable to load values like 64 and 32
	mov r7,#64
	str r7,[r8]
	ldr r0,addr_a		// r0<-dst=a
	ldr r2,addr_b		// r2<-tmp=m
	ldr r5,addr_c		// r5<-mask=m
loop:
	vld1.u8 {d0},[r0] 	
	vld1.u8 {d1},[r2],r3 	// tmp+=w
	vld1.u8 {d2},[r5],r6	// mask+=mask_stride
	vmov.I8 {d3},#64	// d3<-64
	vmul.I8 d1,d1,d2	//b<-(b*m)
	vsub.I8 d2,d3,d2	//m<-(64-m)
	vmull.u8 q2,d0,d2	//a<-a*m
	vadd.I8 d0,d0,d1	//a<-a+b
	mov r7,#32
	str r7,[r8]		
	vld1.u8 {d3[]},[r8]	//d3<-32
	vadd.I8 d0,d0,d3	// a<-(a+32)
	vshr.u8 d0,d0,#6	// a<-(a>>6)
	vst1.u8 {d0},[r0],r1	// load back to r0 and dst+=dst_stride
	subs r4,r4,#1		// --h
	bgt loop		// check if greater than 0
	bx lr

addr_a: .word a
addr_b: .word b
addr_c:	.word c
addr_var: .word var
