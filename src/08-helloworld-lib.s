# PURPOSE:      This program writes the messahe "hello world"
#               and exits
#

.section .data

helloworld:
        .asciz "hello world\n"

.section .text

.global _start
_start:
        pushl $helloworld
        call printf

        pushl $0
        call exit

