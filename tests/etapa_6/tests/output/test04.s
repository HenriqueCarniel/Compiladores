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
_temp_r_10:	.long	0
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 14 => r0 
	movl $14, _temp_r_0(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r0 => rfp, 4 
	movl _temp_r_0(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r1 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_1(%rip)
# ----------------------------------------	OP_LOADI:	loadI 1 => r2 
	movl $1, _temp_r_2(%rip)
# ----------------------------------------	OP_ADD:	add r1, r2 => r3 
    movl    _temp_r_1(%rip), %eax 
    movl    _temp_r_2(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_3(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r3 => rfp, 0 
	movl _temp_r_3(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r4 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_4(%rip)
# ----------------------------------------	OP_LOADI:	loadI 1 => r5 
	movl $1, _temp_r_5(%rip)
# ----------------------------------------	OP_ADD:	add r4, r5 => r6 
    movl    _temp_r_4(%rip), %eax 
    movl    _temp_r_5(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_6(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r6 => rfp, 4 
	movl _temp_r_6(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r7 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_7(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r8 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_8(%rip)
# ----------------------------------------	OP_ADD:	add r7, r8 => r9 
    movl    _temp_r_7(%rip), %eax 
    movl    _temp_r_8(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_9(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r9 => rfp, 0 
	movl _temp_r_9(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r10 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_10(%rip)
# ----------------------------------------	RETURN:	return r10
	movl _temp_r_10(%rip), %eax
	popq %rbp
	ret
