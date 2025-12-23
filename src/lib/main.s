	.file		"main"
	.globl		_start
	.globl		exit
	.extern		main
	
	.section	.text
	.type		main, @function 

// starting point of program
_start:
	bl	main
	bl	exit

/* exit:
 * Whatever is in register x0, it is pushed being retuned
 * svc 	= syscall
 * exit	= 93
 */
	.type		exit, @function
exit:
	mov	x8, 	#93
	svc	#0

