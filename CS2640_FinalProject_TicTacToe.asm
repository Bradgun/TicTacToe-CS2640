# Bradley Gunawan, Elsa Zheng, Joe Jhenson Ramos, Kenneth Wang, Manuel Abanto
#Group 4
# CS 2640.02 with Professor Cariaga
# Final Project: Tic Tac Toe
#Goal/Objective: Create a functional and good looking Tic Tac Toe game
#Requirements: Good UI, update board with each move, winning/ending condition (3 in a row or draw),
# For board, label each tile with numbers 1-9, and replace with X/O depending on user input
# Alternating loop for player turns, check for correct input
# For board, implement with a 1d array with 9 * 4 byte representing a 3x3 board

# void printStr(.asciiz str)
# Designed for printing string from data section
.macro printStr %str
        li $v0, 4
       	la $a0, %str
       	syscall
.end_macro
    
.macro printInt %int
        li $v0, 1
       	move $a0, %int
       	syscall
.end_macro

# Prints the current state of the Tic-Tac-Toe board in terms of X and O in a 3 x 3 grid. 
# Iterates through the `board` array and prints the corresponding symbol for each element:
# - Empty cell -> a placeholder (" ")
# - Player X -> "X"
# - Player O -> "O"
.macro printBoard
    	la $t0, board                       # Load the base address of the board into $t0
    	li $t1, 0                           # Initialize counter in $t1
   	loop:
    		lw $t2, 0($t0)                  # Load the value of the current element into $t2
   		beq $t2, 0, printEmpty          # If the value is 0, print " "
    		beq $t2, 1, printX              # If the value is 1, print "X"
    		beq $t2, 2, printO              # If the value is 2, print "O"
    		cont:
    			addi $t0, $t0, 4            # Move to the next element (increment address by 4 bytes)
    			addi $t1, $t1, 1            # Increment the counter
    			beq $t1, 3, printNewline
    			beq $t1, 6, printNewline   
    			blt $t1, 9, loop            # If there are more elements, repeat the loop
    		printStr board_splitor
    		b end                           # Exit after processing all cells
    			
    	printEmpty:
    		printStr board_splitor
    		printStr empty
    		b cont
    	printX:
    		printStr board_splitor
    		printStr Xmark
    		b cont
    	printO:
    		printStr board_splitor
    		printStr Omark
    		b cont
    	printNewline:
    		printStr board_splitor
    		printStr board_newline
    		b loop
    	end:
    	printStr newline
.end_macro

# Checks the Tic-Tac-Toe board from a winning combination.
# It iterates over three elements in the predefined winning index combinations (`winning`) and compares the board values.
# If all three board values in a combination match (and are non-zero), the macro identifies the winner:
# - `1` for Player 1 (X)
# - `2` for Player 2 (O)
# If no winner is found, it exits without printing a winner.

# Registers used:
# $t0 - Base address of the board
# $t2 - Base address of the winning combinations
# $t3 - Counter for iterations (number of combinations checked)
# $t4 - Holds the current index of winning combinations being processed
# $t5 - Board value for the first index in a combination
# $t6 - Board value for the second index in a combination
# $t7 - Board value for the third index in a combination
# $t8 - Temporary register for effective address calculation
.macro check_win
	la $t0, board                     # Load address of the board
    	la $t2, winning			      # Load address of winning combinations
    	li $t3, 0
	
	check_loop:
		
		lw $t4, 0($t2)               # Load first index
		mul $t8, $t4, 4              # Multiply index by 4 to get byte offset
		add $t8, $t8, $t0            # Effective address: board + offset
		lw $t5, 0($t8)               # Load board[first index]

		lw $t4, 4($t2)               # Load second index
		mul $t8, $t4, 4             
		add $t8, $t8, $t0            
		lw $t6, 0($t8)               # Load board[second index]

		lw $t4, 8($t2)               # Load third index
		mul $t8, $t4, 4              
		add $t8, $t8, $t0            
		lw $t7, 0($t8)               # Load board[third index]

		
		beqz $t5, no_match                # Skip if first is 0
    		bne $t5, $t6, no_match            # Skip if not all equal
    		bne $t6, $t7, no_match            # Skip if not all equal
		b win
		
		no_match:
			addi $t2, $t2, 12           # Move to the next three combination
			addi $t3, $t3, 1            # Increment combination counter
			blt $t3, 8, check_loop      # Continue to loop if not finished
			b check_break               # If all 8 combinations checked, exit the macro
	win:
		beq $t5, 1, p1win               # If the winning value is 1, Player 1 wins
    		beq $t5, 2, p2win           # If the winning value is 2, Player 2 wins
    	p1win:
    		printStr player1Win
    		printStr playAgain          # Prompt to play again
    		b exitMenu
    	p2win:
    		printStr player2Win
    		printStr playAgain          # Prompt to play again
    		b exitMenu
	
	check_break:
.end_macro
	
# Prints out a 3 x 3 grid filled in with 1 through 9 for instruction.    
.macro printGrid
	li $t0, 1                     	 	# Start with 1 (first number)
	li $t1, 1                      		# Counter for position in grid

	print_loop:
		printStr board_splitor
		printStr space
   		move $a0, $t0                  # Move the current number to $a0 for printing
    		li $v0, 1                      # Print integer
    		syscall
    		printStr space
    		beq $t1, 3, print_end_row
    		beq $t1, 6, print_end_row
    		j continue_loop                

	print_end_row:
    		printStr board_splitor
    		printStr board_newline        
    		j continue_loop                # Continue with the next number

	continue_loop:
    		addi $t0, $t0, 1               # Increment the number to print
    		addi $t1, $t1, 1               # Increment the position counter
    		blt $t0, 10, print_loop        # Continue loop if $t0 < 10
    		printStr board_splitor
		printStr newline
		printStr newline
    	
