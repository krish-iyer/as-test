.text
.global main

main:
	mov r0, #1
	mov r2,#1
	mov r1,#100
loop:
	cmp r1,r2
	beq end
	add r2,#1
	add r0,r2
	b loop
end:
	bx lr
