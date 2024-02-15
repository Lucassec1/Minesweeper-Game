.include "macros.asm"

.globl checkVictory

checkVictory:
  save_context
  
  move $s3, $a2            # Pointer to array (board)
  
  # Carregar o valor de SIZE em um registrador
  li $t6, SIZE

  # Calcular SIZE * SIZE
  mul $t7, $t6, $t6

  # Carregar o valor de BOMB_COUNT em um registrador
  li $t8, BOMB_COUNT

  # Subtrair BOMB_COUNT de SIZE * SIZE
  sub $t5, $t7, $t8
  
  li $t0, 0                # count = 0
  li $t1, 0                # i = 0
  
loop_i:
  bge $t1, $t6, check_count    # if i >= SIZE, jump to check_count
  li $t2, 0                # j = 0
  
loop_j:
  bge $t2, $t6, inc_i          # if j >= SIZE, jump to inc_i
  mul $t3, $t1, $t6            # index = i * SIZE
  add $t3, $t3, $t2            # index += j
  mul $t3, $t3, 4              # index *= 4 (assuming 4 bytes per int)
  add $t3, $s3, $t3            # pointer = board + index
  lw $t4, 0($t3)               # load value from board[index] into $t4
  bge $t4, $0, inc_count       # if value >= 0, jump to inc_count
  j inc_j                       # jump to inc_j
  
inc_count:
  addi $t0, $t0, 1             # count++
  
inc_j:
  addi $t2, $t2, 1             # j++
  j loop_j
  
inc_i:
  addi $t1, $t1, 1             # i++
  j loop_i
  
check_count:
  ble $t0, $t5, not_victory    # if count <= SIZE*SIZE - BOMB_COUNT, jump to not_victory
  li $v0, 1                    # set return value to 1
  j done                        # jump to done

not_victory:
  li $v0, 0                    # set return value to 0

done:
  restore_context
  jr $ra                        # return
