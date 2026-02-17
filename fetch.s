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

	// saving the file descriptor on stack
	sub	sp,	sp,	0x10	// pushing stack 16 bits up
	str	w0,	[sp,	12]	// saved file descriptor (4 bytes) on stack

	// storing the first byte on the stack
	
	// read		(unsigned int fd,
	//		char* buf,
	//		size_t count)

	// using the return value of openat: file descriptor at x0
	add	x1,	sp,	8		// getting stack address for storing initial byte		
	mov	w2,	1			// number of bytes
	mov	w8,	0x3F			// syscall: 0x3F for read
	svc	0

	// determining the number of bytes in unicode
	// w3 holds the first byte
	// w4 holds the bit mask
	// w5 holds the counter
	// w6 result of comparison

	ldrb	w3,	[x1]					// load the first byte
	mov	w4,	0b10000000				// move the mask bit into the register
	mov	w5,	0					// set the counter

count_bytes:
	and	w6,	w3,	w4				// first byte logical and bit mask and store the result
	cmp	w6,	w4					// compare the result with bit mask
	bne	write_bytes_on_stack
	add	w4,	w4,	w4,	LSR	#1		// set the right bit 1
	add	w5,	w5,	1				// increase the counter by one
	b	count_bytes

	// we already have one in w2
	// hence one byte will be read
write_bytes_on_stack:
	ldr	w0,	[sp,	12]		// loading the file descriptor
	add	x1,	x1,	1		// moving the stack pointer one byte up
	svc	0

	sub	w5,	w5,	1		// decrementing the counter
	cmp	w5,	0			// if all bytes are read
	bne	write_bytes_on_stack
	
	mov	w0,	1
	add	x1,	sp,	8
	mov	w2,	4
	mov	w8,	0x40
	svc	0

	_exit
