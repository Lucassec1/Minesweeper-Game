.include "macros.asm"

.globl play

play:
	save_context # salva os dados da memória
	
	move $s3, $a2 #board
	move $s1, $a0 # row
	move $s2, $a1 # column
	
	li $t0, SIZE
	mul $t0, $t0, $s1
	add $t0, $t0, $s2
	li $t1, 4
	mul $t0, $t0, $t1
	add $t0, $t0, $s3
			
	lw $t0, 0($t0) # board[i][j]
			
	li $t1, -1
	
	beq $t0, $t1, falha_condicao
	
	restore_context
	
falha_condicao:
	li $v0, 0
	restore_context
	
	jr $ra 