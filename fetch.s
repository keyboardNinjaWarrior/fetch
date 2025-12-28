	.file		"fetch"
	.globl		_start

	.section	.data
string:
	.asciz "Hello World!"

	.section	.text
_start:
	// write function starts here
write:
	mov	x0,	#1		// 1 is file discriptor for stdout
	ldr	x1,	=string		// second parameter: address of the fist character of the string
					// = is used to load the address
	mov	x2,	#12		// third paramater: length of the string
	mov	x8,	#64		// x40 is number for write syscall;
	svc	#0			// should be placed in x8

	// exit function starts here
exit:
	mov	x0,	#0		// first parameter in x0
	mov	x8,	#93		// x5D is will be placed in x8
	svc	#0			// calling syscall
	
