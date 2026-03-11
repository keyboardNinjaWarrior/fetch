.file		"fetch.s"
.include	"exit.s"
.global		_start

.section	.data
file:		
	.asciz	"lain.sixel"

.section	.text
_start:
	mov	fp,	sp		// moving stack pointer into frame pointer for stack managment
	
	// opening file lain.sixel
	
	/* Using syscall openat */
	/* https://www.man7.org/linux/man-pages/man3/openat.3p.html */
	/* https://www.man7.org/linux/man-pages/man3/open.3p.html */

	mov	w0,	-100		// -100 magic number for searching in te current directory
	ldr	w1,	=file		// loading the string
	mov	w2,	0		// 0000 for readonly
	mov	w8,	0x38		// syscall for openat
	svc	0
	
	sub	sp,	sp,	16	// making room on the stack
	str	w0,	[sp,	12]	// stores the file discriptor (int) on the stack 
	

	// reading bytes from file	
	ldr	w0,	[sp,	12]
	add	x1,	sp,	11
	mov	w2,	1
	mov	x8,	0x3F
	svc	0	
	
	_exit
