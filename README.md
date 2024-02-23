# Minesweeper Game

Minesweeper é o clássico jogo Campo Minado, criado em Assembly, para a disciplina de CC0020 - Arquitetura de Computadores.

![Arquitetura](https://github.com/Lucassec1/Minesweeper-Game/assets/90703943/92677e76-06c1-418c-86c1-1ce3a95a9042)

## Como jogar:

1. Iniciar o Jogo:
   - Execute o programa Campo Minado Assembly em seu terminal.
   
2. Tabuleiro Inicial:
   - Quando o jogo começar, você verá um tabuleiro oculto representado por células fechadas. Cada célula pode conter uma bomba ou estar vazia.
     
3. Fazer uma Jogada:
   - O terminal solicitará que você insira a linha para a movimentação.
   - Em seguida, o terminal solicitará que você insira a coluna para a movimentação.
     
4. Revelar Célula:
   - O programa revelará a célula correspondente à sua jogada.
   - Se a célula revelada contiver uma bomba, o jogo terminará imediatamente, e você perderá.
   - Se a célula revelada estiver vazia, o programa mostrará o número de bombas adjacentes a essa célula, ou a célula permanecerá vazia se não houver bombas adjacentes.
     
5. Continuar Jogando:
   - Você pode continuar fazendo jogadas seguindo os passos 3 e 4 até revelar todas as células seguras do tabuleiro ou até acertar uma bomba.
     
6. Concluir o Jogo:
   - Se você revelar todas as células seguras sem acertar uma bomba, o programa exibirá uma mensagem de vitória e encerrará o jogo.
   - Se você acertar uma bomba, o programa exibirá uma mensagem de derrota e encerrará o jogo.

## Códigos em C

Para criação do projeto em Assembly foram utilizados funções em código C, facilitando o desenvolvimento e criação do Jogo.

### Main

A função principal (Main) é ponto inicial para crição do nosso jogo. Nela é onde criamos o nosso board de tamanho SIZE (oito) e chamamos a outras funções que axulia no desenvolvimento do jogo. E outro ponto essencial, é as váriaveis definidas como `globais`, SIZE - tamanho do board -, e BOMB_COUNT - quantidade de bombas no board -, que utilizamos no decorrer do projeto.
Na Main temos uma váriavel do tipo int que indica o estado atual do jogo, a `gameActive` é fundamental para o loop do jogo, que só termina quando for 0 (zero).

```C
#define SIZE 8
#define BOMB_COUNT 10

int main() {
   int board[SIZE][SIZE];
   int gameActive = 1;
   int row, column;

   initializeBoard(board);
   placeBombs(board);

   while (gameActive) {
      printBoard(board,1); // Shows the board without bombs

      // Asks the player to enter the move
      printf("Enter the row for the move: ");
      scanf("%d", &row);
      printf("Enter the column for the move: ");
      scanf("%d", &column);

      // Checks the move
      if (row >= 0 && row < SIZE && column >= 0 && column < SIZE) {
            if (!play(board, row, column)) {
               gameActive = 0;
               printf("Oh no! You hit a bomb! Game over.\n");
            } else if (checkVictory(board)) {
               printf("Congratulations! You won!\n");
               gameActive = 0; // Game ends
            }
      } else {
            printf("Invalid move. Please try again.\n");
      }
   }

   // Shows the final board with bombs
   printBoard(board,1);

   return 0;
}
```

### Inicializador do tabuleiro

Função que atribui em todo tabuleiro o valor -2 para iniciar, que significa sem bomba.

```C
void initializeBoard(int board[][SIZE]) {
   // Initializes the board with zeros
   for (int i = 0; i < SIZE; ++i) {
      for (int j = 0; j < SIZE; ++j) {
            board[i][j] = -2; // -2 means no bomb
      }
   }
}
```

### Adicionar bombas

Função para adicionar bombas aleatoriamente no tabuleiro do jogo.

```C
void placeBombs(int board[][SIZE]) {
   srand(time(NULL));
   // Places bombs randomly on the board
   for (int i = 0; i < BOMB_COUNT; ++i) {
      int row, column;
      do {
            row = rand() % SIZE;
            column = rand() % SIZE;
      } while (board[row][column] == -1);
      board[row][column] = -1; // -1 means bomb present
   }
}
```

### Mostrar tabuleiro

Função que printa o tabuleiro. Como parâmetro `showBombs` onde 1 (um) mostrará todas as bombas no tabuleiro.

```C
void printBoard(int board[][SIZE], int showBombs) {
   // Prints the board
   printf("    ");
   for (int j = 0; j < SIZE; ++j)
      printf(" %d ", j);
   printf("\n");
   printf("    ");
   for (int j = 0; j < SIZE; ++j)
      printf("___");
   printf("\n");
   for (int i = 0; i < SIZE; ++i) {
      printf("%d | ", i);
      for (int j = 0; j < SIZE; ++j) {
            if (board[i][j] == -1 && showBombs) {
               printf(" * "); // Shows bombs
            } else if (board[i][j] >= 0) {
               printf(" %d ", board[i][j]); // Revealed cell
            } else {
               printf(" # ");
            }
      }
      printf("\n");
   }
}
```

### Inicio do jogo

Na Play é onde a mágica acontece, nela que vai chamar as funções de revelar e contar bombas. Então ela é fundamental para indicar o estado atual do jogo.

```C

   int play(int board[][SIZE], int row, int column) {
        // Performs the move
        if (board[row][column] == -1) {
            return 0; // Player hit a bomb, game over
        }
        if (board[row][column] == -2) {
            int x = countAdjacentBombs(board, row, column); // Marks as revealed
            board[row][column] = x;
            if (!x)
                revealAdjacentCells(board, row, column); // Reveals adjacent cells
        }
        return 1; // Game continues
    }

```

### Contar bombas adjacentes

Na função `countAdjacentBombs` retorna o valor de bombas que está próximo da célula onde usuário chutou. Ela é importante para indicar ao usuário quantas bombas está perto do seu chute.

```C
int countAdjacentBombs(int board[][SIZE], int row, int column) {
   // Counts the number of bombs adjacent to a cell
   int count = 0;
   for (int i = row - 1; i <= row + 1; ++i) {
      for (int j = column - 1; j <= column + 1; ++j) {
            if (i >= 0 && i < SIZE && j >= 0 && j < SIZE && board[i][j] == -1) {
               count++;
            }
      }
   }
   return count;
}
```

### Revelar células adjacentes

Essa função ajudará ao jogador revelando células ao redor do seu chute caso não tenha nenhuma bomba perto. Caso contrário não irá revelar nenhuma bomba.

```C
void revealAdjacentCells(int board[][SIZE], int row, int column) {
   // Reveals the adjacent cells of an empty cell
   for (int i = row - 1; i <= row + 1; ++i) {
      for (int j = column - 1; j <= column + 1; ++j) {
            if (i >= 0 && i < SIZE && j >= 0 && j < SIZE && board[i][j] == -2) {
               int x = countAdjacentBombs(board, i, j); // Marks as revealed
               board[i][j] = x;
               if (!x)
                  revealAdjacentCells(board, i, j); // Continues the revelation recursively
            }
      }
   }
}
```

### Checar vitória

E por fim, a função que vai verificar se usuário ganhou, se caso ele descobriu todo tabuleiro menos as bombas - então não clicou em nenhuma bomba - irá vencer, finalizando o jogo.

```C
int checkVictory(int board[][SIZE]) {
   int count = 0;
   // Checks if the player has won
   for (int i = 0; i < SIZE; ++i) {
      for (int j = 0; j < SIZE; ++j) {
            if (board[i][j] >= 0) {
               count++;
            }
      }
   }
   if (count < SIZE * SIZE - BOMB_COUNT)
      return 0;
   return 1; // All valid cells have been revealed
}
```

## Códigos em Assembly

Nessa seção conterá os códigos criados em Assembly para executar as mesmas funcionalidades do C, em cada seção vou resumir o que cada código executa ao longo do programa.

### Main

1. Inicialização do jogo, incluindo a alocação de espaço para o tabuleiro e a definição de variáveis de controle.
2. Chama as funções para inicializar o tabuleiro e posicionar as bombas.
3. Entra em um loop principal que continua enquanto o jogo estiver ativo.
4. Dentro do loop:
   - Exibe o tabuleiro sem revelar as bombas.
   - Solicita ao usuário que insira uma linha e uma coluna para fazer uma jogada.
   - Verifica se a jogada é válida.
   - Chama a função para realizar a jogada.
   - Verifica se a jogada termina o jogo (vitória ou derrota).
   - Se o jogo acabar, exibe a mensagem correspondente e encerra o jogo.
5. Retorna 0 ao sistema operacional indicando que o programa foi executado com sucesso.

```Assembly
.include "macros.asm"

.data
	msg_row:  			.asciiz "Insira a linha para a movimentação: "
 	msg_column:  		.asciiz "Insira a coluna para a movimentação: "
 	msg_win:  			.asciiz "Parabéns! Você ganhou!\n"
 	msg_lose:  			.asciiz "Oh não! Você acertou uma bomba! Game Over.\n"
	msg_invalid:  		.asciiz "Movimento inválido. Por favor, tente novamente.\n"

.globl main 	 	
.text

main:
	addi $sp, $sp, -256 	# store space for the board (8 x 8) with a quantity of 4 integer bits;
	li $s1, 1		# int gameActive = 1;
	move $s0, $sp
	move $a0, $s0 

	jal inicialializeBoard	# initializeBoard(board);
	move $a0, $s0 				
	jal plantBombs	# placeBombs(board);

	begin_while:	# while (gameActive) {
		beqz $s1, end_while
		move $a0, $s0 
		li $a1, 0
		jal printBoard	# printBoard(board,0); 

		la $a0, msg_row		
		li $v0, 4	# printf_string
		syscall

		li $v0, 5	# scanf("%d", &row);
		syscall
		move $s2, $v0

		la $a0, msg_column
		li $v0, 4	# printf_string
		syscall

		li $v0, 5	# scanf("%d", &column);
		syscall
		move $s3, $v0 

		li $t0, SIZE
		blt $s2, $zero, else_invalid	#if (row >= 0 && row < SIZE && column >= 0 && column < SIZE) {
		bge $s2, $t0, else_invalid		
		blt $s3, $zero, else_invalid
		bge $s3, $t0, else_invalid

		move $a2, $s0
		move $a0, $s2
		move $a1, $s3
		jal play

		bne $v0, $zero, else_if_main 	# if (!play(board, row, column)) {
		li $s1, 0	# gameActive = 0;
		la $a0, msg_lose	# printf("Oh no! You hit a bomb! Game over.\n");
		li $v0, 4
		
		syscall
		j end_if_main

	else_if_main:
		move $a0, $s0
		jal checkVictory	# else if (checkVictory(board)) {
		beq $v0, $zero, end_if_main
		la $a0, msg_win	# printf("Congratulations! You won!\n");
		li $v0, 4
		syscall

		li $s1, 0	# gameActive = 0; // Game ends
		j end_if_main 
		
	else_invalid:		
		la $a0, msg_invalid	# printf("Invalid move. Please try again.\n");
		li $v0, 4
		syscall
		
	end_if_main:
		j begin_while
		
	end_while:
		move $a0, $s0 
		li $a1, 1
		jal printBoard	# printBoard(board,1);
		li $v0, 10
		syscall
```

### Inicializador do tabuleiro

1. Inicializa o tabuleiro do jogo, preenchendo-o com valores padrão.
2.  A função utiliza dois loops aninhados para iterar sobre as linhas e colunas do tabuleiro.
3. Cada célula do tabuleiro é representada por um inteiro de 32 bits.
4. O valor padrão -2 é usado para indicar que não há bomba na célula.
5. Os loops percorrem todas as posições do tabuleiro (8x8) e atribuem -2 a cada célula.
6. Retorna ao endereço de retorno.

```Assembly
.include "macros.asm"
.globl inicialializeBoard

inicialializeBoard:
	save_context
	move $s0, $a0 
  
	li $s1,0 # i = 0
	
	begin_for_i_it:	# for (int i = 0; i < SIZE; ++i) {
		li $t0,SIZE
		bge $s1,$t0,end_for_i_it 

		li $s2,0	# j = 0
		
		begin_for_j_it:	# for (int j = 0; j < SIZE; ++j) {
			li $t0,SIZE
			bge $s2,$t0, end_for_j_it
			
			sll $t0, $s1, 5 # i*8
			sll $t1, $s2, 2 # j
			
			add $t0, $t0, $t1
			add $t0, $t0, $s0
			
			li $t1, -2
			sw $t1,0($t0)	# board[i][j] = -2;
			addi $s2,$s2,1
			j begin_for_j_it
			
		end_for_j_it:
			addi $s1, $s1, 1
			j begin_for_i_it
			
	end_for_i_it:
		restore_context
		jr $ra 
```

### Adicionar bombas

1. Planta bombas aleatoriamente no tabuleiro do jogo.
2. Utiliza a função de tempo para inicializar o gerador de números aleatórios.
3. Utiliza um loop para iterar sobre o número desejado de bombas.
4. Dentro do loop:
   - Gera coordenadas aleatórias para linha e coluna.
   - Verifica se a célula já contém uma bomba.
   - Se a célula estiver vazia, atribui uma bomba a ela.
5. Retorna ao endereço de retorno.

```Assembly
.include "macros.asm"
.globl plantBombs

plantBombs:
	save_context
	move $s0, $a0
	
	li $a0, 0	# srand(time(NULL));
	li $a1, 8
	
	li $s1, 0	# i = 0
	
	begin_for_i_pb: # for (int i = 0; i < BOMB_COUNT; ++i) {
		li $t0, BOMB_COUNT
		bge $s1, $t0, end_for_i_pb 
	
		do_cb:											# do {
			li $v0, 42
			syscall 
			
			move $s2, $a0  							# row = rand() % SIZE;
			syscall 
			
			move $s3, $a0  							# column = rand() % SIZE;
			sll $t0, $s2, 5
			sll $t1, $s3, 2
			
			add $t2, $t0, $t1
			add $t0, $t2, $s0
			lw $t1,0 ($t0)
			li $t2, -1
			
			beq $t2, $t1, do_cb # while (board[row][column] == -1);
			sw $t2,0 ($t0)			# board[row][column] = -1; // -1 means bomb present
			addi $s1, $s1, 1  
			  
			j begin_for_i_pb
			
	end_for_i_pb:
		restore_context
		jr $ra
```

### Mostrar tabuleiro

1. Renderiza o tabuleiro do jogo no console.
2. Inicia imprimindo um cabeçalho com números de coluna.
3. Em seguida, imprime linhas horizontais para delimitar as linhas do tabuleiro.
4. Itera sobre as células do tabuleiro e imprime seu conteúdo de acordo com as condições:
   - Se a célula contiver uma bomba (-1), e a flag de mostrar bombas estiver ativada, imprime '*'.
   - Se a célula estiver revelada (>= 0), imprime seu valor.
   - Caso contrário, imprime '#', indicando uma célula não revelada.
5. Após imprimir uma linha completa, move para a próxima linha do tabuleiro.
6. Retorna ao endereço de retorno.

```Assembly
.include "macros.asm"
.globl printBoard

printBoard:
	save_context
	
	move $s0, $a0
	move $s1, $a1
	
	li $v0, 11 
	li $a0, 32	# printf("    ");
	syscall							
	syscall
	syscall
	syscall
  
	li $t0, 0	# j = 0
			
	begin_for_j1_pb:	# for (int j = 0; j < SIZE; ++j)	
		li $t1, SIZE
		bge $t0, $t1, end_for_j1_pb
		li $v0, 11 
		li $a0, 32	#print (' ')
		syscall
		
		li $v0, 1	#print_int
		move $a0, $t0	#print ('j')
		syscall
		
		li $v0, 11	#print_char
		li $a0, 32	#print (' ')
		syscall
		
		addi $t0, $t0, 1	#j++
		j begin_for_j1_pb
		
	end_for_j1_pb:
		li $v0, 11	#print_char
		li $a0, 10	# printf("\n");
		syscall
	
		li $v0, 11	#print_char
		li $a0, 32	# printf("   ");
		syscall
		syscall
		syscall
		syscall
	
		li $t0, 0
  		
  	begin_for_j2_pb:	# for (int j = 0; j < SIZE; ++j)
  		li $t1, SIZE
  		bge $t0, $t1, end_for_j2_pb
  		li $v0, 11
  		li $a0, 95	# printf("___");
  		syscall
  		syscall
  		syscall
  		
  		addi $t0, $t0, 1
  		j begin_for_j2_pb
  		
  	end_for_j2_pb:
  		li $v0, 11
  		li $a0, 10	# printf("\n");
  		syscall
    
  		li $t0, 0
  		
  	begin_for_i_pb:	# for (int i = 0; i < SIZE; ++i) {
  		li $t7, SIZE
  		bge $t0, $t7, end_for_i_pb
  		li $v0, 1
  		move $a0, $t0	# printf(i)
  		syscall
  
  		li $v0, 11
  		li $a0, 32	#printf(" ")
  		syscall
  
  		li $v0, 11
  		li $a0, 124	# printf("|")
  		syscall
  
  		li $v0, 11
  		li $a0, 32	# print(" ")
  		syscall
  	
  		li $t1, 0
  		
  	begin_for_ji_pb:	# for (int j = 0; j < SIZE; ++j) {
  		li $t7, SIZE
  		bge $t1, $t7, end_for_ji_pb
  		li $v0, 11
  		li $a0, 32	# print(" ")
  		syscall
  	
  		sll $t2, $t0, 5
			sll $t3, $t1, 2
		
			add $t4, $t2, $t3
			add $t3, $t4, $s0
			lw  $t4, 0 ($t3)
			li $t7, -1
			bne $t4, $t7, elseif_imt	# if (board[i][j] == -1 && showBombs) {
			beqz $s1, elseif_imt		
		
			li $v0, 11
  		li $a0, 42	# print (*)
  		syscall
  		j print_space
  	
	elseif_imt:
		blt $t4,$zero, else_imt	# else if (board[i][j] >= 0) {
		li $v0, 1
		move $a0, $t4	# printf(" %d ", board[i][j]); // Revealed cell
		syscall		
					
		j print_space  	
		
	else_imt:
		li $v0, 11
		li $a0, 35	# printf(#)
		syscall
  		
	print_space:
		li $v0, 11
		li $a0, 32	# printf(' ')
		syscall

		addi $t1, $t1, 1 
		j begin_for_ji_pb
		
	end_for_ji_pb:
		li $v0, 11
		li $a0, 10	# printf('\n')
		syscall

		addi $t0, $t0, 1 
		j begin_for_i_pb
		
	end_for_i_pb:
		restore_context  
		jr $ra
```

### Macros

.save_context:
1. Macro para salvar o contexto de registradores na pilha.
2. Antes de chamar uma função ou executar uma rotina que possa modificar os registradores,
3. esta macro é usada para salvar os valores dos registradores $s0-$s7 e $ra na pilha.
4. Isso é feito movendo a pilha para baixo e armazenando os valores dos registradores em locais específicos na pilha.

.restore_context:
1. Macro para restaurar o contexto de registradores da pilha.
2. Após a execução de uma função ou rotina que tenha modificado os registradores,
3. esta macro é usada para restaurar os valores dos registradores $s0-$s7 e $ra da pilha.
4. Isso é feito carregando os valores dos registradores de volta de seus locais na pilha e movendo a pilha de volta para cima.

```Assembly
.eqv SIZE 8
.eqv BOMB_COUNT 10

.macro save_context
	addi $sp, $sp, -36
	sw $s0, 0 ($sp)
	sw $s1, 4 ($sp)
	sw $s2, 8 ($sp)
	sw $s3, 12 ($sp)
	sw $s4, 16 ($sp)
	sw $s5, 20 ($sp)
	sw $s6, 24 ($sp)
	sw $s7, 28 ($sp)
  	sw $ra, 32 ($sp)
.end_macro

.macro restore_context
	lw $s0, 0 ($sp)
	lw $s1, 4 ($sp)
	lw $s2, 8 ($sp)
	lw $s3, 12 ($sp)
	lw $s4, 16 ($sp)
	lw $s5, 20 ($sp)
	lw $s6, 24 ($sp)
	lw $s7, 28 ($sp)
  	lw $ra, 32 ($sp)
  	addi $sp, $sp, 36
.end_macro
```

### Inicio do jogo

1. Função responsável por executar uma jogada no jogo.
2. Recebe como entrada a linha e a coluna da jogada, além de um ponteiro para o array que representa o tabuleiro.
3. Calcula o endereço da célula no array com base na linha e coluna fornecidas.
4. Verifica se a célula contém uma bomba. Se contiver, encerra o jogo retornando 0.
5. Caso contrário, se a célula não contiver uma bomba, chama a função para contar bombas adjacentes e revelar células vizinhas.
6. Se a célula não contiver uma bomba e houver bombas adjacentes, atualiza o tabuleiro com o número de bombas adjacentes.
7. Em seguida, se não houver bombas adjacentes, chama a função para revelar células vizinhas.
8. Retorna 1 para indicar que a jogada foi bem-sucedida e o jogo deve continuar.
9. Restaura o contexto de registradores antes de retornar.


```Assembly
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
```

### Contar bombas adjacentes

1. Função responsável por contar o número de bombas adjacentes a uma determinada célula no tabuleiro.
2. Recebe como entrada a linha e a coluna da célula e um ponteiro para o array que representa o tabuleiro.
3. Inicializa um contador de bombas adjacentes.
4. Itera sobre as células vizinhas à célula fornecida.
5. Para cada célula vizinha, verifica se está dentro dos limites do tabuleiro.
6. Se estiver dentro dos limites, verifica se contém uma bomba (-1).
7. Se uma célula vizinha contiver uma bomba, incrementa o contador de bombas adjacentes.
8. Retorna o número de bombas adjacentes encontradas.
9. Restaura o contexto de registradores antes de retornar.

```Assembly
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
```

### Revelar células adjacentes

1. Função responsável por revelar células vizinhas à célula fornecida que não contêm bombas.
2. Recebe como entrada a linha e a coluna da célula e um ponteiro para o array que representa o tabuleiro.
3. Itera sobre as células vizinhas à célula fornecida.
4. Para cada célula vizinha, verifica se está dentro dos limites do tabuleiro.
5. Se estiver dentro dos limites, verifica se contém uma bomba (-2).
6. Se uma célula vizinha não contiver uma bomba, verifica se é uma célula vazia.
7. Se for uma célula vazia, chama a função recursivamente para revelar as células vizinhas.
8. Se a célula não for vazia, atualiza o tabuleiro com o número de bombas adjacentes encontradas.
9. Restaura o contexto de registradores antes de retornar.

```Assembly
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
```

### Checar vitória

1. Função responsável por verificar se o jogador venceu o jogo.
2. Recebe como entrada um ponteiro para o array que representa o tabuleiro.
3. Calcula o tamanho total do tabuleiro (SIZE * SIZE) e subtrai o número de bombas.
4. Itera sobre cada célula do tabuleiro.
5. Para cada célula, verifica se contém uma bomba (-1) ou não.
6. Conta o número de células que não contêm bombas.
7. Se o número de células sem bombas for igual ao tamanho total do tabuleiro menos o número de bombas, o jogador venceu.
8. Retorna 1 se o jogador venceu e 0 caso contrário.
9. Restaura o contexto de registradores antes de retornar.

```Assembly
.include "macros.asm"
.globl checkVictory

checkVictory:
	save_context
  
	move $s3, $a2            # Pointer to array (board)

	li $t6, SIZE

	# Calcular SIZE * SIZE
	mul $t7, $t6, $t6

	li $t8, BOMB_COUNT

	# Subtrair BOMB_COUNT de SIZE * SIZE
	sub $t5, $t7, $t8

	li $t0, 0                # count = 0
	li $t1, 0                # i = 0
  
	begin_for_i:
		bge $t1, $t6, check_count    # if i >= SIZE, jump to check_count
		li $t2, 0                # j = 0

		begin_for_j:
			bge $t2, $t6, end_for_i      # if j >= SIZE, jump to end_for_i
			mul $t3, $t1, $t6            # index = i * SIZE
			add $t3, $t3, $t2            # index += j
			mul $t3, $t3, 4              # index *= 4 (assuming 4 bytes per int)
			add $t3, $s3, $t3            # pointer = board + index
			lw $t4, 0($t3)               # load value from board[index] into $t4
			bge $t4, $0, inc_count       # if value >= 0, jump to inc_count
			j end_for_j                  # jump to end_for_j

			inc_count:
				addi $t0, $t0, 1	# count++
		
			end_for_j:
				addi $t2, $t2, 1	# j++
				j begin_for_j
		
		end_for_i:
			addi $t1, $t1, 1	# i++
			j begin_for_i
  
	check_count:
		blt $t0, $t5, not_victory    # if count < SIZE*SIZE - BOMB_COUNT, jump to not_victory
		li $v0, 1                    # set return value to 1
		j done                       # jump to done

	not_victory:
		li $v0, 0                    # set return value to 0

	done:
		restore_context
		jr $ra

```

## Estrutura do Repositório

- **main.asm**: Contém a função principal (main) que controla o fluxo do jogo em Assembly MIPS.
- **printBoard.asm**: Implementa a função para imprimir o tabuleiro.
- **initializeBoard.asm**: Implementa a função para inicializar o tabuleiro.
- **plantBombs.asm**: Implementa a função para posicionar as bombas no tabuleiro.
- **macros.asm**: Contém macros úteis para facilitar o desenvolvimento em MIPS.
- **play.asm**: Implementa a função de jogar, responsável por registrar cada jogada do player no tabuleiro.
- **checkVictory.asm**: Implementa a função que verifica se o jogador venceu ou não.
- **revealCells.asm**: Implementa a função que revela as células quando não possuem bombas adjacentes.

- **minesweeper.c**: Contém a implementação em C do jogo Minesweeper. Este arquivo serve como referência para a lógica do jogo e pode ser utilizado para comparação com as implementações em Assembly MIPS.

## Instruções de Execução

### Requisitos

O arquivo executável Mars.jar está incluído neste repositório.

### Execução do Código em C

1. Abra o terminal na pasta do repositório.
2. Compile o código C usando um compilador padrão C, como o GCC, com o seguinte comando:

   ```bash
   gcc minesweeper.c -o minesweeper
   ```
3. Execute o executável gerado:

   ```bash
   ./minesweeper
   ```
4. Siga as instruções no console para jogar o Minesweeper em C.

### Execução dos Arquivos em Assembly MIPS

1. Abra o terminal na pasta do repositório.
2. Execute o Mars MIPS digitando o seguinte comando:

   ```bash
   java -jar Mars.jar
   ```
   
3. No Mars MIPS, abra cada arquivo .asm individualmente e monte/executa o código. 
4. A saída do jogo será exibida na console do Mars MIPS.
