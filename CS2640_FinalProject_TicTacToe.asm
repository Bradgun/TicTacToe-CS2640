# Bradley Gunawan, Elsa Zheng, Joe Jhenson Ramos, Kenneth Wang, Manuel Abanto
# Group 4
# CS 2640.02 with Professor Cariaga
# Final Project: Tic Tac Toe
# Goal/Objective: Create a functional and good looking Tic Tac Toe game
# Requirements: Good UI, update board with each move, winning/ending condition (3 in a row or draw),
# For board, label each tile with numbers 1-9, and replace with X/O depending on user input
# Alternating loop for player turns, check for correct input

# For board, implement with a 1d array with 9 * 4 byte representing a 3x3 board

.data
	    board: .word 0, 0, 1, 0, 1, 0, 1, 0, 0 	# Reserve 9 * 4 bytes (1D array for 3x3 board) 0: Empty, 1: X, 2: O
    	# board: .space 36           # Too messy, need init at beginning for main
    	Xmark: .asciiz " X "
    	Omark: .asciiz " O "
    	empty: .asciiz "   "

    	player1Win: .asciiz "Player 1 Wins!"
    	player2Win: .asciiz "Player 2 Wins!"
    	instructions: .asciiz "Player 1 is X and Player 2 is O. X (Player 1) goes first. Players take turn placing X's and O's until they reach three in a row (horizontally, vertically, or diagonally) to win or fill all the spaced to draw."
    	prompt1: .asciiz "Player 1's move" #tell player 1 it's their turn
    	prompt2: .asciiz "Player 2's move" #tell player 2 it's their turn
    	playAgain: .asciiz "Do you wish to play again?"
    	newline: .asciiz "\n"

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

    	.macro printBoard
    		la $t0, board
    		li $t1, 0
    		loop:
    			lw $t2, 0($t0)
    			beq $t2, 0, printEmpty
    			beq $t2, 1, printX
    			beq $t2, 2, printO
    			cont:
    				addi $t0, $t0, 4
    				addi $t1, $t1, 1
    				beq $t1, 3, printNewline
    				beq $t1, 6, printNewline
    				blt $t1, 9, loop
    			b end
    			
    		printEmpty:
    			printStr empty
    			b cont
    		printX:
    			printStr Xmark
    			b cont
    		printO:
    			printStr Omark
    			b cont
    		printNewline:
    			printStr newline
    			b loop
    		end:
    		printStr newline
	.end_macro




.text
main:
    # print instructions to users
    # li $v0, 4
    # la $a0, instructions
    # syscall

    # Print Skeleton Sample Board
    printBoard

    # Loop counter
    # li $s0, 0

    # Jump to label player1 to begin game
    # j player1
    
    exit:
    # exit program
    li $v0, 10
    syscall
    
player1:
    # Player 1 input (integer)
    li $v0, 5
    syscall

    ### --- Implement a correct input checker here --- ###
    ### --- Update the board and check for winning condition if it passes the check --- ###

    # Increment loop counter
    add $s0, $s0, 1

    ### --- Draw condition will be implemented here --- ###

    # Player 2's turn
    j player2

player2:
    # Player 2 input (integer)
    li $v0, 5
    syscall

    ### --- Implement a correct input checker here --- ###
    ### --- Update the board and check for winning condition if it passes the check --- ###

    # Increment loop counter
    # addi $s0, 1

    ### -- Draw condition is not required to be implemented here since player 1 starts -- ##

    # Player 1's turn
    j player1

