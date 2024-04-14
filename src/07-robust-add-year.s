.include "linux-32.s"
.include "record-def.s"

.section .data

input_file_name:
        .asciz "build/recs.dat"

output_file_name:
        .asciz "build/recs2.dat"

.section .bss

        .lcomm record_buffer, RECORD_SIZE

.section .text
.global _start
_start:
        # Stack offsets of local variables
        .equ ST_INPUT_DESCRIPTOR, -4
        .equ ST_OUTPUT_DESCRIPTOR, -8

        movl %esp, %ebp
        subl $8, %esp

        # Open file for reading
        movl $SYS_OPEN, %eax
        movl $input_file_name, %ebx
        movl $0, %ecx
        movl $0644, %edx
        int $LINUX_SYSCALL

        movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

        # This will test and see if %eax is negative.
        # If it is not negative, it will jump to
        # continue_processing. Otherwise it will
        # handle the error condition that the
        # negative number represents.
        cmpl $0, %eax
        jge continue_processing         # NOTE: the instruction should not be jl
                                        # Jumps if eax is not less than 0

# Send the error
.section .data

no_open_file_code:
        .asciz "0001: "
no_open_file_msg:
        .asciz "Can't open input file"

.section .text

        pushl $no_open_file_msg
        pushl $no_open_file_code
        call error_exit

continue_processing:

        # Open file for writing

        movl $SYS_OPEN, %eax
        movl $output_file_name, %ebx
        movl $0101, %ecx
        movl $0644, %edx
        int $LINUX_SYSCALL

        movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

loop_begin:
        pushl ST_INPUT_DESCRIPTOR(%ebp)
        pushl $record_buffer
        call read_record
        addl $8, %esp

        # Returns the number of bytes read.
        # If it isn't the same number we
        # requested, then it's either an EOF,
        # or an error, so we're quitting
        cmpl $RECORD_SIZE, %eax
        jne loop_end

        #Increment the age
        incl record_buffer + RECORD_AGE

        # Write the record out
        pushl ST_OUTPUT_DESCRIPTOR(%ebp)
        pushl $record_buffer
        call write_record
        addl $8, %esp

        jmp loop_begin

loop_end:
        movl $SYS_EXIT, %eax
        movl $0, %ebx
        int $LINUX_SYSCALL

