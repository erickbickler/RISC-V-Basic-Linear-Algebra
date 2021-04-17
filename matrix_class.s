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
li a1, 0
li a2, 2
li a3, 10
jal set_Element
mv a0, s0
li a1, 0
li a2, 2
jal get_Element
jal print_Int
j End



#Note:  rows start at zero
create_Matrix:
sw a0, 0(sp)#number of rows in a0
sw a1, 4(sp)#number of colums a1
sw ra, 8(sp)# stores return address

# this allocates room on the heap
mul a0, a0, a1
li t0, 4 # to allocate 4 bytes to each element
mul a0, a0, t0
jal Malloc
sw a0, 0(a0)

# this stores the number of rows
lw a1, 0(sp)
sw a1, 4(a0)

# this stores the number of colums
lw a1, 4(sp)
sw a1, 8(a0)

lw ra, 8(sp) # set return address
ret 

set_Element:
#matrix being stored in a0
#the row you want in a1
#the columns want in a2
#element want to be added in a3

#stores element, row, colum wanted in the stack
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
lw a2, 8(sp)
sw a2, 0(a1)
ret

get_Element:
#matrix being stored in a0
#the row you want in a1
#the columns want in a2
#stores element, row, colum wanted in the stack
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
lw a0, 0(a1)
ret


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












