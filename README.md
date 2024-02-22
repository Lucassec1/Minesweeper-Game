# Minesweeper Game

Minesweeper é o clássico jogo Campo Minado, criado em Assembly, para a disciplina de CC0020 - Arquitetura de Computadores.

![Arquitetura](https://github.com/Lucassec1/Minesweeper-Game/assets/90703943/92677e76-06c1-418c-86c1-1ce3a95a9042)

## Códigos

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

Função que printa o tabuleiro. Como parâmetro `shoBombs` onde 1 (um) mostrará todas as bombas no tabuleiro.

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

## Estrutura do Repositório

- **main.asm**: Contém a função principal (main) que controla o fluxo do jogo em Assembly MIPS.
- **printboard.asm**: Implementa a função para imprimir o tabuleiro.
- **initializeboard.asm**: Implementa a função para inicializar o tabuleiro.
- **plantbombs.asm**: Implementa a função para posicionar as bombas no tabuleiro.
- **macros.asm**: Contém macros úteis para facilitar o desenvolvimento em MIPS.
- **play.asm**: Implementa a função de jogar, responsável por registrar cada jogada do player no tabuleiro.
- **checkvictory.asm**: Implementa a função que verifica se o jogador venceu ou não.
- **revealcells.asm**: Implementa a função que revela as células quando não possuem bombas adjacentes.
- **Mars.jar**: Executável do Mars MIPS, necessário para rodar os arquivos .asm.

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
