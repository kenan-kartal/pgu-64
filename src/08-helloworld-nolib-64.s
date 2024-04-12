# PURPOSE:      This program writes the messahe "hello world"
#               and exits
#

.include "linux-64.s"

.section .data

helloworld:
        .ascii "hello world\n"
        .equ helloworld_len, .-helloworld

.section .text

.global _start
_start:
        movq $STDOUT, %rdi
        movq $helloworld, %rsi
        movq $helloworld_len, %rdx
        movq $SYS_WRITE, %rax
        syscall

        movq $0, %rdi
        movq $SYS_EXIT, %rax
        syscall

