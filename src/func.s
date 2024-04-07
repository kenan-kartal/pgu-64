# PURPOSE:      Illustrates how functions work.
#
# Everyhing in this program is stored in register,
# so the data section has nothing.
.data

.text
.global _start
_start:
pushq $3        # Push second argument.
pushq $2        # Push first argument.
call power
addq $16, %rsp  # Move the stack pointer back.
pushq %rax      # Save the first answer before
                # calling the next function.
pushq $2
pushq $5
call power
addq $16, %rsp
popq %rbx       # Second answer is already in %rax.
                # First answer was pushed on the stack.
                # Pop it into %rbx.
addq %rax, %rbx # Add them together.
                # Result is in %rbx
movq $1, %rax   # Exit.
int $0x80

