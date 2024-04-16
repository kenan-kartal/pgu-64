.include "linux-32.s"
.include "record-def.s"

.section .data

file_name:
        .asciz "build/recs.dat"

record_buffer_ptr:
        .long 0

.section .text

# Main program
.global _start
_start:
        # These are the locations on the stack where
        # we will store the input and output descriptors
        .equ ST_INPUT_DESCRIPTOR, -4
        .equ ST_OUTPUT_DESCRIPTOR, -8

        movl %esp, %ebp
        subl $8, %esp

        # Initialize our allocator
        call allocate_init

        # Get buffer memory for records
        pushl $RECORD_SIZE
        call allocate
        movl %eax, record_buffer_ptr
        addl $4, %esp

        # Open the file
        movl $SYS_OPEN, %eax
        movl $file_name, %ebx
        movl $0, %ecx                   # O_RDONLY
        movl $0644, %edx
        int $LINUX_SYSCALL

        # Save file descriptor
        movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

        # Even though it's a constant, we are
        # saving the output file descriptor in
        # a local variable so that if we later
        # decide that it isn't always going to
        # be STDOUT, we can change it easily.
        movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
        pushl ST_INPUT_DESCRIPTOR(%ebp)
        pushl record_buffer_ptr
        call read_record
        addl $8, %esp

        # Returns the number of bytes read,
        # If it isn't the same number we
        # requested, then it's either an EOF
        # or an error, so we're quitting
        cmpl $RECORD_SIZE, %eax
        jne finished_reading

        # Otherwise, print out the first name
        # but first, we must know its size
        movl record_buffer_ptr, %eax
        addl $RECORD_FIRSTNAME, %eax
        pushl %eax
        call count_chars
        addl $4, %esp
        movl %eax, %edx
        movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
        movl $SYS_WRITE, %eax
        movl record_buffer_ptr, %ecx
        addl $RECORD_FIRSTNAME, %ecx
        int $LINUX_SYSCALL

        pushl ST_OUTPUT_DESCRIPTOR(%ebp)
        call write_newline
        addl $4, %esp

        jmp record_read_loop

finished_reading:
        # Deallocate used buffer memory
        pushl record_buffer_ptr
        call deallocate

        movl $SYS_EXIT, %eax
        movl $0, %ebx
        int $LINUX_SYSCALL

