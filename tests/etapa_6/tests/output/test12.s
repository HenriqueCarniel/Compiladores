.data
# Variáveis globais
# Registradores do ILOC
_temp_r_0:	.long	0
_temp_r_1:	.long	0
_temp_r_2:	.long	0
_temp_r_3:	.long	0
_temp_r_4:	.long	0
_temp_r_5:	.long	0
_temp_r_6:	.long	0
_temp_r_7:	.long	0
_temp_r_8:	.long	0
_temp_r_9:	.long	0
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 2 => r0 
	movl $2, _temp_r_0(%rip)
# ----------------------------------------	OP_LOADI:	loadI 4 => r1 
	movl $4, _temp_r_1(%rip)
# ----------------------------------------	OP_LOADI:	loadI 2 => r2 
	movl $2, _temp_r_2(%rip)
# ----------------------------------------	OP_DIV:	div r1, r2 => r3 
    movl    _temp_r_1(%rip), %eax 
    cdq 
    idivl   _temp_r_2(%rip)
    movl    %eax, _temp_r_3(%rip) 
# ----------------------------------------	OP_ADD:	add r0, r3 => r4 
    movl    _temp_r_0(%rip), %eax 
    movl    _temp_r_3(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_4(%rip) 
# ----------------------------------------	OP_LOADI:	loadI 4 => r5 
	movl $4, _temp_r_5(%rip)
# ----------------------------------------	OP_LOADI:	loadI 4 => r6 
	movl $4, _temp_r_6(%rip)
# ----------------------------------------	OP_MULT:	mult r5, r6 => r7 
    movl    _temp_r_5(%rip), %eax 
    imull   _temp_r_6(%rip), %eax 
    movl    %eax, _temp_r_7(%rip) 
# ----------------------------------------	OP_ADD:	add r4, r7 => r8 
    movl    _temp_r_4(%rip), %eax 
    movl    _temp_r_7(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_8(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r8 => rfp, 0 
	movl _temp_r_8(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r9 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_9(%rip)
# ----------------------------------------	RETURN:	return r9
	movl _temp_r_9(%rip), %eax
	popq %rbp
	ret
