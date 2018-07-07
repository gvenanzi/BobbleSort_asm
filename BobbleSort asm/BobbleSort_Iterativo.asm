#BubbleSort in ASM (iterative)

.globl main

.data
prompt1: 	.asciiz "Insert the vector's length"
prompt2:	.asciiz "Add a number"
vector:		.word 0:1000
N:		.word 0


.text
main:		li $v0, 4
		la $a0, prompt1
		syscall
		
		li $v0, 11
		li $a0, '\n'
		syscall
		
		li $v0, 5	#read an integer
		syscall
		
		sw $v0, N
		move $s1, $v0 	#$s1 = N, contains the array's length
		
		li $s2, 0 	#input counter
inputCicle:	beq $s2, $s1 bobblesort

		li $v0, 4
		la $a0, prompt2
		syscall
		
		li $v0, 11
		li $a0, '\n'
		syscall
		
		li $v0, 5	#read an integer
		syscall
		
		sll $s3, $s2, 2
		
		sw $v0, vector($s3)
		addi $s2, $s2, 1
		
		j inputCicle
		
		#bobblesorting start
bobblesort:	
		#use two registers like a bool
		li $s7, 0		
		li $s6, -1   	
		
		subi $s3, $s1, 1	#$s3 contains (N - 1)	
			
cicleStart:	beq $s7, $s6, endSort		
		li $s7, -1
		li $s4, 0		#iteration counter	
		
Sort:		beq $s4, $s3, cicleStart
		sll $t0, $s4, 2		#first comparator
		lw $t2, vector($t0)
		
		addi $t1, $s4, 1
		sll $t1, $t1, 2		#second comparator		
		lw $t3, vector($t1)
		
		ble $t2, $t3, continue
		li $s7, 0
		#reverse the elements's position
		sw $t2, vector($t1)
		sw $t3, vector($t0)
continue:	addi $s4, $s4, 1
		j Sort
		
endSort:	sw $s1, N 		# N vector's lenght
		
		li $s2, 0		#iteration counter
control_repetitions:
		beq $s2, $s1, print
		
		sll $t0, $s2, 2 	#vector's index
		lw $s3, vector($t0)
		
		addi $s4, $s2, 1	#counter for the remaining vector's values (I)
		
repetition:	beq $s4, $s1, end_check	#branch if there aren't any other repetition of the same value
		
		sll $t1, $s4, 2		#offset of the value to check
		lw  $s5, vector($t1)
		
		beq $s3, $s5, elimina_ripetizione	#branch if it's a repetition
		
		#if not add one to the counter
		addi $s4, $s4, 1
		
		j repetition
		
end_check: 	addi $s2, $s2, 1
		j control_repetitions
		
elimina_ripetizione:
		li $s5, 0		#change the repetive value with 0
		sw $s5, vector($t1)	#even in the memory 
		
		lw $s7, N		
		subi $s7, $s7, 1	
	
		move $s6, $s4		#index of the repetition value
		
shift_cicle:	beq $s6, $s7, end_shift
		sll $t3, $s6, 2		#offset of the index where the next value has to shift
		
		addi $t6, $s6, 1	
		sll $t6, $t6, 2		#offset of the following value
		lw $t6, vector($t6)	#value of the following position
		
		sw $t6, vector($t3)	#memory the value in the previous position
		
		addi $s6, $s6, 1	#add one to the counter
		j shift_cicle
		
end_shift:	subi $s1, $s1, 1
		
		sw $s1, N
		j repetition
		
print:
		li $v0, 11
		li $a0, '\n'
		syscall
		
		#valore N 
		lw $s0, N
		#counter
		li $s1, 0

print_cicle:	beq $s2, $s1 end_program
		sll $t0, $s1, 2
		
		li $v0, 1	#print an integer
		lw $a0, vector($t0)
		syscall	

		addi $s1, $s1, 1
		
		j print_cicle
		
end_program:	li $v0, 10
		syscall
		
		
		
		
		
		
		
		
				
		
		
