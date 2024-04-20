.include "linux-32.s"

.section .data

tmp_buffer:             # Buffer for max 10 chars + terminating null
        .ds.b 11

.section .text

.global _start
_start:
        movl %esp, %ebp

        # Convert number to string
        pushl $tmp_buffer
        pushl $824
        call integer2string
        addl $8, %esp

        # Get character count
        pushl $tmp_buffer
        call count_chars
        addl $4, %esp

        # Write number
        movl %eax, %edx
        movl $SYS_WRITE, %eax
        movl $STDOUT, %ebx
        movl $tmp_buffer, %ecx
        int $LINUX_SYSCALL

        # Write newline
        pushl $STDOUT
        call write_newline

        # Exit
        movl $SYS_EXIT, %eax
        movl $0, %ebx
        int $LINUX_SYSCALL

