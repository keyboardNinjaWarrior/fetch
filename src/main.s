	.file		"main"
	.globl		_start
	.globl		main
	.section	.text
	
	.type		main, @function 
_start:
	bl	main

exit:
	mov	w0, 	#0
	mov	x8, 	#93
	svc	#0

