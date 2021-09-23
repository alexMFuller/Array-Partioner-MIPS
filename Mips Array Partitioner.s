###########################################################
#   Program Description: Array partitioner
#   Author: Alex Fuller
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array size
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7 user value
#	$t8	even sum
#	$t9 temp
###########################################################
		.data
		sum_p:          .asciiz "Sum: "
		count_p:        .asciiz "\nCount: "
		user_value_p:      .asciiz "\nPlease input another integer:"
		error_p: 				.asciiz "\nInvalid input, try again: "

		array_d:        .word 0
		count_var:		.word 0
		sum_var:      	.word 0
###########################################################
		.text
main:

create_array:
	addi $sp, $sp, -4				# $sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					# stack[0] <- $ra (backup)

	addi $sp, $sp, -8				# $sp <- $sp - 8 (2 words: Zero IN, Two OUT)

	jal allocate_array              # call allocate_array

	lw $t0, 0($sp)					# $t0 <- base address (OUT)
	lw $t1, 4($sp)					# $t1 <- array length (OUT)
	addi $sp, $sp, 8				# $sp <- $sp + 8 (2 words)

	lw $ra, 0($sp)					# $ra <- return address (restore)
	addi $sp, $sp, 4				# $sp <- $sp + 4 (1 words)

	la $t9, array_d                 # $t9 <- address of array_d
	sw $t0, 0($t9)					# array_d <- base address

	la $t9, count_var             	# $t9 <- address of count_var
	sw $t1, 0($t9)                  # count_var <- array length

	addi $sp, $sp, -4				# $sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					# stack <- $ra (backup)

	addi $sp, $sp, -8				# $sp <- $sp - 8 (2 words)
	sw $t0, 0($sp)					# stack[0] <- base address (backup)
	sw $t1, 4($sp)					# stack[4] <- array length (backup)

	addi $sp, $sp, -12				# $sp <- $sp -12 (3 words: Two IN, One OUT)
	sw $t0, 0($sp)					# stack[0] <- base address (IN)
	sw $t1, 4($sp)					# stack[4] <- array length (IN)

	jal read_values                 # call read_array

	addi $sp, $sp, 12				# $sp <- $sp + 12 (3 words)

	lw $t0, 0($sp)					# $t0 <- base address (restore)
	lw $t1, 4($sp)					# $t1 <- array length (restore)
	addi $sp, $sp, 8

	lw $ra, 0($sp)					# $ra <- return address (restore)
	addi $sp, $sp, 4				# $sp <- $sp + 4 (1 word)

print:
	addi $sp, $sp, -4				# $sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					# stack <- $ra (backup)

	addi $sp, $sp, -8				# $sp <- $sp - 8 (2 words)
	sw $t0, 0($sp)					# stack[0] <- base address (backup)
	sw $t1, 4($sp)					# stack[4] <- array length (backup)

	addi $sp, $sp, -12				# $sp <- $sp -12 (3 words: Two IN, One OUT)
	sw $t0, 0($sp)					# stack[0] <- base address (IN)
	sw $t1, 4($sp)					# stack[4] <- array length (IN)

	jal print_array                 # call read_array

	addi $sp, $sp, 12				# $sp <- $sp + 12 (3 words)

	lw $t0, 0($sp)					# $t0 <- base address (restore)
	lw $t1, 4($sp)					# $t1 <- array length (restore)
	addi $sp, $sp, 8

	lw $ra, 0($sp)					# $ra <- return address (restore)
	addi $sp, $sp, 4				# $sp <- $sp + 4 (1 word)

sum_evens:
	addi $sp, $sp, -4				# $sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					# stack <- $ra (backup)

	addi $sp, $sp, -8				# $sp <- $sp - 8 (2 words)
	sw $t0, 0($sp)					# stack[0] <- base address (backup)
	sw $t1, 4($sp)					# stack[4] <- array length (backup)

	addi $sp, $sp, -12				# $sp <- $sp -12 (3 words: Two IN, One OUT)
	sw $t0, 0($sp)					# stack[0] <- base address (IN)
	sw $t1, 4($sp)					# stack[4] <- array length (IN)

	jal sum_even_values

	lw $t8, 8($sp)					# $t2 <- sum (OUT)
	addi $sp, $sp, 12				# $sp <- $sp + 12 (3 words)

	lw $t0, 0($sp)					# $t0 <- base address (restore)
	lw $t1, 4($sp)					# $t1 <- array length (restore)
	addi $sp, $sp, 8

	lw $ra, 0($sp)					# $ra <- return address (restore)
	addi $sp, $sp, 4				# $sp <- $sp + 4 (1 word)

	la $t9, sum_var					# $t9 <- address of sum_var
	sw $t8, 0($t9)					# sum_var <- sum

	li $v0, 4                       # printing String
	la $a0, sum_p
	syscall

	li $v0, 1                       # print sum
	move $a0, $t8
	syscall

partition_array:
	li $v0, 4                       # printing String
	la $a0, user_value_p
	syscall

