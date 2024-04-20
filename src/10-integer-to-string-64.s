# PURPOSE:      Convert an integer number toa decimal string
#               for display
#
# INPUT:        %rdi - An integer to convert
#               %rsi - A buffer large enough to hold the largest
#                       possible number
#
# OUTPUT:       The buffer will be overwritten with the
#               decimal string
#
# VARIABLES:
#               %rcx - count of characters processed
#               %rax - current value
#               %r8 - base (10)
#

.section .text

.global integer2string
.type integer2string, @function
integer2string:
        pushq %rbp
        movq %rsp, %rbp

        movq $0, %rcx                   # Current character count
        movq %rdi, %rax                 # Current value
        movq $10, %r8                   # Base

conversion_loop:
        # Division is performed on combined %rdx:%rax
        movq $0, %rdx                   # Clear %rdx first
        divq %r8                        # Then divide

        # Quotient is in the right place, %rax.
        # Remainder is in %rdx
        addq $'0, %rdx                  # Convert digit to ascii
        pushq %rdx                      # Push onto stack

        incq %rcx                       # Increment character count
        cmpq $0, %rax                   # Check if quotient is zero
        jne conversion_loop             # If not, iterate

end_conversion_loop:
        # Move onto copying
        movq %rsi, %rdx                 # Get buffer

copy_reversing_loop:
        popq %rax                       # Pop next
        movb %al, (%rdx)                # Store char
        decq %rcx                       # Decrement character count
        incq %rdx                       # Increment buffer pointer
        cmpq $0, %rcx                   # Check if all characters are popped
        jne copy_reversing_loop         # If not, iterate

end_copy_reversing_loop:
        # Done copying
        movb $0, (%rdx)                 # Add null byte at the end of string

        movq %rbp, %rsp
        popq %rbp
        ret

