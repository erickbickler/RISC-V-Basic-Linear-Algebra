############################## Matrix #################################
# nxm  4*n*m location on heap
# Input : size m into a0, size of n in a1.
# Output: a0 stores a nxm matrix. 
# Calls malloc allocate n*m*4 memory space.
# Then it will store the data in 0(a0), store the number of rows 4(a0), store the number of columns into 8(a0). 
# There will be an Add_Element to matrix method that will add to the location with the matrix being stored in a0, the row you want in a1, the columns want in a2, and the element want to be added in a3.  
# There will be a Get_Element method that will get the element at the row and column specified. So, the matrix will be stored in a0,  the row you want will be stored in a1, and the column you want will be stored in a2. To get the element will do 4*(a1)*(number element in the row)+(a2)=(memory location) then return the value at the location on the data portion of the matrix in a0.

.data
.text
Main:
li a0, 4
li a1, 3
jal create_Matrix
mv s0, a0
li a1, 1
li a2, 0
li a3, 10
jal set_Element
mv a0, s0
li a1, 1
li a2, 0
jal get_Element
jal print_Int
jal Print_New_Line
mv a0, s0
jal print_Matrix
li a0, 4
li a1, 3
jal create_Matrix
mv s1, a0
li a1, 3
li a2, 2
li a3, 40
jal set_Element
jal Print_New_Line
jal Print_New_Line
mv a1, s0
mv a0, s1
jal matrix_Subtraction
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

# #intializes every element to zero
# li t0, 0
# li t1, 0
# lw t2, 4(a0)
# lw t3, 8(a0)
# Loop_row_Create:        
# 	Loop_columns_Cretate:
# 		mv a1, t0
#         mv a2, t1
#         li a4, 0
#         jal set_Element
#         addi t1, t1, 1
#         beq t1, t3, End_Loop_columns_Cretate
#         j Loop_columns_Cretate
#     End_Loop_columns_Cretate:
#     li t1, 0    
#     addi t0, t0, 1
#     beq t0, t2, End_Loop_row_Create
#    j Loop_row_Create
# End_Loop_row_Create:
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
#matrix one is stored in a0
#matrix two is stored in a1
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

matrix_Subtraction:
#matrix one is stored in a0
#matrix two is stored in a1
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
li a0, 4
ecall
ret


End:
li a0, 10
ecall

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
