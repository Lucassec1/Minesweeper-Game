.include "macros.asm"

.globl countAdjacentBombs

countAdjacentBombs:
	save_context # salva os dados na memória
	
	move $s1, $a0 # int row
	move $s2, $a1 # int coluna
	
	sub $t0, $s1, 1
	move $s3, $t0 # i = row - 1
	sub $t0, $s2, 1
	move $s4, $t0 # j = column - 1
	
	li $s5, 0 # count = 0
	
	begin_for_i:
		addi $t0, $s1, 1 # row + 1 
		bge $s3, $t0, end_for_i
		
		begin_for_j:
			addi $t0, $s2, 1 # column + 1
			bge $s4, $t0, end_for_j
			
			bge $s3, $zero, falha_condicao
			blt $s3, SIZE, falha_condicao
			bge $s4, $zero, falha_condicao
			blt $s4, SIZE, falha_condicao
			
			# falta adicionar com acessar o board[i][j] == -2
			
			addi $s5, $s5, 1 #count++
			
				falha_condicao: 
					addi $s4, $s4, 1
				j begin_for_j
				
			addi $s4, $s4, 1
			j begin_for_j
		end_for_j: 
		
		addi $s3, $s3, 1
		j begin_for_i
	end_for_i: 
	restore_context
jr $ra 
	