	.file		"mem"
	.include	"exit.s"
	.include	"stack.s"
	.global		_start

// brk() and sbrk() change the location
// of  the program  break, which defin-
// es the end of the process's data se-
// gment  (i.e.,  the  program break is 
// the  first  location  after the  end 
// of  the uninitialize data  segment).
// Increasing the program break has the 
// effect  of allocating  memory to the 
// process; decreasing the break deall-
// ocate memory.

.macro	_brk	value 
	mov		x0,	\value
	mov		x8,	#0xD6
	svc		#0
.endm

	.section	.text
_start:
	mov		fp,	sp						// move current stack pointer to frame pointer

	mov		x0, #20
	bl		alloc

	// from "exit.s"
	_exit

	.type alloc, @function
alloc:
	// from "stack.s"
	istk
	
	// from "stack.s"
	dstk
