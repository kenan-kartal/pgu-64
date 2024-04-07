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
#               %ebx holds the return status.
#

.section .data

.section .text
.global _start
_start:
movl $1, %eax           # system call number
movl $0, %ebx           # status number
int $0x80               # interrupt for syscall

