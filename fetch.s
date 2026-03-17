.file		"fetch.s"
.include	"exit.s"

.global		_start

.section	.data
file:		
	.asciz	"lain.sixel"

/* (ANSI Escape Sequences)										    * 
 * [https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797/be1f5afaeb7996c5d966039d88108f45b0f58e0f] */
save_cursor:					/* 2 */
	.byte	0x1B
	.ascii	"7"

restore_cursor:					/* 2 */
	.byte	0x1B
	.ascii	"8"

move_cursor_right_35_units:			/* 5 */
	.byte	0x1B
	.ascii	"["
	.ascii	"35C"

operating_system:				/* 45 */
	.byte	0x1B
	.ascii	"[1m"
	.byte	0x1B
	.ascii	"[38;2;231;175;163m"
	
	.ascii	"Operating System:"
	.byte	0x1B
	.ascii	"[0m"
	.byte	0

.section	.text
_start:
	// saving cursor position
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */
	
	mov	w0,	1		// file descriptor for stdout
	ldr	x1,	=save_cursor	// puting address of string
	mov	w2,	2		// length of string
	mov	w8,	0x40		// syscall for write
	svc	0

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
	mov	w8,	0x3F		// syscall for read
	svc	0	
	
	cmp	w0,	0		// checking for any errors or eof
	ble	close_file		// exiting in case of any
	

	// writing byte on stdout
	// x1 and x2 already have the address and number of bytes stored

	/* https://www.man7.org/linux/man-pages/man2/write.2.html */

	mov	w0,	1		// 1 is magic number for stdout's file descriptor	
	mov	w8,	0x40		// syscall for write
	svc	0
	
	b	read_byte_from_file	// continue the loop
	
	// closing the file
	/* https://www.man7.org/linux/man-pages/man2/close.2.html */

close_file:
	ldr	w0,	[sp,	12]	// loading file descriptor 
	mov	x8,	0x39		// syscall for close
	svc	0

	// restoring cursor position
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	

	mov	w0,	1		// file descriptor for stdout
	ldr	x1,	=restore_cursor	// puting address of string
	mov	w2,	2		// length of string
	mov	w8,	0x40		// syscall for write
	svc	0

	// moving cursor right of the picture
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	

	mov	w0,	1				// file descriptor for stdout
	ldr	x1,	=move_cursor_right_35_units	// puting address of string
	mov	w2,	5				// length of string
	mov	w8,	0x40				// syscall for write
	svc	0

	mov	w0,	1
	ldr	x1,	=operating_system
	mov	w2,	45
	mov	w8,	0x40
	svc	0
	


	exit	0
