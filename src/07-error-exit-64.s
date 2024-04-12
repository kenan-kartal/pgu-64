.include "linux-64.s"

# %rdi - ERROR_CODE
# %rsi - ERROR_MSG

.section .text

.global error_exit
.type error_exit, @function
error_exit:
        .equ ST_ERROR_CODE, -8
        .equ ST_ERROR_MSG, -16

        pushq %rbp
        movq %rsp, %rbp
        pushq %rdi
        pushq %rsi

        # Write out error code
        movq ST_ERROR_CODE(%rbp), %rdi
        call count_chars
        movq %rax, %rdx
        movq $STDERR, %rdi
        movq ST_ERROR_CODE(%rbp), %rsi
        movq $SYS_WRITE, %rax
        syscall

        # Write out error message
        movq ST_ERROR_MSG(%rbp), %rdi
        call count_chars
        movq %rax, %rdx
        movq $STDERR, %rdi
        movq ST_ERROR_MSG(%rbp), %rsi
        movq $SYS_WRITE, %rax
        syscall

        movq $STDERR, %rdi
        call write_newline

        # Exit with status 1
        movq $SYS_EXIT, %rax
        movq $1, %rdi
        syscall

