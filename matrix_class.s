.data
Failed: .asciiz "Failed Execution" # This string is the message that we will print if an operation fails.

.text
Main:
	# The main method is used for testing and showcasing our codes functionality.
	# Creating matrix 1 and setting values in the matrix
	li a0, 3
	li a1, 1
	jal create_Matrix
	mv s0, a0
	li a1, 0
	li a2, 0
	li a3, 1
	jal set_Element
	li a1, 1
	li a2, 0
	li a3, 1
	jal set_Element
	li a1, 2
	li a2, 0
	li a3, 1
	jal set_Element
	mv a0, s0
	jal print_Matrix
	jal Print_New_Line
    
	# Creating matrix 2 and setting values in the matrix
	li a0, 3
	li a1, 1
	jal create_Matrix
	mv s1, a0
	li a1, 0
	li a2, 0
	li a3, 10
	jal set_Element
	li a1, 1
	li a2, 0
	li a3, 10
	jal set_Element
	li a1, 2
	li a2, 0
	li a3, 50
	jal set_Element
	mv a0, s1
	jal print_Matrix
	jal Print_New_Line
    
	# Testing the matrix multiplication method
	mv a0, s0
	mv a1, s1
	jal dot_Product
	mv s2, a0           # Storing the resulting matrix into s2
	mv a0, s2
	jal print_Matrix    # Printing the resulting matrix
	j End


###################### MATRIX DATA STRUCTURE ######################
# nxm  4*n*m location on heap
# Input : size m into a0, size of n in a1.
# Output: a0 stores a nxm matrix. 
# Calls malloc allocate n*m*4 memory space.
# Then it will store the data in 0(a0), store the number of rows 4(a0), store the number of columns into 8(a0). 
# There will be an Add_Element to matrix method that will add to the location with the matrix being stored in a0, the row you want in a1, the columns want in a2, and the element want to be added in a3.  
# There will be a Get_Element method that will get the element at the row and column specified.
# So, the matrix will be stored in a0, the row you want will be stored in a1, and the column you want will be stored in a2.
# To get the element will do 4*(a1)*(number element in the row)+(a2)=(memory location) then return the value at the location on the data portion of the matrix in a0.

#Note:  rows start at zero
create_Matrix:
	# This method creates a matrix of a given size.
	addi sp, sp, -12
	sw a0, 0(sp)               # Storing the number of rows in a0
	sw a1, 4(sp)               # Storing the number of columns a1
	sw ra, 8(sp)               # Storing the return address in ra
	
	# This code allocates room on the heap
	mul a0, a0, a1
	li t0, 4                   # Allocating 4 bytes to each element
	mul a0, a0, t0
	addi a0, a0, 4
	addi a0, a0, 12
	jal Malloc
	sw a0, 0(a0)
	
	# This code stores the number of rows
	lw a1, 0(sp)
	sw a1, 4(a0)
	
	# This code stores the number of columns
	lw a1, 4(sp)
	sw a1, 8(a0)
	lw ra, 8(sp)               # Set return address
	addi sp,sp,12
	ret

set_Element:
	# This method allows you to set an element in a certain location in the matrix.
    # Parameters: a0 holds the matrix, a1 holds the intended row, a2 holds the intended column, a3 holds the element to be added
	
	# This code stores the element, row, column wanted in the stack
	addi sp,sp,-12
	sw a1, 0(sp)
	sw a2, 4(sp)
	sw a3, 8(sp)
    
	# This code gets the correct memory location
	lw a1, 0(a0)          # Load the data portion into a1
	lw a3, 0(sp)          # Load the row wanted into a3
	lw a2, 8(a0)          # Load the number of columns into a2
	mul a2, a2, a3        # Multiply the number of elements   
	lw a3, 4(sp)
	add a2, a2, a3
	li a3, 4
	mul a2, a2, a3
	add a1, a1, a2
	addi a1,a1, 12
	lw a2, 8(sp)
	sw a2, 0(a1)
	addi sp,sp,12
	ret

get_Element:
	# This method returns the element in a certain location in the matrix.
    # Parameters: a0 holds the matrix, a1 holds the intended row, a2 holds the intended column
    # Stores the element, row, and column in the stack
    # Output: a0 holds the element in the given location in the matrix
    
	addi sp, sp, -8
	sw a1, 0(sp)
	sw a2, 4(sp)
    
	# This code gets the correct memory location
	lw a1, 0(a0)            # Load the data portion into a1
	lw a3, 0(sp)            # Load the row wanted into a3
	lw a2, 8(a0)            # Load the number of columns into a2
	mul a2, a2, a3          # Multiply the number of elements   
	lw a3, 4(sp)
	add a2, a2, a3
	li a3, 4
	mul a2, a2, a3
	add a1, a1, a2
	addi a1,a1,12
	lw a0, 0(a1)
	addi sp, sp, 8
	ret
