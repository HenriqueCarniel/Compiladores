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
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 10 => r0 
	movl $10, _temp_r_0(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r0 => rfp, 0 
	movl _temp_r_0(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 2 => r1 
	movl $2, _temp_r_1(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r1 => rfp, 4 
	movl _temp_r_1(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 0 => r2 
	movl $0, _temp_r_2(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r2 => rfp, 8 
	movl _temp_r_2(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 0 => r13 
	movl $0, _temp_r_13(%rip)
l4:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r3 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_3(%rip)
# ----------------------------------------	OP_LOADI:	loadI 5 => r4 
	movl $5, _temp_r_4(%rip)
# ----------------------------------------	OP_CMP_GT:	cmp_GT r3, r4 -> r5 
    movl    _temp_r_3(%rip), %eax 
    movl    _temp_r_4(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setg    %al
    movl    %eax, _temp_r_5(%rip)
# ----------------------------------------	OP_CBR:	cbr r5 -> l1, l2 
    movl    _temp_r_5(%rip), %eax 
    test    %eax, %eax
    jnz  l1
    jz  l2
l1:
# ----------------------------------------	OP_LOADI:	loadI 1 => r6 
	movl $1, _temp_r_6(%rip)
# ----------------------------------------	OP_JUMPI:	jumpI -> l3 
	jmp l3
l2:
# ----------------------------------------	OP_LOADI:	loadI 0 => r6 
	movl $0, _temp_r_6(%rip)
l3:
# nop 
	nop
# ----------------------------------------	OP_CMP_NE:	cmp_NE r6, r13 -> r14 
    movl    _temp_r_6(%rip), %eax 
    movl    _temp_r_13(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_14(%rip)
# ----------------------------------------	OP_CBR:	cbr r14 -> l5, l6 
    movl    _temp_r_14(%rip), %eax 
    test    %eax, %eax
    jnz  l5
    jz  l6
l5:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r7 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_7(%rip)
# ----------------------------------------	OP_LOADI:	loadI 1 => r8 
	movl $1, _temp_r_8(%rip)
# ----------------------------------------	OP_SUB:	sub r7, r8 => r9 
    movl    _temp_r_7(%rip), %eax 
    movl    _temp_r_8(%rip), %edx 
    subl    %edx, %eax 
    movl    %eax, _temp_r_9(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r9 => rfp, 0 
	movl _temp_r_9(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r10 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_10(%rip)
# ----------------------------------------	OP_LOADI:	loadI 1 => r11 
	movl $1, _temp_r_11(%rip)
# ----------------------------------------	OP_ADD:	add r10, r11 => r12 
    movl    _temp_r_10(%rip), %eax 
    movl    _temp_r_11(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_12(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r12 => rfp, 8 
	movl _temp_r_12(%rip), %edx
	movl %edx, -8(%rbp)
# ----------------------------------------	OP_JUMPI:	jumpI -> l4 
	jmp l4
l6:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r15 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_15(%rip)
# ----------------------------------------	RETURN:	return r15
	movl _temp_r_15(%rip), %eax
	popq %rbp
	ret