partion_value_input:
	li $v0, 5						# $v0 <- user input
	syscall
	move $t7, $v0

	blez $t7, partion_error_check

	b good_value_inputed

partion_error_check:
	li $v0, 4                       # printing String
	la $a0, error_p
	syscall
	b partion_value_input


good_value_inputed:
	addi $sp, $sp, -4				# $sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					# stack <- $ra (backup)

	addi $sp, $sp, -8				# $sp <- $sp - 8 (2 words)
	sw $t0, 0($sp)					# stack[0] <- base address (backup)
	sw $t1, 4($sp)					# stack[4] <- array length (backup)

	addi $sp, $sp, -12				# $sp <- $sp -12 (3 words: Two IN, One OUT)
	sw $t0, 0($sp)					# stack[0] <- base address (IN)
	sw $t1, 4($sp)					# stack[4] <- array length (IN)

	jal partition_array_values

	addi $sp, $sp, 12				# $sp <- $sp + 12 (3 words)

	lw $t0, 0($sp)					# $t0 <- base address (restore)
	lw $t1, 4($sp)					# $t1 <- array length (restore)
	addi $sp, $sp, 8

	lw $ra, 0($sp)					# $ra <- return address (restore)
	addi $sp, $sp, 4				# $sp <- $sp + 4 (1 word)

	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		Allocate Array
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp+0	base address (OUT)
#	$sp+4	array length (OUT)
#
###########################################################
#		Register Usage
#	$t0
#	$t1 Holds Length of Array
#	$t2 holds 10
#	$t3 holds 3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
allocate_array_length_p:       .asciiz   "Please enter length of Array(Must be between 3-10):"
allocate_array_negative_p:     .asciiz   "Invalid Length!!\n"
###########################################################
		.text
allocate_array:
	li $t2, 10						# $t2 <- 10
	li $t3, 3							# $t3 <- 3
allocate_array_loop:

	li $v0, 4						# print prompt
	la $a0, allocate_array_length_p
	syscall

	li $v0, 5						# $v0 <- user input
	syscall

	blez $v0, allocate_array_bad_size	# if(input <= 0) -> allocate_array_neg_size
	bgt $v0, $t2, allocate_array_bad_size
	blt $v0, $t3, allocate_array_bad_size

	sw $v0, 4($sp)					# stack <- input length (OUT)

	sll $a0, $v0, 2					# $a0 <- input length * 2^2
	li $v0, 9                       # $v0 <- base address of dynamic array
	syscall

	sw $v0, 0($sp)					# stack <- base address (OUT)
	b allocate_array_end			# -> allocate_array_end

allocate_array_bad_size:
	li $v0, 4                       # print error msg
	la $a0, allocate_array_negative_p
	syscall

	b allocate_array_loop			# -> allocate_array_loop

allocate_array_end:
	jr $ra							# return to calling location
###########################################################
###########################################################
#		Read Values
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp+0	base address (IN)
#	$sp+4	array length (IN)
#	$sp+8	sum (OUT)
###########################################################
#		Register Usage
#	$t0 Base Address of Array
#	$t1 Length of Array
#	$t2 Divisor 12.
#	$t3
#	$t4 Remainder
#	$t5 Sum of Numbers
#	$t6 Running Count
#	$t7
#	$t8
#	$t9
###########################################################
		.data
read_values_prompt_p:       .asciiz "Enter an integer: "
read_values_invalid_p:      .asciiz "Invalid Entry. Try Again\n"
###########################################################
		.text
read_values:
	lw $t0, 0($sp)						# $t0 <- base address (IN)
	lw $t1, 4($sp)						# $t1 <- array length (IN)


read_values_loop:
	blez $t1, read_values_end			# if (counter <= 0) -> read_values_end

	li $v0, 4                          	# $v0 <- 4 (setup syscall to print string)
	la $a0, read_values_prompt_p		# $a0 <- base address of "read_values_prompt_p"
	syscall

	li $v0, 5                          	# $v0 <- 5 (setup syscall to read integer)
	syscall								# $v0 <- user input

	bltz $v0, read_values_invalid_entry # if (user input < 0) -> read_values_invalid_entry

	sw $v0, 0($t0)                   	# mem[pointer] <- valid input
	addi $t0, $t0, 4                 	# $t0 <- pointer + 4
	addi $t1, $t1, -1					# $t1 <- counter - 1


	b read_values_loop					# -> read_values_loop

read_values_invalid_entry:

	li $v0, 4                      		# Print invalid message.
	la $a0, read_values_invalid_p
	syscall

	b read_values_loop       	 		# -> read_values_read_loop
