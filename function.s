.data

.balign 4
msg1: .asciz "type a no: "

.balign 4
msg2: .asciz " %d multiplied num %d\n"

.balign 4
scan: .asciz "%d"

.balign
num: .word 0

.balign
ret1: .word 0

.balign
ret2: .word 0

.text

mult:
	ldr r1,addr_ret2
	str lr, [r1]
	add r0,r0,r0,LSL #2

	ldr lr,addr_ret2
	ldr lr,[lr]
	bx lr
addr_ret2: .word ret2

.global main

main:
	ldr r1, addr_ret
	str lr,[r1]
	
	ldr r0,addr_msg
	bl printf

	ldr r0, addr_scan
	ldr r1, addr_num
	bl scanf

	ldr r0,addr_num
	ldr r0,[r0]
	bl mult

	mov r2,r0
	ldr r1, addr_num
	ldr r1,[r1]
	ldr r0,addr_msg2
	bl printf

	ldr lr, addr_ret
	ldr lr,[lr]
	bx lr

addr_msg: .word msg1
addr_msg2: .word msg2
addr_ret: .word ret1
addr_scan: .word scan
addr_num: .word num

.global printf
.global scanf