#################### MATRIX DATA STRUCTURE END ####################

#################### BASIC LINEAR ALGEBRA METHODS ####################
matrix_Addition:
	# This method adds two matrices together.
    # NOTE: The matrices MUST be the same size for matrix addition.
    # Parameters: a0 holds matrix 1, a1 holds matrix 2
    # Output: a0 holds the resulting matrix
    # Values used in the method: t0 is the row, t1 is the column, t2 is the size of row, t3 is the size of columns, t4 is the element from first matrix
	
	addi sp, sp, -16
	sw ra, 12(sp)
	# Input validation 
	lw t1, 4(a0)
	lw t2, 4(a1)
	bne t1, t2, Matrix_Addtion_Failed
	lw t1, 8(a0)
	lw t2, 8(a1)
	bne t1, t2, Matrix_Addtion_Failed
    
	sw a0, 0(sp)
	sw a1, 4(sp)
    
	li t1, 0
	lw t2, 4(a0)
	lw t3, 8(a0)
	mv a0, t2
	mv a1, t3
	jal create_Matrix
	li t0, 0
	sw a0, 8(sp)
    
	Loop_row_add:        
		Loop_columns_Add:
    		lw a0, 0(sp)
      		mv a1, t0
        	mv a2, t1
        	jal get_Element
        	mv t4, a0
        	lw a0, 4(sp)
        	mv a1, t0
        	mv a2, t1
        	jal get_Element
        	add a3, a0, t4
        	lw a0, 8(sp)
        	mv a1, t0
        	mv a2, t1
        	jal set_Element
        	addi t1, t1, 1
        	beq t1, t3, End_Loop_columns_Add
        	j Loop_columns_Add
            
	End_Loop_columns_Add:
    	li t1, 0    
    	addi t0, t0, 1
    	beq t0, t2, End_Loop_row_add
		
    	j Loop_row_add

End_Loop_row_add:
	lw a0, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	ret

Matrix_Addtion_Failed:
	jal print_fail
	lw ra, 12(sp)
	ret

matrix_Subtraction:
	# This method subtracts two matrices from each other.
    # NOTE: The matrices MUST be the same size for matrix addition.
    # Parameters: a0 holds matrix 1, a1 holds matrix 2
    # Output: a0 holds the resulting matrix
    # Values used in the method: t0 is the row, t1 is the column, t2 is the size of row, t3 is the size of columns, t4 is the element from first matrix
	
	addi sp, sp, -16
	sw ra, 12(sp)
	# Input validation 
	lw t1, 4(a0)
	lw t2, 4(a1)
	bne t1, t2, Matrix_Subtraction_Failed
	lw t1, 8(a0)
	lw t2, 8(a1)
	bne t1, t2, Matrix_Subtraction_Failed
    
	sw a0, 0(sp)
	sw a1, 4(sp)
    
	li t1, 0
	lw t2, 4(a0)
	lw t3, 8(a0)
	mv a0, t2
	mv a1, t3
	jal create_Matrix
	li t0, 0
	sw a0, 8(sp)
    
	Loop_row_Sub:        
		Loop_columns_Sub:
    		lw a0, 0(sp)
      		mv a1, t0
        	mv a2, t1
        	jal get_Element
        	mv t4, a0
        	lw a0, 4(sp)
        	mv a1, t0
        	mv a2, t1
        	jal get_Element
        	sub a3, t4, a0
        	lw a0, 8(sp)
        	mv a1, t0
        	mv a2, t1
        	jal set_Element
        	addi t1, t1, 1
        	beq t1, t3, End_Loop_columns_Sub
        	j Loop_columns_Sub
            
	End_Loop_columns_Sub:
    	li t1, 0    
    	addi t0, t0, 1
    	beq t0, t2, End_Loop_row_Sub
		
    	j Loop_row_Sub

End_Loop_row_Sub:
	lw a0, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	ret

Matrix_Subtraction_Failed:
	jal print_fail
	lw ra,12(sp)
	ret

