.include "linux-64.s"

.section .data

newline:
        .byte '\n

.section .text

# %rdi - file descriptor

.type write_newline, @function
.global write_newline
write_newline:
        movq $SYS_WRITE, %rax
        # File descriptor is already in %rdi
        movq $newline, %rsi
        movq $1, %rdx
        syscall
        ret