.end_macro



.data
	board: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 	# Reserve 9 * 4 bytes (1D array for 3x3 board) 0: Empty, 1: X, 2: O
	winning:	.align 2
         		.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 0, 3, 6, 1, 4, 7, 2, 5, 8, 0, 4, 8, 2, 4, 6
	num_combinations:   .word 8
    	Xmark: .asciiz " X "
    	Omark: .asciiz " O "
    	empty: .asciiz "   "
    	space: .asciiz " "

    	player1Win: .asciiz "\nPlayer 1 Wins!"
    	player2Win: .asciiz "\nPlayer 2 Wins!"
    	instructions: .asciiz "Player 1 is X and Player 2 is O. X (Player 1) goes first. \nPlayers take turn placing X's and O's until they reach three in a row (horizontally, vertically, or diagonally) to win or fill all the spaced to draw. \nEnter a number 1-9 that corresponds to the position you wish to put your piece in. \n"
    	prompt1: .asciiz "\nPlayer 1's move: " #tell player 1 it's their turn
    	prompt2: .asciiz "\nPlayer 2's move: " #tell player 2 it's their turn
    	playAgain: .asciiz "\nDo you wish to play again? (type 1 for yes, or 2 to exit): "
    	newline: .asciiz "\n"
    	board_newline: .asciiz "\n ---+---+--- \n"
    	board_splitor: .asciiz "|"
    	wrongPosition: .asciiz "\nSpot already taken. Please choose a different spot"
    	drawMsg: .asciiz "\n It's a Draw!"
    	invalidPlayAgain: .asciiz "\nInvalid: Please enter 1 to play again or enter 2 to quit."

.text
main:
	#print instructions to users
	printStr instructions

	printGrid

	# Print board
	printBoard

	#Loop counter	
	li $s0, 0
	
	#To mark the spot for player 1
	li $s1, 1
	 
	#To mark the spot for player 1
	li $s2, 2

        #Jump to label player1 to begin game
        j player1
    
player1:
	#prompt player 1
	li $v0, 4
	la $a0, prompt1
	syscall
	
	#Player 1 input (integer)
	li $v0, 5
	syscall
	move $t0, $v0
	
	#loads base address of array into $s0
	la $s3, board
	
	#calculate offset
	sub $t0, $t0, 1
	mul $t0, $t0, 4
	
	#increase base address to address user is looking for
	add $s3, $s3, $t0
	
	#load position in array
	lw $t1, 0($s3)
	
	#check that piece can be placed there
	#jumps to wrongPostion1 label if position is taken
	beq $t1, 1, wrongPosition1
	beq $t1, 2, wrongPosition1
	
	#Update the board and check for winning condition if it passes the check
    	sw $s1, 0($s3)
    	printBoard
    
    	check_win()
    
	#Increment loop counter
	add $s0, $s0, 1

	### --- Draw condition will be implemented here --- ###
	#total possible moves to be done
	li $t0, 9
	
	#when total possible moves have been done and nobody wins, branch to drawCondition
	#and end the game			
	beq $s0, $t0, drawCondition
	
	#Player 2's turn
	j player2

player2:
	#prompt player 2
	li $v0, 4
	la $a0, prompt2
	syscall
	
	#Player 2 input (integer)
	li $v0, 5
	syscall
	move $t0, $v0
	
	#loads base address of array into $s0
	la $s3, board
	
	#calculate offset
	sub $t0, $t0, 1
	mul $t0, $t0, 4
	
	#increase base address to address user is looking for
	add $s3, $s3, $t0
	
	#load position in array
	lw $t1, 0($s3)
	
	#check that piece can be placed there
	#jumps to wrongPosition2 label if position is taken
	beq $t1, 1, wrongPosition2
	beq $t1, 2, wrongPosition2
	
	#Update the board and check for winning condition if it passes the check
    	sw $s2, 0($s3)
    	printBoard
    
    	check_win()
    
	#Increment loop counter
	add $s0, $s0, 1

	#Player 1's turn
	j player1


wrongPosition1:
	#inform user of error
	li $v0, 4
	la $a0, wrongPosition
	syscall
	
	#jump back to player1 label
	j player1
	
wrongPosition2:
	#inform user of error
	li $v0, 4
	la $a0, wrongPosition
	syscall
	
	#jump back to player2 label
	j player2
	
drawCondition:
	#output the message for the draw
	printStr drawMsg
	
	#output the message to ask user if they want to play again or to exit
	printStr playAgain
	b exitMenu
	
exitMenu:
	#get user input
	li $v0, 5
	syscall
	move $t1, $v0
	
	#1 = yes, 2 = exit
	li $t2, 1
	beq $t1, $t2, resetGame
	
	li $t2, 2
	beq $t1, $t2, exit
	
	#if input is invalid
	printStr invalidPlayAgain
	j exitMenu

resetGame:
	# reset the board all to 0's
	la $t0, board	# load the base adress of the board
	li $t1, 0	# value to reset (0 represents empthy)
	li $t2, 9	# the number of positions to reset

resetLoop:
	sw $t1, 0($t0)		# store 0 in the current position
	addi $t0, $t0, 4	# move to the next position
	subi $t2, $t2, 1	# decrement counter
	bnez $t2, resetLoop	# continue doing this until all positions (aka 1-9) are reset

	li $s0, 0	# reset the move counter (aka number of moves made) to 0

	j player1	#resets the game, starts at the turn of player 1
	

#Exit Program
exit:
	li $v0, 10
	syscall
	
# 1 2 3
# 4 5 6
# 7 8 9
