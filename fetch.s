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
	str	x0,	[fp,	#-8]	// saved file descriptor on stack

	// storing the first byte on the stack
	
	// read		(unsigned int fd,
	//		char* buf,
	//		size_t count)

	// using the return value of openat: file descriptor at x0
	mov	x1,	sp		// getting address of 1 byte as address where the character will be stored		
	mov	x2,	#1		// number of bytes
	mov	x8,	#0x3F		// syscall: 0x3F for read
	svc	#0

	// determining the number of bytes in unicode
	// w3 holds the first byte
	// w4 holds the bit mask
	// w5 holds the counter
	// w6 result of comparison

	ldr	w3,	[x1]					// load the first byte
	mov	w4,	#0b10000000				// move the mask bit into the register
	mov	w5,	#1					// set the counter

count_bytes:
	and	w6,	w3,	w4				// first byte logical and bit mask and store the result
	cmp	w6,	w4					// compare the result with bit mask
	bne	exit_count_bytes_loop
	add	w4,	w4,	w4,	LSR	#1		// set the right bit 1
	add	w5,	w5,	#1				// increase the counter by one
	b	count_bytes

exit_count_bytes_loop:

	ldr	x0,	[fp,	#-8]	
	add	x1,	sp,	x5	// getting address of 1 byte as address where the character will be stored		
	mov	x2,	x5		// number of bytes
	mov	x8,	#0x3F		// syscall: 0x3F for read
	svc	#0
	
	_exit
