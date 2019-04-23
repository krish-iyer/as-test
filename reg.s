.data
.balign 4
a:
	.int 4, 4, 4, 4
.balign 4
b:
	.int 8, 8, 8, 8
.balign 4
c:
	.int 0, 0, 0, 0

.text
.global main
main:
	ldr r0,addr_a
	ldr r1,addr_b
	ldr r2,addr_c
	mov r4,#3
loop:
	cmp r4,#0
	beq end
	ldr r5,[r0]
	ldr r6,[r1]
	ldr r7,[r2]
	add r7,r5,r6
	str r7,[r2]
	add r0,r0,#4
	add r1,r1,#4
	add r2,r2,#4
	sub r4,#1
	b loop
end:
	bx lr

addr_a: .word a
addr_b: .word b
addr_c:	.word c
