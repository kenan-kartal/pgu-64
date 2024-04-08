# PURPOSE:      This program find the maximum number of a
#               set of data items.
#
# VARIABLES:
#               %edi - Holds the index of the data item being examined.
#               %eax - Current data item.
#               %ebx - Largest data item found.
#
# The following memory locations are used:
#
#               data_items - contains the item data. A 0 is used
#                       to terminate the data.
#

.section .data

data_items:     # These are the data items.
.long 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66, 0

.section .text

.global _start
_start:
movl $0, %edi                   # Move 0 into the index register.
movl data_items(,%edi,4), %eax  #Load the first of data.
movl %eax, %ebx                 # Since this is the first item, %eax is
                                # the biggest.

start_loop:
cmpl $0, %eax                   # Check to see if we've hit the end.
je loop_exit
incl %edi                       # Load next value.
movl data_items(,%edi,4), %eax
cmpl %ebx, %eax                 # Check if this value is larger.
jle start_loop                  # Jump to loop beginning if smaller or equal.
movl %eax, %ebx                 # Move the value as the largest.
jmp start_loop

loop_exit:                      # Largest value is already in %ebx,
                                # which is the status code argument for
                                # exit syscall.
movl $1, %eax                   # Store exit syscall.
int $0x80                       # Interrupt for syscall.

