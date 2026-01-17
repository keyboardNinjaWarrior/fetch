	.file		"mem"
	.global		_start

	.section	.bss			// skipping space for variables
cur_brk:					// current address of page break
	.skip	8				// reserving 8 bytes
end_brk:					// end of address of page break
	.skip	8				// reserving 8 bytes

// getting initial memory:
// syscall: brk(0) -> initial address
.macro	_brk	value 
	mov	x0,	\value
	mov	x8,	#0xD6
	svc		#0
.endm

	.text
_start:
	_brk	#0				// get inital address
	ldr	x1,	=cur_brk		// stores the the address of cur_brk in x1
						// the '='Rn is used to obtain address here
	str	x0,	[x1]			// stores the value in x0 at the address present in x1
						// [Rn] = drefrencing Rn
exit:
	mov 	x8,	#0x5D
	svc		#0
