	.file		"mem"
	.global		_start

.section	.bss				// skipping space for variables
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

exit:
	mov 	x8,	#0x5D
	svc		#0
