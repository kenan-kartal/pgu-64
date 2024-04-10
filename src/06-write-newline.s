.include "linux-32.s"

.section .data

newline:
        .byte '\n

.section .text

.type write_newline, @function
.global write_newline
write_newline:
        .equ ST_FILEDES, 8

        pushl %ebp
        movl %esp, %ebp

        movl $SYS_WRITE, %eax
        movl ST_FILEDES(%ebp), %ebx
        movl $newline, %ecx
        movl $1, %edx
        int $LINUX_SYSCALL

        movl %ebp, %esp
        popl %ebp
        ret

