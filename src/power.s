# PURPOSE:      Computes the value of a number
#               raised to a power.
#
# INPUT:        First arg: base.
#               Second arg: power.
#
# OUTPUT:       Result as a return value.
#
# NOTES:        Power bust be 1 or greater.
#
# VARIABLES:
#               %rbx - holds the base.
#               %rcx - holds the power.
#               -8(%rbp) - holds the current result.
#               %rax - temp storage.
.text
.global power
.type power STT_FUNC
power:
pushq %rbp              # Save old base pointer.
movq %rsp, %rbp         # Make stack pointer the base pointer.
subq $8, %rsp           # Get room for local storage.
movq 16(%rbp), %rbx     # Fetch param 1 (base).
movq 24(%rbp), %rcx     # Fetch param 2 (power).
movq %rbx, -8(%rbp)     # Store current result.

power_loop_start:
cmpq $1, %rcx           # If power is 1, we are done.
je end_power
movq -8(%rbp), %rax     # Fetch the current result.
imulq %rbx, %rax        # Multiply the current result
                        # by the base number.
movq %rax, -8(%rbp)     # Store the current result.
decq %rcx               # Decrement the power.
jmp power_loop_start

end_power:
movq -8(%rbp), %rax     # Fetch return value into %rax.
movq %rbp, %rsp         # Restore the stack pointer.
popq %rbp               # Restore the base pointer.
ret

