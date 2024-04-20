.include "linux-64.s"

.section .data

tmp_buffer:             # Buffer for max 10 chars + terminating null
        .ds.b 11

.section .text

.global _start
_start:
        movq %rsp, %rbp

        # Convert number to string
        movq $824, %rdi
        movq $tmp_buffer, %rsi
        call integer2string

        # Get character count
        movq $tmp_buffer, %rdi
        call count_chars

        # Write number
        movq %rax, %rdx
        movq $SYS_WRITE, %rax
        movq $STDOUT, %rdi
        movq $tmp_buffer, %rsi
        syscall

        # Write newline
        movq $STDOUT, %rdi
        call write_newline

        # Exit
        movq $SYS_EXIT, %rax
        movq $0, %rdi
        syscall

