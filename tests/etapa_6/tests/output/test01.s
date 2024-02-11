.data
# Variáveis globais
global0:	.long	0
# Registradores do ILOC
_temp_r_0:	.long	0
_temp_r_1:	.long	0
_temp_r_2:	.long	0
_temp_r_3:	.long	0
_temp_r_4:	.long	0
_temp_r_5:	.long	0
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 9 => r0 
	movl $9, _temp_r_0(%rip)
# ----------------------------------------	OP_STOREAI_GLOBAL:	storeAI r0 => rbss, 0 
	movl _temp_r_0(%rip), %edx
	movl %edx, global0(%rip)
# ----------------------------------------	OP_LOADI:	loadI 4 => r1 
	movl $4, _temp_r_1(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r1 => rfp, 8 
	movl _temp_r_1(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_LOADAI_GLOBAL:	loadAI rbss, 0 => r2 
	movl global0(%rip), %edx
	movl %edx, _temp_r_2(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r3 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_3(%rip)
# ----------------------------------------	OP_ADD:	add r2, r3 => r4 
    movl    _temp_r_2(%rip), %eax 
    movl    _temp_r_3(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_4(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r4 => rfp, 12 
	movl _temp_r_4(%rip), %edx
	movl %edx, -12(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 12 => r5 
	movl -12(%rbp), %edx
	movl %edx, _temp_r_5(%rip)
# ----------------------------------------	RETURN:	return r5
	movl _temp_r_5(%rip), %eax
	popq %rbp
	ret
