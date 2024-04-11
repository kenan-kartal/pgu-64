# PURPOSE:      Count the characters until a null byte is reached.
#
# INPUT:        %rdi - The address of the character string
#
# OUTPUT:       Returns the count in %rax
#
# PROCESS:
#       Registers used:
#               %rcx - character count
#               %al - current character
#               %rdx - current character address
#

.section .text

.type count_chars, @function
.global count_chars
count_chars:
        movq $0, %rcx           # Counter starts at zero
        movq %rdi, %rdx         # Starting address of data
        xor %eax, %eax          # Clear rax.

count_loop_begin:
        movb (%rdx), %al        # Grab the current character
        cmpb $0, %al            # Is it null?
        je count_loop_end       # If yes, we're done
        incq %rcx               # Otherwise, increment the counter
        incq %rdx               # and the pointer
        jmp count_loop_begin    # Go back to the beginning of the loop

count_loop_end:
        movq %rcx, %rax         # We're done. Move the count into %rax
        ret

