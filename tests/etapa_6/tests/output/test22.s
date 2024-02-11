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
_temp_r_12:	.long	0
_temp_r_13:	.long	0
_temp_r_14:	.long	0
_temp_r_15:	.long	0
_temp_r_16:	.long	0
_temp_r_17:	.long	0
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 1 => r0 
	movl $1, _temp_r_0(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r0 => rfp, 0 
	movl _temp_r_0(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 0 => r1 
	movl $0, _temp_r_1(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r1 => rfp, 4 
	movl _temp_r_1(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 2 => r2 
	movl $2, _temp_r_2(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r2 => rfp, 8 
	movl _temp_r_2(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 3 => r3 
	movl $3, _temp_r_3(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r3 => rfp, 12 
	movl _temp_r_3(%rip), %edx
	movl %edx, -12(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r4 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_4(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r5 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_5(%rip)
# ----------------------------------------	OP_CMT_LT:	cmp_LT r4, r5 -> r6 
    movl    _temp_r_4(%rip), %eax 
    movl    _temp_r_5(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setl    %al
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
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r8 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_8(%rip)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 12 => r9 
	movl -12(%rbp), %edx
	movl %edx, _temp_r_9(%rip)
# ----------------------------------------	OP_CMT_LT:	cmp_LT r8, r9 -> r10 
    movl    _temp_r_8(%rip), %eax 
    movl    _temp_r_9(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setl    %al
    movl    %eax, _temp_r_10(%rip)
# ----------------------------------------	OP_CBR:	cbr r10 -> l4, l5 
    movl    _temp_r_10(%rip), %eax 
    test    %eax, %eax
    jnz  l4
    jz  l5
l4:
# ----------------------------------------	OP_LOADI:	loadI 1 => r11 
	movl $1, _temp_r_11(%rip)
# ----------------------------------------	OP_JUMPI:	jumpI -> l6 
	jmp l6
l5:
# ----------------------------------------	OP_LOADI:	loadI 0 => r11 
	movl $0, _temp_r_11(%rip)
l6:
# nop 
	nop
# ----------------------------------------	OP_AND:	and r7, r11 => r12 
    movl    _temp_r_7(%rip), %eax 
    movl    _temp_r_11(%rip), %edx 
    test    %eax, %edx
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_12(%rip)
# ----------------------------------------	OP_LOADI:	loadI 0 => r15 
	movl $0, _temp_r_15(%rip)
# ----------------------------------------	OP_CMP_NE:	cmp_NE r12, r15 -> r16 
    movl    _temp_r_12(%rip), %eax 
    movl    _temp_r_15(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_16(%rip)
# ----------------------------------------	OP_CBR:	cbr r16 -> l7, l8 
    movl    _temp_r_16(%rip), %eax 
    test    %eax, %eax
    jnz  l7
    jz  l8
l7:
# nop 
	nop
# ----------------------------------------	OP_LOADI:	loadI 2 => r13 
	movl $2, _temp_r_13(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r13 => rfp, 16 
	movl _temp_r_13(%rip), %edx
	movl %edx, -16(%rbp)
# ----------------------------------------	OP_JUMPI:	jumpI -> l9 
	jmp l9
l8:
# nop 
	nop
# ----------------------------------------	OP_LOADI:	loadI 3 => r14 
	movl $3, _temp_r_14(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r14 => rfp, 16 
	movl _temp_r_14(%rip), %edx
	movl %edx, -16(%rbp)
l9:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 16 => r17 
	movl -16(%rbp), %edx
	movl %edx, _temp_r_17(%rip)
# ----------------------------------------	RETURN:	return r17
	movl _temp_r_17(%rip), %eax
	popq %rbp
	ret
