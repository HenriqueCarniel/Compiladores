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
_temp_r_6:	.long	0
_temp_r_7:	.long	0
_temp_r_8:	.long	0
_temp_r_9:	.long	0
_temp_r_10:	.long	0
_temp_r_11:	.long	0
_temp_r_12:	.long	0
_temp_r_13:	.long	0
_temp_r_14:	.long	0
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
# ----------------------------------------	OP_STOREAI_GLOBAL:	storeAI r0 => rbss, 0 
	movl _temp_r_0(%rip), %edx
	movl %edx, global0(%rip)
# ----------------------------------------	OP_LOADI:	loadI 4 => r1 
	movl $4, _temp_r_1(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r1 => rfp, 4 
	movl _temp_r_1(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 9 => r2 
	movl $9, _temp_r_2(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r2 => rfp, 8 
	movl _temp_r_2(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 1 => r3 
	movl $1, _temp_r_3(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r3 => rfp, 0 
	movl _temp_r_3(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r4 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_4(%rip)
# ----------------------------------------	OP_LOADI:	loadI 0 => r5 
	movl $0, _temp_r_5(%rip)
# ----------------------------------------	OP_CMP_GT:	cmp_GT r4, r5 -> r6 
    movl    _temp_r_4(%rip), %eax 
    movl    _temp_r_5(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setg    %al
    movl    %eax, _temp_r_6(%rip)
# ----------------------------------------	OP_CBR:	cbr r6 -> l1, l2 
    movl    _temp_r_6(%rip), %eax 
    test    %eax, %eax
    jnz  l1
    jz  l2
l1:
# ----------------------------------------	OP_LOADI:	loadI 1 => r7 
	movl $1, _temp_r_7(%rip)
# ----------------------------------------	OP_JUMPI:	jumpI -> l3 
	jmp l3
l2:
# ----------------------------------------	OP_LOADI:	loadI 0 => r7 
	movl $0, _temp_r_7(%rip)
l3:
# nop 
	nop
# ----------------------------------------	OP_LOADI:	loadI 0 => r12 
	movl $0, _temp_r_12(%rip)
# ----------------------------------------	OP_CMP_NE:	cmp_NE r7, r12 -> r13 
    movl    _temp_r_7(%rip), %eax 
    movl    _temp_r_12(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_13(%rip)
# ----------------------------------------	OP_CBR:	cbr r13 -> l4, l5 
    movl    _temp_r_13(%rip), %eax 
    test    %eax, %eax
    jnz  l4
    jz  l5
l4:
# nop 
	nop
# ----------------------------------------	OP_LOADI:	loadI 1 => r8 
	movl $1, _temp_r_8(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r8 => rfp, 8 
	movl _temp_r_8(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_LOADAI_GLOBAL:	loadAI rbss, 0 => r9 
	movl global0(%rip), %edx
	movl %edx, _temp_r_9(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r10 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_10(%rip)
# ----------------------------------------	OP_ADD:	add r9, r10 => r11 
    movl    _temp_r_9(%rip), %eax 
    movl    _temp_r_10(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_11(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r11 => rfp, 4 
	movl _temp_r_11(%rip), %edx
	movl %edx, -4(%rbp)
l5:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r14 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_14(%rip)
# ----------------------------------------	RETURN:	return r14
	movl _temp_r_14(%rip), %eax
	popq %rbp
	ret