matrix_Scalar_Multiplication:
	# This method scales a matrix by a value.
    # Parameters: a0 holds the matrix, a1 holds the value to scale by
    # Output: a0 holds the resulting matrix
    # Values used in the method: t0 is the row, t1 is the column, t2 is the size of row, t3 is the size of columns, t4 is the element from first matrix
	
	addi sp, sp, -16
	sw ra, 12(sp)
	sw a0, 0(sp)
	sw a1, 4(sp)
	
	li t1, 0
	lw t2, 4(a0)
	lw t3, 8(a0)
	mv a0, t2
	mv a1, t3
	jal create_Matrix
	li t0, 0
	sw a0, 8(sp)
    
	Loop_row_Scalar_Multiplication:        
		Loop_columns_Scalar_Multiplication:
    		lw a0, 0(sp)
      		mv a1, t0
        	mv a2, t1
        	jal get_Element
			lw t4, 4(sp)
        	mul a3, t4, a0
        	lw a0, 8(sp)
        	mv a1, t0
        	mv a2, t1
        	jal set_Element
        	addi t1, t1, 1
        	beq t1, t3, End_Loop_columns_Scalar_Multiplication
        	j Loop_columns_Scalar_Multiplication
    
	End_Loop_columns_Scalar_Multiplication:
    	li t1, 0    
    	addi t0, t0, 1
    	beq t0, t2, End_Loop_row_Scalar_Multiplication
		
    	j Loop_row_Scalar_Multiplication

End_Loop_row_Scalar_Multiplication:
	lw a0, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	ret


matrix_Transpose:
	# This gets the transpose of a matrix.
    # Parameters: a0 holds the matrix
    # Output: a0 holds the resulting matrix
    # Values used in the method: t0 is the row, t1 is the column, t2 is the size of row, t3 is the size of columns, t4 is the element from first matrix
	
	addi sp, sp, -12
	sw a0, 0(sp)
	sw ra, 8(sp)
	li t1, 0
	lw t2, 4(a0)
	lw t3, 8(a0)
	mv a0, t3
	mv a1, t2
	jal create_Matrix 				# Creates the transpose matrix
	sw a0, 4(sp)
	li t0, 0
    
	Loop_row_Transpose:        
		Loop_columns_Transpose:
    		lw a0, 0(sp)
      		mv a1, t0
        	mv a2, t1
        	jal get_Element
            mv a3, a0
        	lw a0, 4(sp)
        	mv a1, t1
        	mv a2, t0
        	jal set_Element
        	addi t1, t1, 1
        	beq t1, t3, End_Loop_columns_Transpose
        	j Loop_columns_Transpose
            
	End_Loop_columns_Transpose:
    	li t1, 0    
    	addi t0, t0, 1
    	beq t0, t2, End_Loop_row_Transpose
		j Loop_row_Transpose
        
End_Loop_row_Transpose:
	lw ra, 8(sp)
	lw a0, 4(sp)
	addi sp, sp, 12
	ret

matrix_Multiplication:
	# This method multiplies two matrices together.
    # NOTE: The matrices MUST be a proper size.
    # Parameters: a0 holds matrix 1, a1 holds matrix 2
    # Output: a0 holds the resulting matrix
    # Values used in the method: t0 is the row, t1 is the column, t2 is the size of row, t3 is the size of columns, t4 is the element from first matrix
    #NOTES:
	#a0 x a1 => row1, col1 x row2, col2
	#In order for matrix multiplication to work, the insides (col1, row2) need to be the same
	#The resulting matrix size = row1 x col2
    
	addi sp, sp, -40
	sw ra, 12(sp)
	sw a0, 0(sp)
	sw a1, 4(sp)
    
	#Make sure matrix's CAN multiply
	#compare matrix 1 cols and matrix 2 rows
	lw t1, 8(a0)
	lw t2, 4(a1)
	lw t4, 4(a1)
	sw t4, 16(sp)
    
	#If they aren't equal, they can't be multiplied so fail
	bne t1, t2, matrix_Multiplication_Fail
    
	#Load in the sizes and create the result matrix
	lw t1, 4(a0)
	lw t4, 4(a0)
	sw t4, 24(sp)
	lw t2, 8(a1)
	lw t4, 8(a1)
	sw t4, 20(sp)
	mv a0, t1
	mv a1, t2
	jal create_Matrix
    
	#Store result matrix in 8(sp)
	sw a0, 8(sp)
	li t0, 0
	li t1, 0
	li t2, 0
    
	#calculate the t3 value = # # of elements to add
	#Get row of matrix 1
	lw t3, 24(sp)
	addi, t3, t3, -1
	lw t4, 20(sp)
	addi, t4, t4, -1
	lw t5, 16(sp)

