	.file	"exit"

// #include <stdlib.h>
// [[noreturn]] void exit(int status);
// The exit fucntion causes normal pro-
// cess termination
.macro exit rvalue
	mov	x0, \rvalue
	_exit
.endm

.macro _exit
	mov		x8, #0x5D
	svc		#0
.endm
