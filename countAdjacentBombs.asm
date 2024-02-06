.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context # salva os dados na memória
	
	move $s6, $a2 # &board
	
	move $s1, $a0 # int row
	move $s2, $a1 # int coluna
	
	sub $t0, $s1, 1
	move $s3, $t0 # i = row - 1
	sub $t0, $s2, 1
	move $s4, $t0 # j = column - 1
	
	li $s5, 0 # count = 0
	
	begin_for_i:
		addi $t0, $s1, 1 # row + 1 
		bgt $s3, $t0, end_for_i # if(i > row + 1) end_for_i
		
		begin_for_j:
			addi $t0, $s2, 1 # column + 1
			bgt $s4, $t0, end_for_j # if(j > column + 1) end_for_i
			
			blt $s3, $zero, falha_condicao
			bge $s3, SIZE, falha_condicao
			blt $s4, $zero, falha_condicao
			bge $s4, SIZE, falha_condicao
			
			li $t1, -1
			
			li $t2, SIZE
			mul $t0, $t2, $s3
			add $t0, $t0, $s4
			li $t2, 4
			mul $t0, $t2, $t0
			add $t0, $t0, $s6
			
			lw $t0, 0($t0) # board[i][j]
			bne $t0, $t1, falha_condicao # if(board[i][j] != -1) falha_condicao
			
			addi $s5, $s5, 1 #count++
					
			addi $s4, $s4, 1
			j begin_for_j
		end_for_j: 
		
		addi $s3, $s3, 1
		j begin_for_i
	end_for_i: 
	move $v0, $s5
	restore_context
	
	# retornar o count ($s5)
	jr $ra 

falha_condicao: 
	addi $s4, $s4, 1
	j begin_for_j