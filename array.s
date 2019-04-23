.data
.balign 4
a: .skip 400

.text 
.global main

main:
	ldr r1, addr_a
	mov r2,#0
loop:
	cmp r2,#100
	beq end
	add r3,r1,r2,LSL #2
	str r2,[r3]
	add r2,r2,#1
	b loop
end:
	bx lr
addr_a: .word a
