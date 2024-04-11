.include "linux-64.s"
.include "record-def.s"

.section .data

file_name:
        .asciz "build/recs-64.dat"

.section .bss

        .lcomm record_buffer, RECORD_SIZE

.section .text

# Main program
.global _start
_start:
        # These are the locations on the stack where
        # we will store the input and output descriptors
        .equ ST_INPUT_DESCRIPTOR, -8
        .equ ST_OUTPUT_DESCRIPTOR, -16

        movq %rsp, %rbp
        subq $16, %rsp

        # Open the file
        movq $SYS_OPEN, %rax
        movq $file_name, %rdi
        movq $0, %rsi                   # O_RDONLY
        movq $0644, %rdx
        syscall

        # Save file descriptor
        movq %rax, ST_INPUT_DESCRIPTOR(%rbp)

        # Even though it's a constant, we are
        # saving the output file descriptor in
        # a local variable so that if we later
        # decide that it isn't always going to
        # be STDOUT, we can change it easily.
        movq $STDOUT, ST_OUTPUT_DESCRIPTOR(%rbp)

record_read_loop:
        movq ST_INPUT_DESCRIPTOR(%rbp), %rdi
        movq $record_buffer, %rsi
        call read_record

        # Returns the number of bytes read,
        # If it isn't the same number we
        # requested, then it's either an EOF
        # or an error, so we're quitting
        cmpq $RECORD_SIZE, %rax
        jne finished_reading

        # Otherwise, print out the first name
        # but first, we must know its size
        movq $(RECORD_FIRSTNAME+record_buffer), %rdi
        call count_chars
        movq %rax, %rdx
        movq $SYS_WRITE, %rax
        movq ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
        movq $(RECORD_FIRSTNAME+record_buffer), %rsi
        syscall

        movq ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
        call write_newline

        jmp record_read_loop

finished_reading:
        movq $SYS_EXIT, %rax
        movq $0, %rdi
        syscall

