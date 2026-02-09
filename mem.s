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

.macro	brk, value						
	mov		x0,	\value
	_brk
.endm

.macro	_brk 
	mov		x8,	#0xD6
	svc		#0
.endm

	.section	.text
_start:
	mov		x0,	#16
	bl		alloc
	exit	#0	

	.type	alloc, @function
alloc:
	istk

	brk		#0
	add		x0,	x0,	x8	
	_brk

	ldr		x1,	=initial_brk
	str		x1,	[x1]
