.include "linux-64.s"
.include "record-def.s"

# PURPOSE:      This function reads a record from the file
#               descriptor
#
# INPUT:        %rdi - file descriptor
#               %rsi - buffer
#
# OUTPUT:       This function writes the data to the buffer
#               and returns a status code.
#

.section .text

.global read_record
.type read_record, @function
read_record:
        pushq %rbp
        movq %rsp, %rbp

        movq $SYS_READ, %rax
        # File descriptor is already in rdi
        # Buffer is already in rsi
        movq $RECORD_SIZE, %rdx
        syscall

        movq %rbp, %rsp
        popq %rbp
        ret

