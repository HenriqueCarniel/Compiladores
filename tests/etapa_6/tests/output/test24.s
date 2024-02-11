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
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 4 => r2 
	movl $4, _temp_r_2(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r2 => rfp, 4 
	movl _temp_r_2(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 9 => r3 
	movl $9, _temp_r_3(%rip)
# ----------------------------------------	OP_LOADI:	loadI 0 => r4 
	movl $0, _temp_r_4(%rip)
# ----------------------------------------	OP_ADD:	add r3, r4 => r5 
    movl    _temp_r_3(%rip), %eax 
    movl    _temp_r_4(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_5(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r5 => rfp, 0 
	movl _temp_r_5(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r6 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_6(%rip)
# ----------------------------------------	RETURN:	return r6
	movl _temp_r_6(%rip), %eax
	popq %rbp
	ret
