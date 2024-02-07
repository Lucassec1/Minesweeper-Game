.include "macros.asm"

.globl play

play:
	save_context
	
	move $s3, $a2 # Pointer to array (board)
	move $s1, $a0 # Row
	move $s2, $a1 # Column
	
	# Calculates cell address in array
	li $t0, SIZE
	mul $t0, $t0, $s1
	add $t0, $t0, $s2
	li $t1, 4
	mul $t0, $t0, $t1
	add $t0, $t0, $s3
			
	lw $t0, 0($t0) # Load the value in cell (board[i][j])
			
	li $t1, -1
	
	# Verify if the cell contain a bomb
	beq $t0, $t1, falha_condicao
	
	# If the cell does not contain a bomb, call revealAdjacentCells
	move $a0, $s1 # Pass the row as argument
	move $a1, $s2 # Pass the column as argument
	move $a2, $s3 # Pass the pointer to the array as argument
	jal revealNeighboringCells
	
	# Restore the context and returns 1 (game continue)
	li $v0, 1
	restore_context
	jr $ra 
	
falha_condicao:
	# If the call contain a bomb, return 0 (end game)
	li $v0, 0
	restore_context
	jr $ra 