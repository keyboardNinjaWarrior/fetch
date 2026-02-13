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

	mov	x0,	#-100		// fd: -100 is magic number that tells to look into current directory
	ldr	x1,	=file		// file name
	mov	x2,	#0		// flag: 0 stands for reading
	mov	x3,	#0		// mode: 0 stands for null
	mov	x8,	#0x38		// syscall: 0x38 for openat
	svc		#0	

	// saving the file descriptor on stack
	sub	sp,	sp,	#0x10	// pushing stack 16 bits up
	str	x0,	[sp]		// saved file descriptor on stack

	// storing the first byte on the stack
	sub	sp,	sp,	#0x10	
	
	// read		(unsigned int fd,
	//		char* buf,
	//		size_t count)

	// using the return value of openat: file descriptor
	
	ldr	x0,	[fp,	#-0x10]	// getting the file descriptor from the stack
	add	x1,	sp,	#0x0C	// getting address of 1 byte as address where the character will be stored		
	mov	x2,	#1		// number of bytes
	mov	x8,	#0x3F		// syscall: 0x3F for read
	svc	#0
	
	ldr	w3,	[x1]
	and	w3,	w3,	#0x80
	cmp	w3,	#0x80
	beq	fetch_more_bytes

fetch_more_bytes:
	ldr	x0,	[fp,	#-0x10]		// getting the file descriptor from the stack
	add	x1,	sp,	#0x0D
	mov	x2,	#1
	mov	x8,	#0x3F
	svc	#0	
	
	_exit
