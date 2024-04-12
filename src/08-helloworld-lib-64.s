# PURPOSE:      This program writes the messahe "hello world"
#               and exits
#

.section .data

helloworld:
        .asciz "hello world\n"

.section .text

.global _start
_start:
        movq $helloworld, %rdi
        call printf

        movq $0, %rdi
        call exit

