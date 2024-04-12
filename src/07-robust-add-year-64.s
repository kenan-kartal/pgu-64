.include "linux-64.s"
.include "record-def.s"

.section .data

input_file_name:
        .asciz "build/recs-64.dat"

output_file_name:
        .asciz "build/recs2-64.dat"

.section .bss

        .lcomm record_buffer, RECORD_SIZE

.section .text
.global _start
_start:
        # Stack offsets of local variables
        .equ ST_INPUT_DESCRIPTOR, -8
        .equ ST_OUTPUT_DESCRIPTOR, -16

        movq %rsp, %rbp
        subq $16, %rsp

        # Open file for reading
        movq $SYS_OPEN, %rax
        movq $input_file_name, %rdi
        movq $0, %rsi
        movq $0644, %rdx
        syscall

        movq %rax, ST_INPUT_DESCRIPTOR(%rbp)

        cmpq $0, %rax                   # if %rax >= 0
        jge continue_processing         # resume operation

# Send the error
.section .data

no_open_file_code:
        .asciz "0001: "
no_open_file_msg:
        .asciz "Can't open input file"

.section .text

        movq $no_open_file_code, %rdi
        movq $no_open_file_msg, %rsi
        call error_exit

continue_processing:

        # Open file for writing

        movq $SYS_OPEN, %rax
        movq $output_file_name, %rdi
        movq $0101, %rsi
        movq $0644, %rdx
        syscall

        movq %rax, ST_OUTPUT_DESCRIPTOR(%rbp)

loop_begin:
        movq ST_INPUT_DESCRIPTOR(%rbp), %rdi
        movq $record_buffer, %rsi
        call read_record

        # Returns the number of bytes read.
        # If it isn't the same number we
        # requested, then it's either an EOF,
        # or an error, so we're quitting
        cmpq $RECORD_SIZE, %rax
        jne loop_end

        #Increment the age
        incq record_buffer + RECORD_AGE

        # Write the record out
        movq ST_OUTPUT_DESCRIPTOR(%rbp), %rdi
        movq $record_buffer, %rsi
        call write_record

        jmp loop_begin

loop_end:
        movq $SYS_EXIT, %rax
        movq $0, %rdi
        syscall

