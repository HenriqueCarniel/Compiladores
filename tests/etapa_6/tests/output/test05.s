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
_temp_r_11:	.long	0
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
# ----------------------------------------	OP_LOADI:	loadI 16 => r1 
	movl $16, _temp_r_1(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r1 => rfp, 8 
	movl _temp_r_1(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r2 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_2(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r3 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_3(%rip)
# ----------------------------------------	OP_SUB:	sub r2, r3 => r4 
    movl    _temp_r_2(%rip), %eax 
    movl    _temp_r_3(%rip), %edx 
    subl    %edx, %eax 
    movl    %eax, _temp_r_4(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r4 => rfp, 0 
	movl _temp_r_4(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r5 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_5(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r6 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_6(%rip)
# ----------------------------------------	OP_SUB:	sub r5, r6 => r7 
    movl    _temp_r_5(%rip), %eax 
    movl    _temp_r_6(%rip), %edx 
    subl    %edx, %eax 
    movl    %eax, _temp_r_7(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r7 => rfp, 4 
	movl _temp_r_7(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r8 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_8(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r9 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_9(%rip)
# ----------------------------------------	OP_SUB:	sub r8, r9 => r10 
    movl    _temp_r_8(%rip), %eax 
    movl    _temp_r_9(%rip), %edx 
    subl    %edx, %eax 
    movl    %eax, _temp_r_10(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r10 => rfp, 8 
	movl _temp_r_10(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r11 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_11(%rip)
# ----------------------------------------	RETURN:	return r11
	movl _temp_r_11(%rip), %eax
	popq %rbp
	ret