read_values_end:

	jr $ra	                        	# Return to calling location.

	###########################################################
	#      print_array subprogram
	#
	#   Subprogram description:
	#       This subprogram will receive as argument IN address of integer
	#       array and size and it iterates through array and prints all
	#       elements of array. This subprogram does not return anything
	#       as argument OUT.
	#
	###########################################################
	#       Arguments IN and OUT of subprogram
	#   $a0
	#   $a1
	#   $a2
	#   $a3
	#   $v0
	#   $v1
	#   $sp Holds array pointer (address)
	#   $sp+4 Holds array size (value)
	#   $sp+8
	#   $sp+12
	###########################################################
	#       Register Usage
	#   $t0  Holds array pointer (address)
	#   $t1  Holds array index
	###########################################################
	        .data
	print_array_array_p:    .asciiz     "Array: "
	print_array_space_p:    .asciiz     " "
	###########################################################
	        .text
	print_array:
	# save arguments so we do not lose them
	lw $t0, 0($sp)						# $t0 <- base address (IN)
	lw $t1, 4($sp)						# $t1 <- array length (IN)

	    li $v0, 4                   # prints array is:
	    la $a0, print_array_array_p
	    syscall

	print_array_while:
	    blez $t1, print_array_end   # branch to print_array_end if counter is less than or equal to zero

	# print value from array
	    li $v0, 1
	    lw $a0, 0($t0)              # $a0 <-- memory[$t0 + 0]
	                                # load a value from memory to register $a0
	    syscall

	    li $v0, 4                   # space character
	    la $a0, print_array_space_p
	    syscall

	    addi $t0, $t0, 4            # increment array pointer (address) to next word (each word is 4 bytes)
	    addi $t1, $t1, -1           # decrement array counter (index)

	    b print_array_while         # branch unconditionally back to beginning of the loop

	print_array_end:
	    jr $ra                      # jump back to the main
###########################################################
#      sum_even_values subprogram
#
#   Subprogram description:
#       This subprogram will receive as argument IN address of integer
#       array and size and it iterates through array and sum all even integers
#				and place the sum in the stack
#
###########################################################
#       Arguments IN and OUT of subprogram
#   $a0
#   $a1
#   $a2
#   $a3
#   $v0
#   $v1
#   $sp Holds array pointer (address)
#   $sp+4 Holds array size (value)
#   $sp+8
#   $sp+12
###########################################################
#       Register Usage
#   $t0  Holds array pointer (address)
#   $t1  Holds array index
#		$t2 holds sum of sum_evens
#		$t3 holds 2
#		$t4 temp
#		$t9 temp
###########################################################
        .data

###########################################################
			        .text
sum_even_values:

	lw $t0, 0($sp)						# $t0 <- base address (IN)
	lw $t1, 4($sp)						# $t1 <- array length (IN)

	li $t2, 0
	li $t3, 2

sum_while:
	blez $t1, sum_end   # branch to sdum_end if counter is less than or equal to zero

	lw $t4, 0($t0)

	rem $t9, $t4, $t3					# $t9 <- user input mod 2
	beqz $t9, sum_adder 			# if (remainder == 0) -> read_values_invalid_entry

increment:
	addi $t0, $t0, 4            # increment array pointer (address) to next word (each word is 4 bytes)
	addi $t1, $t1, -1           # decrement array counter (index)

	b sum_while         # branch unconditionally back to beginning of the loop

sum_adder:
	add $t2, $t2, $t4
	b increment

sum_end:
	sw $t2, 8($sp)						# stack[8] <- sum (OUT)
	jr $ra                      # jump back to the main

###########################################################
#      partition_array_values subprogram
#
#   Subprogram description:
#       This subprogram will receive as argument IN address of integer
#       array and size and user input and print a portion of the array less then
#				the user inputed value
#
###########################################################
#       Arguments IN and OUT of subprogram
#   $a0
#   $a1
#   $a2
#   $a3
#   $v0
#   $v1
#   $sp Holds array pointer (address)
#   $sp+4 Holds array size (value)
#   $sp+8 User inputed value
#   $sp+12
###########################################################
#       Register Usage
#   $t0  Holds array pointer (address)
#   $t1  Holds array index
#		$t2  Holds user inputed value
#		$t3
#		$t4 temp
#		$t9 temp
###########################################################
	        .data
print_array_array_pp:    .asciiz     "Partitioned Array: "
print_array_space_pp:    .asciiz     " "

###########################################################
				       .text
partition_array_values:

	lw $t0, 0($sp)						# $t0 <- base address (IN)
	lw $t1, 4($sp)						# $t1 <- array length (IN)
	lw $t2, 8($sp)						# $t2 <- user_value (IN)

	li $v0, 4                   # prints array is:
  la $a0, print_array_array_pp
  syscall

 part_array_while:
  blez $t1, part_array_end   # branch to print_array_end if counter is less than or equal to zero

	lw 		$t9, 0($t0)
  blt		$t9, $t2, good_print	# if t9 < t2  then print
	b continue

continue:

  addi $t0, $t0, 4            # increment array pointer (address) to next word (each word is 4 bytes)
  addi $t1, $t1, -1           # decrement array counter (index)

  b part_array_while         # branch unconditionally back to beginning of the loop

good_print:

	li $v0, 1
	lw $a0, 0($t0)              # $a0 <-- memory[$t0 + 0]
									 # load a value from memory to register $a0
	syscall

	li $v0, 4                   # space character
  la $a0, print_array_space_pp
  syscall

	b continue

part_array_end:

	jr $ra	#return to calling location
###########################################################