#Start the looping for the job
Mul_Loop:
	#Get the first element
    lw a0, 0(sp)
    mv a1, t0
    mv a2, t2
    jal get_Element
	#Store first element in 16(sp)
	sw a0, 16(sp)
    #Get second Element
    lw a0, 4(sp)
	mv a1, t2
    mv a2, t1
    jal get_Element
    #Store second element in s10
    sw a0, 28(sp)
    #Do the multiplication and store that value in s9
    lw a3, 16(sp)
    mul a3, a3, a0
    #Now add it to the cumulative register a4
    add a4, a4, a3
    #Increment t2
    addi t2, t2, 1
    #Check to see if loop done
    bge t2, t5, Loop_YRow_Done
    j Mul_Loop

Loop_YRow_Done:
	#Store s11 in result matrix at location t0, t1
    lw, a0, 8(sp)
    mv a1, t0
    mv a2, t1
    mv a3, a4
    jal set_Element
    #Clear a4
    li a4, 0
    #Reset t2
    li t2, 0
    #Check if we are done with YCol Loop
    bge t1, t4, Loop_YCol_Done
    #Increment t1
    addi t1, t1, 1
    #If not, jump back into the loop
    j Mul_Loop
            
Loop_YCol_Done:
	#Reset t1
    li t1, 0
    #Check t0
    bge t0, t3, matrix_Multiplication_End
    #If not at the end, increment t0
    addi t0, t0, 1
    #Jump back into the loop
    j Mul_Loop
            
matrix_Multiplication_End:
	#Load return address
	lw ra, 12(sp)
    #Make result matrix a0
    lw a0, 8(sp)
    #Reset stack pointer
    addi sp, sp, 40
    #Return
    ret
    
matrix_Multiplication_Fail:
	lw ra, 12(sp)
	addi sp, sp, 40
    jal print_fail
    ret

dot_Product:
	# This method calculates the dot product of two vectors.
    # Parameters: a0 holds vector 1, a1 holds vector 2
    # Output: a0 holds the resulting matrix
    # Values used in the method: t0 is the row, t1 is the column, t2 is the size of row, t3 is the size of columns, t4 is the element from first matrix
    
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw ra, 8(sp)
	jal matrix_Transpose
	sw a0, 12(sp)
	lw a1, 4(sp)
	lw a0, 4(a1)
	lw a1, 8(a1)
	jal create_Matrix
	lw a1, 4(sp)
	lw a0, 4(a1)
	lw a1, 8(a1)
	bgt a0, a1 Row_Vector_Dot_Product
	lw a0, 4(sp)
	lw a1, 12(sp)
	jal matrix_Multiplication
	lw ra, 8(sp)
	ret
	Row_Vector_Dot_Product:
	lw a0, 12(sp)
	lw a1, 4(sp)
	jal matrix_Multiplication
	lw ra, 8(sp)
	ret
################## BASIC LINEAR ALGEBRA METHODS END ##################


############################ HELPER METHODS ############################
print_Matrix:
	# This method prints a matrix.
	addi sp, sp, -8
	sw a0, 0(sp)
	sw ra, 4(sp)
	li t0, 0
	li t1, 0
	lw t2, 4(a0)
	lw t3, 8(a0)
    
	Loop_row_Print:        
		Loop_columns_Print:
			lw a0, 0(sp)
        	mv a1, t0
        	mv a2, t1
        	jal get_Element
        	jal print_Int
        	jal print_space
        	addi t1, t1, 1
        	beq t1, t3, End_Loop_columns_Print
        	j Loop_columns_Print
            
    End_Loop_columns_Print:
    	li t1, 0    
    	addi t0, t0, 1
    	jal Print_New_Line
    	beq t0, t2, End_Loop_row_Print
   		j Loop_row_Print
        
End_Loop_row_Print:
	lw a0, 0(sp)
	lw ra, 4(sp)
	ret

Malloc:
	# This method allocates memory.
	addi a1, a0, 0
	addi a0, x0 9
	ecall
	jr ra

Free:
	# This method frees allocated memory.
	mv a1, a0
	li a0, 0x3CC
	li a6, 4
	ecall
	ret

End:
	# This method ends the program.
	li a0, 10
	ecall

print_fail:
	# This method prints the failed string.
    la a1, Failed
    li a0,4
    ecall
	ret

print_Int:
	# This method prints an integer value.
	mv a1, a0
	li a0, 1
	ecall
	ret

Print_New_Line:
	# This method prints a new line.
	li a1, '\n'
	li a0, 11
	ecall
	ret

print_space:
	# This method prints a blank space.
	li a1, 32
	li a0, 11
	ecall
	ret
########################## HELPER METHODS END ##########################
