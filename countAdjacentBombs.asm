.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context

	move $s1, $a0       # int row
	move $s2, $a1       # int column
	move $s6, $a2       # &board
    
	sub $t0, $s1, 1
	move $s3, $t0       # i = row - 1
    
	li $s5, 0           # Initialize count of adjacent bombs to 0
    
	# Loop over rows
	begin_for_i:
		addi $t0, $s1, 1    # row + 1 
		bgt $s3, $t0, end_for_i  # if(i > row + 1) end_for_i
			
		sub $t0, $s2, 1
		move $s4, $t0       # j = column - 1
			
		# Loop over columns
		begin_for_j:
			addi $t0, $s2, 1    # column + 1
			bgt $s4, $t0, end_for_j  # if(j > column + 1) end_for_i
	
			blt $s3, $zero, fault_condition
			bge $s3, SIZE, fault_condition
			blt $s4, $zero, fault_condition
			bge $s4, SIZE, fault_condition
	
			li $t2, SIZE
			mul $t0, $t2, $s3
			add $t0, $t0, $s4
	
			li $t2, 4
			mul $t0, $t2, $t0
			add $t0, $t0, $s6
	
			lw $s7, 0($t0)     # board[i][j]
			li $t1, -1
			bne $s7, $t1, fault_condition	# if(board[i][j] != -1) falha_condicao
	
			addi $s5, $s5, 1   # Increment count of adjacent bombs
					
			addi $s4, $s4, 1
			j begin_for_j
	
		end_for_j: 
			addi $s3, $s3, 1
			j begin_for_i
	
	end_for_i: 
		move $v0, $s5	# Return the count of adjacent bombs in $v0
		restore_context    
		jr $ra        

	fault_condition: 
		addi $s4, $s4, 1
		j begin_for_j
				