# PURPOSE:      This program writes the messahe "hello world"
#               and exits
#

.include "linux-32.s"

.section .data

helloworld:
        .ascii "hello world\n"
        .equ helloworld_len, .-helloworld

.section .text

.global _start
_start:
        movl $STDOUT, %ebx
        movl $helloworld, %ecx
        movl $helloworld_len, %edx
        movl $SYS_WRITE, %eax
        int $LINUX_SYSCALL

        movl $0, %ebx
        movl $SYS_EXIT, %eax
        int $LINUX_SYSCALL

