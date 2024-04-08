# PURPOSE:      Simple program that exits and returns a
#               status code back to the Linux kernel.
#

# INPUT:        None.
#

# OUTPUT:       Retuns a status code. Can be viewed by
#
#               echo $?
#
#               after running the program.
#

# VARIABLES:
#               %eax holds the system call number.
#               %edi holds the return status.
#

.section .data

.section .text
.global _start
_start:
movl $60, %eax          # system call number
movl $0, %edi           # status number
syscall                 # interrupt for syscall

