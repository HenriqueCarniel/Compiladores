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
# ----------------------------------------	OP_LOADI:	loadI 1 => r0 
	movl $1, _temp_r_0(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r0 => rfp, 0 
	movl _temp_r_0(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_LOADI:	loadI 2 => r1 
	movl $2, _temp_r_1(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r1 => rfp, 4 
	movl _temp_r_1(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r2 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_2(%rip)
# ----------------------------------------	OP_LOADI:	loadI 0 => r3 
	movl $0, _temp_r_3(%rip)
# ----------------------------------------	OP_CMP_GT:	cmp_GT r2, r3 -> r4 
    movl    _temp_r_2(%rip), %eax 
    movl    _temp_r_3(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setg    %al
    movl    %eax, _temp_r_4(%rip)
# ----------------------------------------	OP_CBR:	cbr r4 -> l1, l2 
    movl    _temp_r_4(%rip), %eax 
    test    %eax, %eax
    jnz  l1
    jz  l2
l1:
# ----------------------------------------	OP_LOADI:	loadI 1 => r5 
	movl $1, _temp_r_5(%rip)
# ----------------------------------------	OP_JUMPI:	jumpI -> l3 
	jmp l3
l2:
# ----------------------------------------	OP_LOADI:	loadI 0 => r5 
	movl $0, _temp_r_5(%rip)
l3:
# nop 
	nop
# ----------------------------------------	OP_LOADI:	loadI 0 => r8 
	movl $0, _temp_r_8(%rip)
# ----------------------------------------	OP_CMP_NE:	cmp_NE r5, r8 -> r9 
    movl    _temp_r_5(%rip), %eax 
    movl    _temp_r_8(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_9(%rip)
# ----------------------------------------	OP_CBR:	cbr r9 -> l4, l5 
    movl    _temp_r_9(%rip), %eax 
    test    %eax, %eax
    jnz  l4
    jz  l5
l4:
# nop 
	nop
# ----------------------------------------	OP_LOADI:	loadI 3 => r6 
	movl $3, _temp_r_6(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r6 => rfp, 4 
	movl _temp_r_6(%rip), %edx
	movl %edx, -4(%rbp)
# ----------------------------------------	OP_JUMPI:	jumpI -> l6 
	jmp l6
l5:
# nop 
	nop
# ----------------------------------------	OP_LOADI:	loadI 4 => r7 
	movl $4, _temp_r_7(%rip)
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r7 => rfp, 4 
	movl _temp_r_7(%rip), %edx
	movl %edx, -4(%rbp)
l6:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 4 => r10 
	movl -4(%rbp), %edx
	movl %edx, _temp_r_10(%rip)
# ----------------------------------------	RETURN:	return r10
	movl _temp_r_10(%rip), %eax
	popq %rbp
	ret
