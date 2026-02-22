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
	
	sub	sp,	sp,	0x10
	str	w0,	[sp,	12]

	bl	write_character_from_file	
	
	ldr	w0,	[sp,	12]
	bl	write_character_from_file

	exit	0	
