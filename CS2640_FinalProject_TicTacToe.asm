#Bradley Gunawan, Elsa Zheng, Joe Jhenson Ramos, Kenneth Wang, Manuel Abanto
#Group 4
#CS 2640.02 with Professor Cariaga
#Final Project: Tic Tac Toe
#Goal/Objective: Create a functional and good looking Tic Tac Toe game
#Requirements: Good UI, update board with each move, winning/ending condition (3 in a row or draw),
#For board, label each tile with numbers 1-9, and replace with X/O depending on user input
#Alternating loop for player turns, check for correct input
#For board, implement with a 1d array with 9 * 4 byte representing a 3x3 board

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


.data
	board: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 	# Reserve 9 * 4 bytes (1D array for 3x3 board) 0: Empty, 1: X, 2: O
    	Xmark: .asciiz " X "
    	Omark: .asciiz " O "
    	empty: .asciiz "   "

    	player1Win: .asciiz "\nPlayer 1 Wins!"
    	player2Win: .asciiz "\nPlayer 2 Wins!"
    	instructions: .asciiz "Player 1 is X and Player 2 is O. X (Player 1) goes first. \nPlayers take turn placing X's and O's until they reach three in a row (horizontally, vertically, or diagonally) to win or fill all the spaced to draw. \nEnter a number 1-9 that corresponds to the position you wish to put your piece in."
    	prompt1: .asciiz "\nPlayer 1's move: " #tell player 1 it's their turn
    	prompt2: .asciiz "\nPlayer 2's move: " #tell player 2 it's their turn
    	playAgain: .asciiz "\nDo you wish to play again? (type 1 for yes, or 2 to exit): "
    	newline: .asciiz "\n"
    	wrongPosition: .asciiz "\nSpot already taken or invalid input. Please enter a different value"
    	drawMsg: .asciiz "\n It's a Draw!"
    	invalidPlayAgain: .asciiz "\nInvalid: Please enter 1 to play again or enter 2 to quit."
		invalidPosition: .asciiz "\nInvalid Position. Please choose a number from (1-9)"

.text
main:
	#print instructions to users
	li $v0, 4
	la $a0, instructions
	syscall

	#Print Skeleton Sample Board
	#printBoard

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

	#check if input value is valid, 1-9
	blt $t0, 1, wrongPosition1
	bgt $t0, 9, wrongPosition1
	
	#loads base address of array into $s3
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
    
    	#ADD WINNING CONDITION CHECK
    
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

	#check if input value is valid, 1-9
	blt $t0, 1, wrongPosition2
	bgt $t0, 9, wrongPosition2
	
	#loads base address of array into $s3
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
    
    	#ADD WINNING CONDITION CHECK
    
	#Increment loop counter
	add $s0, $s0, 1

	#Player 1's turn
	j player1


#if player 1 inputs a number less than 1 or greater than 9
invalidPosition1:
	#print error message
	li $v0, 4
	la $a0, invalidPosition
	syscall

	j player1

#if player 2 inputs a number less than 1 or greater than 9
invalidPosition2:
	#print error message
	li $v0, 4
	la $a0, invalidPosition
	syscall

	j player2

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
