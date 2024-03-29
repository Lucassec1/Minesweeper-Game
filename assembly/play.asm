.include "macros.asm"

.globl play

play:
	save_context
	
	move $s1, $a0	# Row
	move $s2, $a1 	# Column
	move $s3, $a2 	# Pointer to array (board)
	
	# Calculates cell address in array
	li $t0, SIZE
	mul $t0, $t0, $s1
	add $t0, $t0, $s2
	
	li $t1, 4
	mul $t0, $t0, $t1
	add $s4, $t0, $s3
		
	lw $s5, 0($s4)	# Load the value in cell (board[i][j])
			
	li $t1, -1
	# Verify if the cell contain a bomb
	beq $s5, $t1, falha_condicao
	
	li $t1, -2
	bne $s5, $t1, return_one

	# If the cell does not contain a bomb, call revealAdjacentCells
	move $a0, $s1
	move $a1, $s2 	
	move $a2, $s3 	
	jal countAdjacentBombs
	
	move $t1, $v0 	# retorno de bombas

	sw $t1, 0($s4)	# board[i][j] = x
	
	li $t3, 0
	bne $t1, $t3, return_one
	
	move $a0, $s1
	move $a1, $s2 
	move $a2, $s3 
	jal revealNeighboringCells
	
	j return_one
	
	falha_condicao:
		# If the call contain a bomb, return 0 (end game)
		restore_context
		li $v0, 0
		jr $ra
	
	return_one:
		restore_context
		li $v0, 1
		jr $ra