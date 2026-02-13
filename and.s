	.global		_start
	.include	"exit.s"
.section	.text
_start:
	mov	x1,	#8
	and	x0,	x1,	#4
	_exit
