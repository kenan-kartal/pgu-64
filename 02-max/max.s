/*
 PURPOSE:       This program find the maximum number of a
                set of data items.


 INPUT:         None.


 OUTPUT:        Retuns the maximum number as status code.
                Can be viewed by

                echo $?

                after running the program.


 VARIABLES:
                %rdi - Holds the index of the data item being examined.
                %rax - Current data item.
                %rbx - Largest data item found.

                The following memory locations are used:

                data_items - contains the item data. A 0 is used
                to terminate the data.
*/


.data
data_items:     # These are the data items.
.long 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66, 0

.text
.global _start
_start:
movq $0, %rdi                   # Move 0 into the index register.
movq data_items(,%rdi,4), %rax  #Load the first of data.
movq %rax, %rbx                 # Since this is the first item, %rax is the biggest.

start_loop:
cmpq $0, %rax                   # Check to see if we've hit the end.
je loop_exit
incq %rdi                       # Load next value.
movq data_items(,%rdi,4), %rax
cmpq %rbx, %rax                 # Check if this value is larger.
jle start_loop                  # Jump to loop beginning if smaller or equal.
movq %rax, %rbx                 # Move the value as the largest.
jmp start_loop

loop_exit:                      # Largest value is already in %rbx,
                                # which is the status code argument for
                                # exit syscall.
movq $1, %rax                   # Store exit syscall.
int $0x80                       # Interrupt for syscall.

