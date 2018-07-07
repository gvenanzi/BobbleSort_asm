#BubbleSort in ASM (ricorsivo)

.globl main

.data
prompt1: 	.asciiz "Insert the vector's length"
prompt2:	.asciiz "Add a number"
vector:		.word 0:100
N:		.word 0


.text
main:		li $v0, 4
		la $a0, prompt1 #read a string
		syscall
		
		li $v0, 11
		li $a0, '\n'  	#read a char
		syscall
		
		li $v0, 5	#read an integer
		syscall
		
		sw $v0, N
		move $s1, $v0 	#$s1 = N, contains the array's length
		
		li $s2, 0 	#input counter
		jal inputCicle
		
		jal bobblesort
		
		sw $s1, N 		# N vector's lenght
		li $s2, 0		#iteration counter
		jal control_repetitions
		
		jal print
		
end_program:	li $v0, 10
		syscall
		
		
		
		
inputCicle:	subi $sp, $sp, 4	#alloco il registro di ritorno nello stack
		sw $ra, 0($sp)
		
		beq $s2, $s1 inputEnd

		li $v0, 4
		la $a0, prompt2	#read a string
		syscall
		
		li $v0, 11
		li $a0, '\n'	#read a char
		syscall
		
		li $v0, 5	#read an integer
		syscall
		
		sll $s3, $s2, 2
		
		sw $v0, vector($s3)
		addi $s2, $s2, 1
		
		jal inputCicle

inputEnd:	lw $ra, , 0($sp)
		addi $sp, $sp, 4

		jr $ra
		
bobblesort:	
		#use two registers like a bool
		li $s7, 0		
		li $s6, -1   	
		subi $s3, $s1, 1	#$s3 contains (N - 1)	
cicleStart:	beq $s7, $s6, endSort	
	
		subi $sp, $sp, 4
		sw $ra, 0($sp)		# before the cicle start i have to allocate the $ra

		li $s7, -1
		li $s4, 0		#iteration counter
		jal Sort
endSort:	
		#il bobbleSort è finito devo scaricare il registro di ritorno 
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra 		#torna al chiamante

Sort:		beq $s4, $s3, cicleStart

		subi $sp, $sp, 4
		sw $ra, 0($sp)		#save the register address

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
		jal Sort

		#il Sort è finito devo scaricare il registro di ritorno 
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra 				#torna al chiamante
		
control_repetitions:
		subi $sp, $sp, 4		#allocazione in memoria del registro di ritorno
		sw $ra, 0($sp)
		
		beq $s2, $s1, end_control	#salto a fine se il ciclo è finito
		
		sll $t0, $s2, 2 		#vector's index
		lw $s3, vector($t0)
		
		addi $s4, $s2, 1		#counter for the remaining vector's values 

		jal repetition
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra 	
		
repetition:	subi $sp, $sp, 4
		sw $ra, 0($sp)
		
		beq $s4, $s1, end_repetition 	#branch if there aren't any other possible repetition of the same value
		
		sll $s7, $s4, 2			#offset of the value to check
		lw  $s5, vector($s7)
		
		beq $s3, $s5, salta_alla_fase_di_eliminazione	#branch if it's a repetition
		
		#if not add one to the counter
		addi $s4, $s4, 1
		
		jal repetition
end_control:	lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra 		#torna al chiamante		

end_repetition:	addi $s2, $s2, 1
		
		jal control_repetitions

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra 		#torna al chiamante	

salta_alla_fase_di_eliminazione:
		jal elimina_ripetizione

		subi $s1, $s1, 1
		sw $s1, N
		jal repetition
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra 	

elimina_ripetizione:
		li $s5, 0		#change the repetive value with 0
		sw $s5, vector($s7)	#even in the memory 
		
		lw $s7, N		
		subi $s7, $s7, 1	
	
		move $s6, $s4		#index of the repetition value
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)

		jal shift_cicle
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
shift_cicle:	beq $s6, $s7, end_shift

		subi $sp, $sp, 4
		sw $ra, 0($sp)
		
		sll $t3, $s6, 2		#offset of the index where the next value has to shift
		
		addi $t6, $s6, 1	
		sll $t6, $t6, 2		#offset of the following value
		lw $t6, vector($t6)	#value of the following position
		
		sw $t6, vector($t3)	#memory the value in the previous position
		
		addi $s6, $s6, 1	#add one to the counter
		jal shift_cicle
		
end_shift:	lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra 			#torna al chiamante
		
print:
		li $v0, 11
		li $a0, '\n'
		syscall
		
		#valore N 
		lw $s0, N
		#counter
		li $s1, 0

print_cicle:	beq $s1, $s0 end_print
		subi $sp, $sp, 4
		sw $ra, 0($sp)

		sll $t0, $s1, 2
		
		li $v0, 1		#print an integer
		lw $a0, vector($t0)
		syscall	

		addi $s1, $s1, 1
		
		jal print_cicle

end_print:	lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		

