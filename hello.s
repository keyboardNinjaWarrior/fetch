	.file	"hello.c"
	.text
	.globl	foo                             // -- Begin function foo
	.p2align	2
	.type	foo,@function
foo:                                    // @foo
// %bb.0:
	sub	sp, sp, #16
	strb	w0, [sp, #15]
	ldrb	w8, [sp, #15]
	add	w0, w8, #1
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
                                        // -- End function
	.globl	main                            // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
// %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             // 16-byte Folded Spill
	add	x29, sp, #16
	stur	wzr, [x29, #-4]
	mov	w0, #97                         // =0x61
	bl	foo
	and	w0, w0, #0xff
	ldp	x29, x30, [sp, #16]             // 16-byte Folded Reload
	add	sp, sp, #32
	ret
