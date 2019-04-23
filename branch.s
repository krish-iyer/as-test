.text
.global main

main:
	mov r0,#2
	mov r1,#2
	cmp r1,r0
	beq eq
n_eq:
	mov r0, #0
	b end
eq:
	mov r0, #1
end:
	bx lr
