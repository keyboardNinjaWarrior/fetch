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
	//			const char* filename, 
	//			int flags, 
	//			umode_tmode)

	mov	x0,	#-100		// fd: -100 is magic number that tells to look into current directory
	ldr	x1,	=file		// file name
	mov	x2,	#0			// flag: 0 stands for reading
	mov	x3,	#0			// mode: 0 stands for null
	mov	x8,	#0x38		// syscall: 0x38 for openat
	svc	#0
	
	// read		(unsigned int fd,
	//			char* buf,
	//			size_t count)

	ldr x1, =read
	mov	x2, #1
	mov	x8,	#0x3F
	svc	#0

	_exit
