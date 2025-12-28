	.file		"fetch"
	.globl		_start
	.section	.text

_start:
	// write function starts here


	// exit function starts here
exit:
	mov	x0,	#0		// return value in x0
	mov	x8,	#93		// x5D is will be placed in x8
	svc	#0			// calling syscall
	
