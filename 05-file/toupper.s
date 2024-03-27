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

.data
### CONSTANTS ###
# Syscall values
.equ SYS_EXIT, 60
.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_OPEN, 2
.equ SYS_CLOSE, 3

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

# Other
.equ EOF, 0             # Return value of read
                        # (when successful) indicating
                        # we've hit the end of the file.
.equ PERMS, 0644        # Default file permissions.

.bss
# Buffer -      This is where the data is loaded into
#               from the data file and written from
#               int the output file.
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.text
# Stack Positions
.equ ST_SIZE_RESERVE, 16
.equ ST_FD_IN, -8
.equ ST_FD_OUT, -16
.equ ST_ARGC, 0         # Argument count.
.equ ST_ARGV_0, 8       # Name of program.
.equ ST_ARGV_1, 16      # Input file name.
.equ ST_ARGV_2, 24      # Output file name.

.global _start
_start:
### INITIALIZE ###
movq %rsp, %rbp                 # Save stack pointer.
subq $ST_SIZE_RESERVE, %rsp     # Allocate space for file descriptors.

open_files:
open_fd_in:
### OPEN INPUT FILE ###
movq $SYS_OPEN, %rax            # open syscall value.
movq ST_ARGV_1(%rbp), %rbx      # Input filename pointer.
movq $O_RDONLY, %rcx            # Read-only flag.
movq $PERMS, %rdx               # Permissions (Not important for reads).
syscall                         # Linux system call.

store_fd_in:
movq %rax, ST_FD_IN(%rbp)       # Store the input file descriptor.

open_fd_out:
### OPEN OUTPUT FILE ###
movq $SYS_OPEN, %rax            # open syscall value.
movq ST_ARGV_2(%rbp), %rbx      # Output filename pointer.
movq $O_CREAT_WRONLY_TRUNC, %rcx        # Create_write-only_truncate flag.
movq $PERMS, %rdx               # Permissions for output file it's created anew.
syscall                         # Linux system call.

store_fd_out:
movq %rax, ST_FD_OUT(%rbp)      # Store the output file descriptor.

read_loop_begin:
### BEGIN MAIN LOOP ###
### READ IN A BLOCK FROM THE INPUT FILE ###
movq $SYS_READ, %rax            # read syscall value.
movq ST_FD_IN(%rbp), %rbx       # Input file descriptor.
movq $BUFFER_DATA, %rcx         # Buffer location to read into.
movq $BUFFER_SIZE, %rdx         # Size of the buffer.
syscall                         # Linux system call.

### EXIT IF WE'VE REACHED THE END ###
cmpq $EOF, %rax                 # Check for end of file marker.
jle end_loop                    # If EOF or error, go to end.

continue_read_loop:
### CONVERT THE BLOCK TO UPPER CASE ###
pushq $BUFFER_DATA              # Location of buffer.
pushq %rax                      # Effective size of buffer.
call convert_to_upper
popq %rax                       # Get the size back.
addq $8, %rsp                   # Restore %rsp.

### WRITE THE BLOCK OUT TO THE OUTPUT FILE ###
movq %rax, %rdx                 # Effective size of the buffer.
movq $SYS_WRITE, %rax           # write syscall value.
movq ST_FD_OUT(%rbp), %rbx      # Output file descriptor.
movq $BUFFER_DATA, %rcx         # Buffer location to read from.
syscall                   # Linux system call.

### CONTINUE THE LOOP ###
jmp read_loop_begin

end_loop:
### CLOSE THE FILES ###
# NOTE: We don't need to do error checking
#       on these, because error conditions
#       don't signify anything special here.
movq $SYS_CLOSE, %rax           # close syscall value.
movq ST_FD_OUT(%rbp), %rbx      # Output file descriptor.
syscall                   # Linux system call.

movq $SYS_CLOSE, %rax           # close syscall value.
movq ST_FD_IN(%rbp), %rbx       # Input file descriptor.
syscall                   # Linux system call.

### EXIT ###
movq $SYS_EXIT, %rax            # exit syscall value.
movq $0, %rbx                   # Return value.
syscall                         # Linux system call.

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
#               %rax - beginning of buffer
#               %rbx - length of buffer
#               %rdi - current buffer offset
#               %cl - current byte being examined
#

### CONSTANTS ###
.equ LOWERCASE_A, 'a
.equ LOWERCASE_Z, 'z
.equ UPPER_CONVERSION, 'A - 'a

### STACK ###
.equ ST_BUFFER_LEN, 16          # Length of buffer.
.equ ST_BUFFER, 24              # Buffer location.

convert_to_upper:
pushq %rbp
movq %rsp, %rbp

### SET UP VARIABLES ###
movq ST_BUFFER(%rbp), %rax
movq ST_BUFFER_LEN(%rbp), %rbx
movq $0, %rdi
cmpq $0, %rbx                   # If len is 0, end.
je end_convert_loop

convert_loop:
movb (%rax,%rdi,1), %cl         # Get current byte.
# Skip if not lowercase
cmpb $LOWERCASE_A, %cl
jl next_byte
cmpb $LOWERCASE_Z, %cl
jg next_byte

addb $UPPER_CONVERSION, %cl     # Convert to upper-case.
movb %cl, (%rax,%rdi,1)         # Store the result back.

next_byte:
incq %rdi
cmpq %rdi, %rbx                 # Check if we've reached the end.
jne convert_loop

end_convert_loop:
movq %rbp, %rsp
popq %rbp
ret

