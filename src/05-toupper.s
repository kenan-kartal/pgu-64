# PURPOSE:      This program converts an input file
#               to an output file with all letters
#               converted to uppercase.
#
# PROCESSING:   1- Open the input file.
#               2- Open the output file.
#               3- While not EOF:
#                       a- Read part of file into buffer.
#                       b- Go through each byte of memory.
#                          If the byte is a lower-case letter,
#                          convert it to uppercase.
#                       c- Write the memory buffer to output file.
#

.section .data

### CONSTANTS ###

# syscall values
.equ SYS_EXIT, 1
.equ SYS_READ, 3
.equ SYS_WRITE, 4
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6

# Options for open (Look at
# /usr/include/asm[-generic]/fcntl.h for
# reference. They can be combined by adding
# or OR'ing.)
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 01101

# Standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# system call interrupt
.equ LINUX_SYSCALL, 0x80
.equ EOF, 0             # Return value of read
                        # (when successful) indicating
                        # we've hit the end of the file.
.equ PERMS, 0644        # Default file permissions.

.section .bss
# Buffer -      This is where the data is loaded into
#               from the data file and written from
#               int the output file.
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# Stack Positions
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0         # Argument count.
.equ ST_ARGV_0, 4       # Name of program.
.equ ST_ARGV_1, 8       # Input file name.
.equ ST_ARGV_2, 12      # Output file name.

.global _start
_start:
        ### INITIALIZE ###
        movl %esp, %ebp                 # Save stack pointer.
        subl $ST_SIZE_RESERVE, %esp     # Allocate space for file descriptors.

open_files:
open_fd_in:
        ### OPEN INPUT FILE ###
        movl $SYS_OPEN, %eax            # open syscall value.
        movl ST_ARGV_1(%ebp), %ebx      # Input filename pointer.
        movl $O_RDONLY, %ecx            # Read-only flag.
        movl $PERMS, %edx               # Permissions (Not important for reads).
        int $LINUX_SYSCALL              # Linux system call.

store_fd_in:
        movl %eax, ST_FD_IN(%ebp)       # Store the input file descriptor.

open_fd_out:
        ### OPEN OUTPUT FILE ###
        movl $SYS_OPEN, %eax            # open syscall value.
        movl ST_ARGV_2(%ebp), %ebx      # Output filename pointer.
        movl $O_CREAT_WRONLY_TRUNC, %ecx        # Create_write-only_truncate flag.
        movl $PERMS, %edx               # Permissions for output file it's created anew.
        int $LINUX_SYSCALL              # Linux system call.

store_fd_out:
        movl %eax, ST_FD_OUT(%ebp)      # Store the output file descriptor.

### BEGIN MAIN LOOP ###
read_loop_begin:

        ### READ IN A BLOCK FROM THE INPUT FILE ###
        movl $SYS_READ, %eax            # read syscall value.
        movl ST_FD_IN(%ebp), %ebx       # Input file descriptor.
        movl $BUFFER_DATA, %ecx         # Buffer location to read into.
        movl $BUFFER_SIZE, %edx         # Size of the buffer.
        int $LINUX_SYSCALL              # Linux system call.

        ### EXIT IF WE'VE REACHED THE END ###
        cmpl $EOF, %eax                 # Check for end of file marker.
        jle end_loop                    # If EOF or error, go to end.

continue_read_loop:
        ### CONVERT THE BLOCK TO UPPER CASE ###
        pushl $BUFFER_DATA              # Location of buffer.
        pushl %eax                      # Effective size of buffer.
        call convert_to_upper
        popl %eax                       # Get the size back.
        addl $4, %esp                   # Restore %esp.

        ### WRITE THE BLOCK OUT TO THE OUTPUT FILE ###
        movl %eax, %edx                 # Effective size of the buffer.
        movl $SYS_WRITE, %eax           # write syscall value.
        movl ST_FD_OUT(%ebp), %ebx      # Output file descriptor.
        movl $BUFFER_DATA, %ecx         # Buffer location to read from.
        int $LINUX_SYSCALL              # Linux system call.

        ### CONTINUE THE LOOP ###
        jmp read_loop_begin

end_loop:
        ### CLOSE THE FILES ###
        # NOTE: We don't need to do error checking
        #       on these, because error conditions
        #       don't signify anything special here.
        movl $SYS_CLOSE, %eax           # close syscall value.
        movl ST_FD_OUT(%ebp), %ebx      # Output file descriptor.
        int $LINUX_SYSCALL              # Linux system call.
        
        movl $SYS_CLOSE, %eax           # close syscall value.
        movl ST_FD_IN(%ebp), %ebx       # Input file descriptor.
        int $LINUX_SYSCALL              # Linux system call.
        
        ### EXIT ###
        movl $SYS_EXIT, %eax            # exit syscall value.
        movl $0, %ebx                   # Return value.
        int $LINUX_SYSCALL              # Linux system call.

# PURPOSE:      This function actually does the
#               conversion to upper case for a block.
#
# INPUT:        The first parameter is the location of the block
#               of memory to convert.
#               The second parameter is the length of that buffer.
#
# OUTPUT:       This function overwrites the current buffer
#               with the upper-casified version.
#
# VARIABLES:
#               %eax - beginning of buffer
#               %ebx - length of buffer
#               %edi - current buffer offset
#               %cl - current byte being examined
#

### CONSTANTS ###
.equ LOWERCASE_A, 'a
.equ LOWERCASE_Z, 'z
.equ UPPER_CONVERSION, 'A - 'a

### STACK ###
.equ ST_BUFFER_LEN, 8           # Length of buffer.
.equ ST_BUFFER, 12              # Buffer location.

convert_to_upper:
        pushl %ebp
        movl %esp, %ebp

        ### SET UP VARIABLES ###
        movl ST_BUFFER(%ebp), %eax
        movl ST_BUFFER_LEN(%ebp), %ebx
        movl $0, %edi
        cmpl $0, %ebx                   # If len is 0, end.
        je end_convert_loop

convert_loop:
        movb (%eax,%edi,1), %cl         # Get current byte.
        # Skip if not lowercase
        cmpb $LOWERCASE_A, %cl
        jl next_byte
        cmpb $LOWERCASE_Z, %cl
        jg next_byte
        
        addb $UPPER_CONVERSION, %cl     # Convert to upper-case.
        movb %cl, (%eax,%edi,1)         # Store the result back.

next_byte:
        incl %edi
        cmpl %edi, %ebx                 # Check if we've reached the end.
        jne convert_loop

end_convert_loop:
        movl %ebp, %esp
        popl %ebp
        ret

