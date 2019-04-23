.data

msg1: .asciz "type a num "
format: .asciz "%d"
msg2: .asciz "fact %d is %d"

.text
	str lr ,[sp,#-4]
	sub sp,sp,#4
	
	ldr r0,addr_msg1
	bl printf

	ldr r0,addr_frm
	mov r1,sp
	bl scanf
