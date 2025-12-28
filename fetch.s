	.file		"fetch"
	.globl		_start

	.section	.data
string:
	.asciz "Hello World!"

	.section	.text
_start:
	// write function starts here
write:
	mov	x0,	#1
	ldr	x1,	=string
	mov	x2,	#12
	mov	x8,	#64
	svc	#0

	// exit function starts here
exit:
	mov	x0,	#0		// first parameter in x0
	mov	x8,	#93		// x5D is will be placed in x8
	svc	#0			// calling syscall
	
