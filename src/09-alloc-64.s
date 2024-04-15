# PURPOSE:      Program to manage memory usage - allocated
#               and deallocates memory as requested
#
# NOTES:        Each block contains
#               - available marker
#               - size of memory
#               - actual memory <- returned pointer
#

.include "linux-64.s"

.section .data

        ### GLOBAL VARIABLES ###
        heap_begin:     .quad 0
        current_break:  .quad 0

        ### STRUCTURE INFORMATION ###
        .equ HEADER_SIZE, 16
        .equ HDR_AVAIL_OFFSET, 0
        .equ HDR_SIZE_OFFSET, 8

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
        pushq %rbp
        movq %rsp, %rbp

        # Find out where the break is
        movq $SYS_BRK, %rax
        movq $0, %rdi           # with %rdi==0,
                                # linux returns current break location
        syscall
        incq %rax               # point to memory after current break
        movq %rax, current_break
        movq %rax, heap_begin

        movq %rbp, %rsp
        popq %rbp
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
#               %rdi - size of requested memory
#               %rax - current region location
#               %rsi - current break position
#               %rdx - size of current region
#
.global allocate
.type allocate, @function
allocate:
        .equ ST_MEM_SIZE, 8

        pushq %rbp
        movq %rsp, %rbp

        # %rdi holds the size requested
        movq heap_begin, %rax
        movq current_break, %rsi

alloc_loop_begin:                       # iterate through each memory region
        cmpq %rsi, %rax                 # are we at break?
        je move_break                   # if so, get new region

        movq HDR_SIZE_OFFSET(%rax), %rdx                # grab size of region
        cmpq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)       # is the region in use?
        je next_location                                # if so, try next

        cmpq %rdx, %rdi                 # is there enough space?
        jle allocate_here               # good, allocate here

next_location:
        addq $HEADER_SIZE, %rax         # Move to next region, add header
        addq %rdx, %rax                 # and memory sizes
        jmp alloc_loop_begin            # try again

allocate_here:                          # Use an available region
        movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
        addq $HEADER_SIZE, %rax         # Point %rax to usable memory

        movq %rbp, %rsp
        pop %rbp
        ret

move_break:                             # We are at break, get a new region
        # rsi holds current break
        # rdi holds requested memory
        # increase rsi to new break location we will request
        addq $HEADER_SIZE, %rsi
        addq %rdi, %rsi

        # save variables
        pushq %rax
        pushq %rdi
        pushq %rsi

        # ask Linux for new break location
        movq $SYS_BRK, %rax
        movq %rsi, %rdi
        syscall
        cmpq $0, %rax                   # Error?
        je error                        # Error.

        # restore variables
        popq %rsi
        popq %rdi
        popq %rax

        # We have the new region starting here,
        # prepare it for use.
        movq $UNAVAILABLE, HDR_AVAIL_OFFSET(%rax)
        movq %rdi, HDR_SIZE_OFFSET(%rax)
        addq $HEADER_SIZE, %rax         # Point to usable memory

        movq %rsi, current_break        # save new break

        movq %rbp, %rsp
        popq %rbp
        ret

error:
        movq $0, %rax                   # return 0 on error
        movq %rbp, %rsp
        popq %rbp
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
        .equ ST_MEMORY_SEG, 8

        movq ST_MEMORY_SEG(%rsp), %rax  # Get the address
        subq $HEADER_SIZE, %rax         # Mark it free
        movq $AVAILABLE, HDR_AVAIL_OFFSET(%rax)

        ret
### end of function ###

