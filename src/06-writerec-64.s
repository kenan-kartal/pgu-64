.include "linux-64.s"
.include "record-def.s"

# PURPOSE:      This function writes a record to
#               the given file descriptor
#
# INPUT:        %rdi - file descriptor
#               %rsi - buffer
#
# OUTPUT:       This function produces a status code.
#

.section .text

.global write_record
.type write_record, @function
write_record:
        pushq %rsp
        movq %rsp, %rbp

        movq $SYS_WRITE, %rax
        # File descriptor is already in rdi
        # Buffer is already in rsi
        movq $RECORD_SIZE, %rdx
        syscall

        movq %rbp, %rsp
        ret

