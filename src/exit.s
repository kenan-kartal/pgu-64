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
#               %rax holds the system call number.
#               %rbx holds the return status.
#

.section .data

.section .text
.global _start
_start:
movq $1, %rax   # Store exit syscall.
movq $0, %rbx   # Return status.
int $0x80       # Interrupt for syscall.

