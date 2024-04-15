# PURPOSE:      Program to manage memory usage - allocated
#               and deallocates memory as requested
#
# NOTES:        Each block contains
#               - available marker
#               - size of memory
#               - actual memory <- returned pointer
#

.include "linux-32.s"

.section .data

        ### GLOBAL VARIABLES ###
        heap_begin:     .long 0
        current_break:  .long 0

        ### STRUCTURE INFORMATION ###
        .equ HEADER_SIZE, 8
        .equ HDR_AVAIL_OFFSET, 0
        .equ HDR_SIZE_OFFSET, 4

        ### CONSTANTS ###
        .equ UNAVAILABLE, 0     # region is in use
        .equ AVAILABLE, 1       # region is free

.section .text

### allocate_init ###
# PURPOSE:      Initializes the allocator.
#               No input and no output.
#
.global allocate_init
.type allocate_init, @function
allocate_init:
        pushl %ebp
        movl %esp, %ebp

        # Find out where the break is
        movl $SYS_BRK, %eax
        movl $0, %ebx           # with %ebx==0,
                                # linux returns current break location
        int $LINUX_SYSCALL
        incl %eax               # point to memory after current break
        movl %eax, current_break
        movl %eax, heap_begin

        movl %ebp, %esp
        popl %ebp
        ret
### end of function ###


### allocate ###
# PURPOSE:      Grabs a section of memory. Checks if there are any
#               free blocks, if not, asks Linux for a new one.
#
# PARAMETERS:   1. size of memory
#
# RETURN VALUE:
#               Address of the allocated memory.
#               If no memory availabe, 0.
#
# VARIABLES:
#               %ecx - size of requested memory
#               %eax - current region location
#               %ebx - current break position
#               %edx - size of current region
#
.global allocate
.type allocate, @function
allocate:
        .equ ST_MEM_SIZE, 8

        pushl %ebp
        movl %esp, %ebp

        movl ST_MEM_SIZE(%ebp), %ecx    # %ecx holds the size requested
        movl heap_begin, %eax
        movl current_break, %ebx

alloc_loop_begin:                       # iterate through each memory region
        cmpl %ebx, %eax                 # are we at break?
        je move_break                   # if so, get new region

        movl HDR_SIZE_OFFSET(%eax), %edx                # grab size of region
        cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)       # is the region in use?
        je next_location                                # if so, try next

        cmpl %edx, %ecx                 # is there enough space?
        jle allocate_here               # good, allocate here

next_location:
        addl $HEADER_SIZE, %eax         # Move to next region, add header
        addl %edx, %eax                 # and memory sizes
        jmp alloc_loop_begin            # try again

allocate_here:                          # Use an available region
        movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        addl $HEADER_SIZE, %eax         # Point %eax to usable memory

        movl %ebp, %esp
        pop %ebp
        ret

move_break:                             # We are at break, get a new region
        # ebx holds current break
        # ecx holds requested memory
        # increase ebx to new break location we will request
        addl $HEADER_SIZE, %ebx
        addl %ecx, %ebx

        # save variables
        pushl %eax
        pushl %ecx
        pushl %ebx

        # ask Linux for new break location
        movl $SYS_BRK, %eax
        int $LINUX_SYSCALL
        cmpl $0, %eax                   # Error?
        je error                        # Error.

        # restore variables
        popl %ebx
        popl %ecx
        popl %eax

        # We have the new region starting here,
        # prepare it for use.
        movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
        movl %ecx, HDR_SIZE_OFFSET(%eax)
        addl $HEADER_SIZE, %eax         # Point to usable memory

        movl %ebx, current_break        # save new break

        movl %ebp, %esp
        popl %ebp
        ret

error:
        movl $0, %eax                   # return 0 on error
        movl %ebp, %esp
        popl %ebp
        ret
### end of function ###


### deallocate ###
# PURPOSE:      Gives the region back to allocator when it is not used anymore.
#
# PARAMETERS:   Address of used memory.
#
# RETURN VALUE: None.
#
# PROCESSING:
#               Marks the region available for the next allocate request.
#
.global deallocate
.type deallocate, @function
deallocate:
        .equ ST_MEMORY_SEG, 4

        movl ST_MEMORY_SEG(%esp), %eax  # Get the address
        subl $HEADER_SIZE, %eax         # Mark it free
        movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)

        ret
### end of function ###

