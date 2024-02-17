.include "macros.asm"

.globl revealNeighboringCells

revealNeighboringCells:
	save_context 	# Save the data in memory

	move $s1, $a0 	# int row
	move $s2, $a1 	# int column
	move $s6, $a2 	# &board

	sub $t0, $s1, 1
	move $s3, $t0 	# i = row - 1

	# Loop over rows
	begin_for_i:
		addi $t0, $s1, 1 	# row + 1 
		bgt $s3, $t0, end_for_i # if(i > row + 1) end_for_i
	
		sub $t0, $s2, 1
		move $s4, $t0 	# j = column - 1
	
		# Loop over columns
		begin_for_j:
			addi $t0, $s2, 1 	# column + 1
			bgt $s4, $t0, end_for_j # if(j > column + 1) end_for_i
	
			# Check boundary conditions
			blt $s3, $zero, fault_condition
			bge $s3, SIZE, fault_condition
			blt $s4, $zero, fault_condition
			bge $s4, SIZE, fault_condition
	
			# Calculate the index in the board array
			li $t0, SIZE
			mul $t0, $t0, $s3
			add $t0, $t0, $s4
			li $t1, 4
			mul $t0, $t0, $t1
			add $s5, $t0, $s6
	
			# Load the value of the cell
			lw $s7, 0($s5) # board[i][j]
			li $t1, -2
			bne $s7, $t1, fault_condition 	# if(board[i][j] != -2) fault_condition
	
			# Check for bombs in adjacent cells
			move $a0, $s3  	# int row
			move $a1, $s4 	# int column
			move $a2, $s6  	# &board
	
			jal countAdjacentBombs
			move $t1, $v0 	# return of bombs
			sw $t1, 0($s5) 	# board[i][j] = x
		
			# Check if the cell is blank for further recursion
			li $t1, 0
			beq $s7, $t1, recursion
									
			addi $s4, $s4, 1
			j begin_for_j
            
			end_for_j:
			addi $s3, $s3, 1
			j begin_for_i

    	end_for_i:
				restore_context
				jr $ra

	# If a boundary condition is violated, move to the next column
	fault_condition:
		addi $s4, $s4, 1
		j begin_for_j

	# Recursive function to reveal neighboring cells if they are blank
	recursion:
		move $a0, $s3   
		j revealNeighboringCells 
				