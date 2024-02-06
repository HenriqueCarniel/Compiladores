	.file	"ex2.c"
	.text
	.comm	teste1,4,4
	.comm	teste2,4,4
	.comm	teste3,4,4
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	$10, -4(%rbp)
	movl	$20, -8(%rbp)
	jmp	.L2
.L3:
	subl	$1, -4(%rbp)
	addl	$1, -8(%rbp)
.L2:
	cmpl	$0, -4(%rbp)
	jne	.L3
	movl	-4(%rbp), %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, teste1(%rip)
	movl	teste1(%rip), %eax
	popq	%rbp
	ret
