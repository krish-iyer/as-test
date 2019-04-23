.data
mat_a: .float 0.1, 0.2
       .float 0.2, 0.1
mat_b: .float  4.92,  2.54
       .float  3.02, -1.1
mat_c: .float 0.0, 0.0
       .float 0.0, 0.0

rst : .asciz " %5.2f %5.2f \n %5.2f %5.2f"

.text

mat_mul:
	push {r4,r5,r6,r7,r8,lr}
	mov r4,#0
	.Loop_i:
		cmp r4,#2
		bge .Loop_end
		mov r5,#0
		.Loop_j:
			cmp r5,#2
			beq .Lend_j
			add r7,r5,r4,LSL #1
			add r7,r2,r7,LSL #2 //computing c

			vldr s0,[r7]
			mov r6,#0
			.Loop_k:
				cmp r6,#2
				beq .Lend_k
				
				adds r8,r6,r4,LSL #1 // computing a
				adds r8,r0,r8,LSL #2

				vldr s1,[r8]

				adds r8,r5,r6,LSL #1 // computing b
				adds r8,r1,r8,LSL #2

				vldr s2,[r8]

				vmul.f32 s3,s2,s1

				vadd.f32 s0,s0,s3

				add r6,r6,#1
				b .Loop_k
			.Lend_k:
				vstr s0,[r7]
				add r5,r5,#1
				b .Loop_j
		.Lend_j:
			add r4,r4,#1
			b .Loop_i
	.Loop_end:
		pop {r4,r5,r6,r7,r8,lr}
		bx lr
.global main
main:
	push {r0,r1,r2,r3,r4,r5,r6,lr}
	vpush {d0-d1}

	ldr r0,addr_mata
	ldr r1,addr_matb
	ldr r2,addr_matc
	bl mat_mul
	// print the result

	ldr r4,addr_matc
	vldr s0,[r4]
	vcvt.f64.f32 d1,s0
	vmov r2,r3,d1

	mov r6,sp
	mov r5,#1
	add r4,r4,#12

	.Loop:
		vldr s0,[r4]
		vcvt.f64.f32 d1,s0

		sub sp,sp,#8
		vstr d1,[sp]
		sub r4,r4,#4
		add r5,r5,#1
		cmp r5,#4
		bne .Loop
	ldr r0,addr_frm
	bl printf
	mov sp,r6
	vpop {d0-d1}
	pop {r0,r1,r2,r3,r4,r5,r6,lr}
	bx lr
addr_mata: .word mat_a
addr_matb: .word mat_b
addr_matc: .word mat_c
addr_frm: .word  rst
