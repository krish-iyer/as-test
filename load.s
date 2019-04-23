.data

.balign 4

var1:
	.word 0

.balign 4

var2:
	.word 0

.text

.balign 4
.global main

main:
	ldr r1, addr_var1
	mov r3, #3
	str r3, [r1]
	
	ldr r2, addr_var2
	mov r4, #4
	str r4, [r2]

	ldr r1,[r1]
	ldr r2,[r2]
	add r0, r1,r2
	bx lr

addr_var1: .word var1
addr_var2: .word var2
