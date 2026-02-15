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
	str	x0,	[sp,	#12]	// saved file descriptor (4 bytes) on stack

	// storing the first byte on the stack
	
	// read		(unsigned int fd,
	//		char* buf,
	//		size_t count)

	// using the return value of openat: file descriptor at x0
	add	x1,	sp,	#11		// getting stack address for storing initial byte		
	mov	x2,	#1			// number of bytes
	mov	x8,	#0x3F			// syscall: 0x3F for read
	svc	#0

	// determining the number of bytes in unicode
	// w3 holds the first byte
	// w4 holds the bit mask
	// w5 holds the counter
	// w6 result of comparison

	ldrb	w3,	[x1]					// load the first byte
	mov	w4,	#0b10000000				// move the mask bit into the register
	mov	w5,	#0					// set the counter

count_bytes:
	and	w6,	w3,	w4				// first byte logical and bit mask and store the result
	cmp	w6,	w4					// compare the result with bit mask
	bne	exit_count_bytes_loop
	add	w4,	w4,	w4,	LSR	#1		// set the right bit 1
	add	w5,	w5,	#1				// increase the counter by one
	b	count_bytes

exit_count_bytes_loop:
	
	// calling read syscall
	ldr	x0,	[sp,	#12]		// loading the file descriptor
	add	x1,	sp,	#11		// getting the top of stack address
	sub	x1,	x1,	x5		// making room for upcoming bytes
	mov	x2,	x5			// number of bytes
	mov	x8,	#0x3F			// syscall: 0x3F for read
	svc	#0
	
	// size_t bytes (third argument) for syscall write
	mov	w2,	w5			// copying the count in w2
	add	w2,	w2,	#1		// increasing the count by one

	// x1 - address of the bytes
	// w3 - the previous byte and the result
	// w4 - the upcoming bytes from stack
	// w5 - number of bytes

unicode_loop:
	ldrb	w4,	[x1]			// load the byte in the register
	lsl	w3,	w3,	#8		// shift the previous byte by 8 bits
	add	w3,	w3,	w4		// add the the two bytes togather
	sub	x5,	x5,	#1		// decrement the counter
	add	x1,	x1,	#1		// decrement the stack address
	
	cmp	x5,	#0
	bgt	unicode_loop
	
	// const char* buf (second argument) for write syscall
	add	x1,	sp,	#4		// address on stack where characters will be stored
	str	w3,	[x1]			// storing the unicode on stack

	// write	(unsigned int fd,
	//		 const char* buf,
	//		 size_t count)

	mov	x0,	#1			// loading file discriptor: stdout
	mov	x8,	#0x40
	svc	#0
	
	_exit
