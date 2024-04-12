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
        # Reversed order that they are listed in the
        # function's prototype
        pushl numberloved       # %d
        pushl $personstring     # second %s
        pushl $name             # first %s
        pushl $firststring      # format string in the prototype
        call printf

        pushl $0
        call exit

