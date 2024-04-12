# PURPOSE:      This program is to demonstrate how to call printf
#

.section .data

# Format string
firststring:
        .asciz "Hello! %s is a %s who loves the number %d\n"
name:
        .asciz "Jonathan"
personstring:
        .asciz "person"
numberloved:
        .long 3

.section .text

.global _start
_start:
        movq $firststring, %rdi
        movq $name, %rsi
        movq $personstring, %rdx
        movq numberloved, %rcx
        call printf

        movq $0, %rdi
        call exit

