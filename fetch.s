	.file		"fetch"
	.globl		_start
	.include	"exit.s"
	
	.section	.data
file:
	.asciz		"lain.txt"
	
	.section	.text
_start:
	mov	fp,	sp		// moving stack pointer in frame pointer

	// openat	(int dfd, 
	//		const char* filename, 
	//		int flags, 
	//		umode_tmode)

	mov	w0,	-100		// fd: -100 is magic number that tells to look into current directory
	ldr	w1,	=file		// file name
	mov	w2,	0		// flag: 0 stands for reading
	mov	w3,	0		// mode: 0 stands for null
	mov	w8,	0x38		// syscall: 0x38 for openat
	svc	0

	sub	sp,	sp,	0x10	// pushing the stack one unit up
	str	w0,	[sp,	12]	// storing the file discriptor

continue_reading_from_file:
	bl	read_char_from_file	// reading a character from file		
	cmp	w0,	0		// looking for and end of file or an error
	ble	end

	bl	write_char
	ldr	w0,	[sp,	12]
	b	continue_reading_from_file	

end:
	_exit
