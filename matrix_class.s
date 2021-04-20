############################## Matrix #################################
# nxm  4*n*m location on heap
# Input : size m into a0, size of n in a1.
# Output: a0 stores a nxm matrix. 
# Calls malloc allocate n*m*4 memory space.
# Then it will store the data in 0(a0), store the number of rows 4(a0), store the number of columns into 8(a0). 
# There will be an Add_Element to matrix method that will add to the location with the matrix being stored in a0, the row you want in a1, the columns want in a2, and the element want to be added in a3.  
# There will be a Get_Element method that will get the element at the row and column specified. So, the matrix will be stored in a0,  the row you want will be stored in a1, and the column you want will be stored in a2. To get the element will do 4*(a1)*(number element in the row)+(a2)=(memory location) then return the value at the location on the data portion of the matrix in a0.

.data
Failed: .asciiz "Failed Execution"

.text
Main:
#Matrix 1
li a0, 2
li a1, 1
jal create_Matrix
mv s0, a0
li a1, 0
li a2, 0
li a3, 10
jal set_Element
li a1, 1
li a2, 0
li a3, 10
jal set_Element
#Matrix 2
li a0, 1
li a1, 3
jal create_Matrix
mv s1, a0
li a1, 0
li a2, 0
li a3, 10
jal set_Element
li a1, 0
li a2, 1
li a3, 10
jal set_Element
li a1, 0
li a2, 2
li a3, 50
jal set_Element
#Matrix Multiply
mv a0, s0
mv a1, s1
jal matrix_Multiplication
#Store result matrix, hopefully [100, 100] into s2
mv s2, a0
#Print s2 matrix
mv a0, s2
jal print_Matrix
j End



#Note:  rows start at zero
create_Matrix:
addi sp, sp, -12
sw a0, 0(sp)#number of rows in a0
sw a1, 4(sp)#number of colums a1
sw ra, 8(sp)# stores return address

# this allocates room on the heap
mul a0, a0, a1
li t0, 4 # to allocate 4 bytes to each element
mul a0, a0, t0
addi a0, a0, 4
addi a0, a0, 12
jal Malloc
sw a0, 0(a0)

# this stores the number of rows
lw a1, 0(sp)
sw a1, 4(a0)

# this stores the number of colums
lw a1, 4(sp)
sw a1, 8(a0)
lw ra, 8(sp) # set return address
addi sp,sp,12
ret

set_Element:
#matrix being stored in a0
#the row you want in a1
#the columns want in a2
#element want to be added in a3

#stores element, row, colum wanted in the stack
addi sp,sp,-12
sw a1, 0(sp)
sw a2, 4(sp)
sw a3, 8(sp)
#gets right memory location
lw a1, 0(a0)#load the data portion into a1
lw a3, 0(sp)# load the row wanted into a3
lw a2, 8(a0)# loads the number of columns into a2
mul a2, a2, a3# then multimpls number elements   
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
#matrix being stored in a0
#the row you want in a1
#the columns want in a2
#stores element, row, colum wanted in the stack
#returns in a0
addi sp, sp, -8
sw a1, 0(sp)
sw a2, 4(sp)
#gets right memory location
lw a1, 0(a0)#load the data portion into a1
lw a3, 0(sp)# load the row wanted into a3
lw a2, 8(a0)# loads the number of columns into a2
mul a2, a2, a3# then multimpls number elements   
lw a3, 4(sp)
add a2, a2, a3
li a3, 4
mul a2, a2, a3
add a1, a1, a2
addi a1,a1,12
lw a0, 0(a1)
addi sp, sp, 8
ret

matrix_Addition:
addi sp, sp, -16
sw ra, 12(sp)
#input validation 
lw t1, 0(a0)
lw t2, 0(a1)
bne t1, t2, Matrix_Addtion_Failed
lw t1, 0(a0)
lw t2, 0(a1)
bne t1, t2, Matrix_Addtion_Failed
#matrix one is stored in a0
#matrix two is stored in a1
# returns resulting matrix in a0
# the matricies should be the same size
sw a0, 0(sp)
sw a1, 4(sp)
# t0 is the row
# t1 is the colium
# t2 is the size of row
# t3 is tha size of columns
# t4 is the element from first matrix

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
addi sp, sp, -16
sw ra, 12(sp)
#input validation 
lw t1, 0(a0)
lw t2, 0(a1)
bne t1, t2, Matrix_Subtraction_Failed
lw t1, 0(a0)
lw t2, 0(a1)
bne t1, t2, Matrix_Subtraction_Failed
#matrix one is stored in a0
#matrix two is stored in a1
# returns resulting matrix in a0
# the matricies should be the same size
sw a0, 0(sp)
sw a1, 4(sp)
# t0 is the row
# t1 is the colium
# t2 is the size of row
# t3 is tha size of columns
# t4 is the element from first matrix

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
#matrix one is stored in a0
#what you are scaling  by in a1
# returns resulting matrix in a0
# the matricies should be the same size
addi sp, sp, -16
sw ra, 12(sp)
sw a0, 0(sp)
sw a1, 4(sp)
# t0 is the row
# t1 is the colium
# t2 is the size of row
# t3 is tha size of columns
# t4 is the element from the matrix

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


matrix_Transpos:
#store matrix your taking the transpose of in a0
addi sp, sp, -12
sw a0, 0(sp)
sw ra, 8(sp)
li t1, 0
lw t2, 4(a0)
lw t3, 8(a0)
mv a0, t3
mv a1, t2
jal create_Matrix # creates the transpose matrix
sw a0, 4(sp)
li t0, 0
Loop_row_Transpos:        
		Loop_columns_Transpos:
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
        	beq t1, t3, End_Loop_columns_Transpos
        	j Loop_columns_Transpos
	End_Loop_columns_Transpos:
    li t1, 0    
    addi t0, t0, 1
    beq t0, t2, End_Loop_row_Transpos
	j Loop_row_Transpos
End_Loop_row_Transpos:
lw ra, 8(sp)
lw a0, 4(sp)
addi sp, sp, 12
ret

matrix_Multiplication:
#Matrix Multiplication
#Matrix one stored in a0
#Matrix two stored in a1
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
addi, t5, t5, -1
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
    addi sp, sp, 16
    #Return
    ret
    
matrix_Multiplication_Fail:
	lw ra, 12(sp)
	addi sp, sp, 16
    jal print_fail
    ret

print_Matrix:
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

#################################End Of matrix#####################################
Malloc:
addi a1, a0, 0
addi a0, x0 9
ecall
jr ra

Free:
mv a1, a0
li a0, 0x3CC
li a6, 4
ecall
ret

End:
li a0, 10
ecall

print_fail:
    la a1, Failed
    li a0,4
    ecall
	ret

print_Int:
mv a1, a0
li a0, 1
ecall
ret

Print_New_Line:
li a1, '\n'
li a0, 11
ecall
ret

print_space:
li a1, 32
li a0, 11
ecall
ret
