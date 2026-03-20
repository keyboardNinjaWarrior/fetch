.file		"fetch.s"
.include	"exit.s"

.global		_start

.section	.text
_start:
	// saving cursor position
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */
	
	mov w0, 1								// file descriptor for stdout
	adr x1, save_cursor						// puting address of string
	mov w2, restore_cursor - save_cursor 	// length of string
	mov w8, 0x40							// syscall for write
	svc	0

	// opening file lain.sixel
	
	/* Using syscall openat */
	/* https://www.man7.org/linux/man-pages/man3/openat.3p.html */
	/* https://www.man7.org/linux/man-pages/man3/open.3p.html */

	mov w0, -100		// -100 magic number for searching in te current directory
	adr x1, file		// loading the string
	mov w2, 0			// 0000 for readonly
	mov w8, 0x38		// syscall for openat
	svc 0
	
	sub sp, sp, 16		// making room on the stack
	str w0, [sp, 12]	// stores the file discriptor (int) on the stack 


read_byte_from_file:
	
	// reading bytes from file	
	/* https://www.man7.org/linux/man-pages/man2/read.2.html */

	ldr w0, [sp, 12]	// file discriptor being loaded from stack
	add x1, sp, 11		// giving address of a byte variable created on the stack
	mov w2, 1			// number of bytes to be read from file
	mov w8, 0x3F		// syscall for read
	svc 0	
	
	cmp w0, 0			// checking for any errors or eof
	ble close_file		// exiting in case of any

	// writing byte on stdout
	// x1 and x2 already have the address and number of bytes stored

	/* https://www.man7.org/linux/man-pages/man2/write.2.html */

	mov w0, 1				// 1 is magic number for stdout's file descriptor	
	mov w8, 0x40			// syscall for write
	svc 0
	
	b read_byte_from_file	// continue the loop
	
	// closing the file
	/* https://www.man7.org/linux/man-pages/man2/close.2.html */

close_file:
	ldr w0, [sp, 12]		// loading file descriptor 
	mov x8,	0x39			// syscall for close
	svc 0

	// restoring cursor position
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	

	mov w0, 1												// file descriptor for stdout
	adr x1, restore_cursor									// puting address of string
	mov w2, move_cursor_right_35_units - restore_cursor		// length of string
	mov w8, 0x40											// syscall for write
	svc 0

	// moving cursor right of the picture
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	

	mov	w0,	1												// file descriptor for stdout
	adr	x1,	move_cursor_right_35_units						// puting address of string
	mov	w2,	operating_system - move_cursor_right_35_units 	// length of string
	mov	w8,	0x40											// syscall for write
	svc	0

	// printing "Operating System:" in pink
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	

	mov w0, 1												// file descriptor		
	adr x1, operating_system								// loading address of string	
	mov w2, architecture - operating_system					// length of sting		
	mov w8, 0x40											// syscall for write		
	svc 0

	// fetching utsname structure
	/* https://www.man7.org/linux/man-pages/man2/uname.2.html */
	
	adr x0, utsname		// address where the structure will be store
	mov w8, 0xA0		// sycall for uname
	svc 0

	// writing operating system from structure
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	
	
	mov w0, 1			// file descriptor for stdout	
	adr x1, utsname		// puting address of string	
	mov w2, 65			// length of string		
	mov w8, 0x40		// syscall for write		
	svc 0

	// printing "Architecture:" in pink
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	

	mov w0, 1						// file descriptor		
	adr x1, architecture			// loading address of string	
	mov w2, kernel - architecture   // length of sting		
	mov w8, 0x40                    // syscall for write		
	svc 0
	
	// writing architecture from structure
	// executing getprop
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	
	
	mov w0, 1				// file descriptor for stdout
	adr x1, utsname			// puting address of string
	add x1, x1, (65 * 4)	// getting the value of architeture
	mov w2, 65				// length of string
	mov w8, 0x40			// syscall for write
	svc 0

	// printing "Architecture:" in pink
	/* https://www.man7.org/linux/man-pages/man2/write.2.html */	

	mov w0, 1							// file descriptor		
	adr x1, kernel						// loading address of string	
	mov w2, getprop - kernel		    // length of sting		
	mov w8, 0x40						// syscall for write		
	svc 0
	
	// executing getrop instruction
	/* https://www.man7.org/linux/man-pages/man2/execve.2.html */

	adr x0,	getprop		// loading address of string having address of getprop
	adr	x1,	argv		// address of array that contains parameters
	adr x2, envp		// null pointer
	mov x8, 0xDD		// syscall for execve
	svc 0

	exit 0
	

	.section	.rodata
	.balign	8

argv:
	.dword	getprop
	.dword	ro.kernel.version

envp:
	.dword	0

file:		
	.asciz	"lain.sixel"

/* (ANSI Escape Sequences)																					* 
 * [https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797/be1f5afaeb7996c5d966039d88108f45b0f58e0f] */

save_cursor:
	.byte 0x1B; .ascii "7"

restore_cursor:
	.byte 0x1B; .ascii "8"

move_cursor_right_35_units:
	.byte 0x1B; .ascii "["; .ascii "35C"

operating_system:		
	.byte 0x1B; .ascii "7"
	.byte 0x1B; .ascii "[1m"
	.byte 0x1B; .ascii "[38;2;231;175;163m"; .ascii "Operating System:"
	.byte 0x1B; .ascii "[5C"
	.byte 0x1B; .ascii "[0m"
	.byte 0				

architecture:
	.byte 0x1B; .ascii "8"
	.byte 0x1B; .ascii "[1B"
	.byte 0x1B; .ascii "7"
	.byte 0x1B; .ascii "[1m"
	.byte 0x1B; .ascii "[38;2;231;175;163m"; .ascii "Architecture:"
	.byte 0x1B; .ascii "[9C"
	.byte 0x1B; .ascii "[0m"	
	.byte 0

kernel:
	.byte 0x1B; .ascii "8"
	.byte 0x1B; .ascii "[1B"
	.byte 0x1B; .ascii "7"
	.byte 0x1B; .ascii "[1m"	
	.byte 0x1B; .ascii "[38;2;231;175;163m"; .ascii "Kernel:"	
	.byte 0x1B; .ascii "[15C"
	.byte 0x1B; .ascii "[0m"	
	.byte	0

getprop:
	.asciz	"/data/data/com.termux/files/usr/bin/getprop"

ro.kernel.version:
	.asciz	"ro.kernel.version"

.section	.bss

/* struct utsname defined in file	*
 * usr/include/sys/uname.h			*/

utsname:
	.space	65 * 5
