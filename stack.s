	.file		"stack"

// defines macros:
//	1. istk	-	initialize stack
//	2. dstk	-	delete stack

/* * * * * * * * * * * * * * * * * * * * *
 * (Assembly 9b:  Functions using Stack  *
 * Frames in ARM) [www.youtube.com/watc  *
 * h?v=_9aAvenb6-Y			 *
 *					 *
 * A   comprehensive  video   on   stack *
 * frames				 *
 *					 *
 * A  better implementation  is to  use  *
 * stp and ldp				 *
 * * * * * * * * * * * * * * * * * * * * */ 
.macro initialize_stack 
	sub	sp,	sp,	16		// move stack pointer up to store data
	str	lr,	[sp,	8]		// load pointer to next instruction (x30 or lr) on stack
	str	fp,	[sp]			// load frame point on stack	
	mov	fp,	sp			// moving the frame pointer where stack pointer is
.endm


/* Warning:	doesn't remove the contents
 * from the stack. Bad for security.
 */
.macro delete_stack
	mov	sp,	fp			// moving stack pointer to the stack frame
	ldr	fp,	[sp]			// loading the value at stack pointer (frame pointer) in frame pointer setting frame pointer to the old frame pointer
	ldr	lr,	[sp,	8]		// loading the old next instruction value from the stack in x30/lr
	add	sp,	sp,	16		// moving a stack unit down
	ret
.endm
