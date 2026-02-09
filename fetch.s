	.file		"fetch"
	.globl		_start
	.include	"exit.s"

	.section	.data
file:
	.asciz		"lain.txt"
read:
	.space		1
	
	.section	.text
_start:
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
	// end

	sub	sp,	sp,	#16	// pushing stack 16 bytes up

	// read		(unsigned int fd,
	//		char* buf,
	//		size_t count)

	// using the return value of openat: file descriptor
	
	add	x1,	sp,	#15	// getting address of 1 byte as address where the character will be stored
	mov	x2,	#1		// number of bytes
	mov	x8,	#0x3F		// syscall: 0x3F for read
	svc	#0

	_exit
