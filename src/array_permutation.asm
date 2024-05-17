#Dominick Ferro, Assembly Language(MIPS), Assignment 3
#10/9/23
#In this Assignment we will write an assembly 
#program that uses loops with indirect 
#or indexed addressing to permutate (re-arranges) an integer array.
.data
array:      .space 40  # Space for 10 integers
permutation: .space 40  # Space for 10 integers
size:       .word 10   # Assuming size is 10
promptArray: .asciiz "Please enter the 10 elements of your array: "
promptPerm: .asciiz "Please enter the permutation: "
resultMsg:  .asciiz "The array after permutation is: "

.text
.globl main

main:
    # Input array elements
    li $v0, 4
    la $a0, promptArray
    syscall
    li $t0, 0  # loop counter
    la $t1, array  # address of array
input_loop:
    beq $t0, 10, perm_input  # if counter == 10, jump to perm_input
    li $v0, 5
    syscall
    sw $v0, 0($t1)
    add $t1, $t1, 4  # move to next array element
    add $t0, $t0, 1  # increment counter
    j input_loop

perm_input:
    # Input permutation
    li $v0, 4
    la $a0, promptPerm
    syscall
    li $t0, 0  # reset loop counter
    la $t1, permutation  # address of permutation
perm_loop:
    beq $t0, 10, perm_algorithm  # if counter == 10, jump to perm_algorithm
    li $v0, 5
    syscall
    sw $v0, 0($t1)
    add $t1, $t1, 4  # move to next permutation element
    add $t0, $t0, 1  # increment counter
    j perm_loop

perm_algorithm:
    # Permutation algorithm
    li $t0, 0  # i
    la $t1, array
    la $t2, permutation
perm_alg_loop:
    bge $t0, 9, output_result  # if i >= 9, jump to output_result
    lw $t3, 0($t2)  # Permutation[i]
    lw $t4, 0($t1)  # Array[i]
    
    # Calculate address for Array[Permutation[i]]
    li $t6, 4
    mul $t6, $t3, $t6  # $t6 = 4 * Permutation[i]
    add $t6, $t1, $t6  # $t6 = address of Array[Permutation[i]]
    
    lw $t5, 0($t6)  # Load Array[Permutation[i]]
    sw $t5, 0($t1)  # Array[i] = Array[Permutation[i]]
    sw $t4, 0($t6)  # Array[Permutation[i]] = temp
    
    addi $t0, $t0, 1  # i++
    add $t1, $t1, 4  # move to next array element
    add $t2, $t2, 4  # move to next permutation element
    j perm_alg_loop

output_result:
    # Output result
    li $v0, 4
    la $a0, resultMsg
    syscall
    li $t0, 0  # reset loop counter
    la $t1, array  # address of array
output_loop:
    beq $t0, 10, program_exit  # if counter == 10, jump to program_exit
    li $v0, 1
    lw $a0, 0($t1)
    syscall
    add $t1, $t1, 4  # move to next array element
    add $t0, $t0, 1  # increment counter
    j output_loop

program_exit:
    # Exit
    li $v0, 10
    syscall
