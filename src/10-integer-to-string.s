# PURPOSE:      Convert an integer number toa decimal string
#               for display
#
# INPUT:        A buffer large enough to hold the largest
#               possible number
#               An integer to convert
#
# OUTPUT:       The buffer will be overwritten with the
#               decimal string
#
# VARIABLES:
#               %ecx - count of characters processed
#               %eax - current value
#               %edi - base (10)
#

.section .text

.global integer2string
.type integer2string, @function
integer2string:
        .equ ST_VALUE, 8
        .equ ST_BUFFER, 12

        pushl %ebp
        movl %esp, %ebp

        movl $0, %ecx                   # Current character count
        movl ST_VALUE(%ebp), %eax       # Current value
        movl $10, %edi                  # Base

conversion_loop:
        # Division is performed on combined %edx:%eax
        movl $0, %edx                   # Clear %edx first
        divl %edi                       # Then divide

        # Quotient is in the right place, %eax.
        # Remainder is in %edx
        addl $'0, %edx                  # Convert digit to ascii
        pushl %edx                      # Push onto stack

        incl %ecx                       # Increment character count
        cmpl $0, %eax                   # Check if quotient is zero
        jne conversion_loop             # If not, iterate

end_conversion_loop:
        # Move onto copying
        movl ST_BUFFER(%ebp), %edx      # Get buffer

copy_reversing_loop:
        popl %eax                       # Pop next
        movb %al, (%edx)                # Store char
        decl %ecx                       # Decrement character count
        incl %edx                       # Increment buffer pointer
        cmpl $0, %ecx                   # Check if all characters are popped
        jne copy_reversing_loop         # If not, iterate

end_copy_reversing_loop:
        # Done copying
        movb $0, (%edx)                 # Add null byte at the end of string

        movl %ebp, %esp
        popl %ebp
        ret

