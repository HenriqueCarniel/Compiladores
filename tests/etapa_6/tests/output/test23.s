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
# -------------------------
#  SEGMENTO DE CÓDIGO
# -------------------------
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq %rsp, %rbp
# ----------------------------------------	OP_LOADI:	loadI 0 => r7 
	movl $0, _temp_r_7(%rip)
l4:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r0 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_0(%rip)
# ----------------------------------------	OP_LOADI:	loadI 34 => r1 
	movl $34, _temp_r_1(%rip)
# ----------------------------------------	OP_CMT_LT:	cmp_LT r0, r1 -> r2 
    movl    _temp_r_0(%rip), %eax 
    movl    _temp_r_1(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setl    %al
    movl    %eax, _temp_r_2(%rip)
# ----------------------------------------	OP_CBR:	cbr r2 -> l1, l2 
    movl    _temp_r_2(%rip), %eax 
    test    %eax, %eax
    jnz  l1
    jz  l2
l1:
# ----------------------------------------	OP_LOADI:	loadI 1 => r3 
	movl $1, _temp_r_3(%rip)
# ----------------------------------------	OP_JUMPI:	jumpI -> l3 
	jmp l3
l2:
# ----------------------------------------	OP_LOADI:	loadI 0 => r3 
	movl $0, _temp_r_3(%rip)
l3:
# nop 
	nop
# ----------------------------------------	OP_CMP_NE:	cmp_NE r3, r7 -> r8 
    movl    _temp_r_3(%rip), %eax 
    movl    _temp_r_7(%rip), %edx 
    cmp      %edx, %eax
    movl    $0, %eax
    setne    %al
    movl    %eax, _temp_r_8(%rip)
# ----------------------------------------	OP_CBR:	cbr r8 -> l5, l6 
    movl    _temp_r_8(%rip), %eax 
    test    %eax, %eax
    jnz  l5
    jz  l6
l5:
# nop 
	nop
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
# ----------------------------------------	OP_STOREAI_LOCAL:	storeAI r6 => rfp, 0 
	movl _temp_r_6(%rip), %edx
	movl %edx, -0(%rbp)
# ----------------------------------------	OP_JUMPI:	jumpI -> l4 
	jmp l4
l6:
# nop 
	nop
# ----------------------------------------	OP_LOADAI_LOCAL:	loadAI rfp, 0 => r9 
	movl -0(%rbp), %edx
	movl %edx, _temp_r_9(%rip)
# ----------------------------------------	RETURN:	return r9
	movl _temp_r_9(%rip), %eax
	popq %rbp
	ret
