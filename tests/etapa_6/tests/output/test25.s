.data
# Variáveis globais
global0:	.long	0
# Registradores do ILOC
_temp_r_0:	.long	0
_temp_r_1:	.long	0
_temp_r_2:	.long	0
_temp_r_3:	.long	0
_temp_r_4:	.long	0
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 3 => r1 
	movl $3, _temp_r_1(%rip)
# ----------------------------------------	OP_LOADI:	loadI 3 => r2 
	movl $3, _temp_r_2(%rip)
# ----------------------------------------	OP_MULT:	mult r1, r2 => r3 
    movl    _temp_r_1(%rip), %eax 
    imull   _temp_r_2(%rip), %eax 
    movl    %eax, _temp_r_3(%rip) 
# ----------------------------------------	OP_STOREAI_GLOBAL:	storeAI r3 => rbss, 0 
	movl _temp_r_3(%rip), %edx
	movl %edx, global0(%rip)
# ----------------------------------------	OP_LOADAI_GLOBAL:	loadAI rbss, 0 => r4 
	movl global0(%rip), %edx
	movl %edx, _temp_r_4(%rip)
# ----------------------------------------	RETURN:	return r4
	movl _temp_r_4(%rip), %eax
	popq %rbp
	ret
