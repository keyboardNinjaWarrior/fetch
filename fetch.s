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
	

read_byte_from_file:
	
	// reading bytes from file	
	/* https://www.man7.org/linux/man-pages/man2/read.2.html */

	ldr	w0,	[sp,	12]	// file discriptor being loaded from stack
	add	x1,	sp,	11	// givving address of a byte variable created on the stack
	mov	w2,	1		// number of bytes to be read from file
	mov	x8,	0x3F		// syscall for read
	svc	0	
	
	cmp	w0,	0		// checking for any errors or eof
	ble	close_file			// exiting in case of any
	

	// writing byte on stdout
	// x1 and x2 already have the address and number of bytes stored

	/* https://www.man7.org/linux/man-pages/man2/write.2.html */

	mov	w0,	1		// 1 is magic number for stdout's file descriptor	
	mov	x8,	0x40		// syscall for read
	svc	0
	
	b	read_byte_from_file	// continue the loop
	
	// closing the file
	/* https://www.man7.org/linux/man-pages/man2/close.2.html */

close_file:
	ldr	w0,	[sp,	12]	// loading file descriptor 
	mov	x8,	0x39		// syscall for close
	svc	0

	exit	0
