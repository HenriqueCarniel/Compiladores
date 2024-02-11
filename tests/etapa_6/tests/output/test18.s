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
_temp_r_18:	.long	0
_temp_r_19:	.long	0
_temp_r_20:	.long	0
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
# ----------------------------------------	OP_LOADI:	loadI 0 => r18 
	movl $0, _temp_r_18(%rip)
l7:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 8 => r3 
	movl -8(%rbp), %edx
	movl %edx, _temp_r_3(%rip)
# ----------------------------------------	OP_LOADI:	loadI 2 => r4 
	movl $2, _temp_r_4(%rip)
# ----------------------------------------	OP_CMP_EQ:	cmp_EQ r3, r4 -> r5 
    movl    _temp_r_3(%rip), %eax 
    movl    _temp_r_4(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    sete    %al
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
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r7 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_7(%rip)
# ----------------------------------------	OP_LOADI:	loadI 5 => r8 
	movl $5, _temp_r_8(%rip)
# ----------------------------------------	OP_CMP_GT:	cmp_GT r7, r8 -> r9 
    movl    _temp_r_7(%rip), %eax 
    movl    _temp_r_8(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setg    %al
    movl    %eax, _temp_r_9(%rip)
# ----------------------------------------	OP_CBR:	cbr r9 -> l4, l5 
    movl    _temp_r_9(%rip), %eax 
    test    %eax, %eax
    jnz  l4
    jz  l5
l4:
# ----------------------------------------	OP_LOADI:	loadI 1 => r10 
	movl $1, _temp_r_10(%rip)
# ----------------------------------------	OP_JUMPI:	jumpI -> l6 
	jmp l6
l5:
# ----------------------------------------	OP_LOADI:	loadI 0 => r10 
	movl $0, _temp_r_10(%rip)
l6:
# nop 
	nop
# ----------------------------------------	OP_AND:	and r6, r10 => r11 
    movl    _temp_r_6(%rip), %eax 
    movl    _temp_r_10(%rip), %edx 
    test    %eax, %edx
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_11(%rip)
# ----------------------------------------	OP_CMP_NE:	cmp_NE r11, r18 -> r19 
    movl    _temp_r_11(%rip), %eax 
    movl    _temp_r_18(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_19(%rip)
# ----------------------------------------	OP_CBR:	cbr r19 -> l8, l9 
    movl    _temp_r_19(%rip), %eax 
    test    %eax, %eax
    jnz  l8
    jz  l9
l8:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r12 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_12(%rip)
# ----------------------------------------	OP_LOADI:	loadI 1 => r13 
	movl $1, _temp_r_13(%rip)
# ----------------------------------------	OP_SUB:	sub r12, r13 => r14 
    movl    _temp_r_12(%rip), %eax 
    movl    _temp_r_13(%rip), %edx 
    subl    %edx, %eax 
    movl    %eax, _temp_r_14(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r14 => rfp, 0 
	movl _temp_r_14(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r15 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_15(%rip)
# ----------------------------------------	OP_LOADI:	loadI 1 => r16 
	movl $1, _temp_r_16(%rip)
# ----------------------------------------	OP_ADD:	add r15, r16 => r17 
    movl    _temp_r_15(%rip), %eax 
    movl    _temp_r_16(%rip), %edx 
    addl    %edx, %eax 
    movl    %eax, _temp_r_17(%rip) 
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r17 => rfp, 4 
	movl _temp_r_17(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_JUMPI:	jumpI -> l7 
	jmp l7
l9:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r20 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_20(%rip)
# ----------------------------------------	RETURN:	return r20
	movl _temp_r_20(%rip), %eax
	popq %rbp
	ret
