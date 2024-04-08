# PURPOSE:      Illustrates how functions work.
#               This program will compute the value of
#               2^3+5^2
#
# Everyhing in this program is stored in register,
# so the data section has nothing.
.section .data

.section .text

.global _start
_start:
        pushl $3        # push second argument
        pushl $2        # push first argument
        call power      # call the function
        addl $8, %esp   # move the stack pointer back
        pushl %eax      # save the first answer before
                        # calling the next function

        pushl $2        # push second argument
        pushl $5        # push first argument
        call power      # call the function
        addl $8, %esp   # move the stack pointer back

        popl %ebx       # second answer is already in %eax
                        # first answer was pushed on the stack
                        # pop it into %ebx

        addl %eax, %ebx # add them together
                        # result is in %ebx
        movl $1, %eax   # exit
        int $0x80

# PURPOSE:      Computes the value of a number
#               raised to a power.
#
# INPUT:        First arg: base
#               Second arg: power
#
# OUTPUT:       Result as a return value
#
# NOTES:        Power must be 1 or greater
#
# VARIABLES:
#               %ebx - holds the base
#               %ecx - holds the power
#               -4(%ebp) - holds the current result
#               %eax - temp storage
#
.type power, @function
power:
        pushl %ebp              # save old base pointer
        movl %esp, %ebp         # make stack pointer the base pointer
        subl $4, %esp           # get room for local storage

        movl 8(%ebp), %ebx      # fetch param 1 (base)
        movl 12(%ebp), %ecx     # fetch param 2 (power)

        movl %ebx, -4(%ebp)     # store current result

power_loop_start:
        cmpl $1, %ecx           # if power is 1, we are done
        je end_power
        movl -4(%ebp), %eax     # fetch the current result
        imull %ebx, %eax        # multiply the current result
                                # by the base number
        movl %eax, -4(%ebp)     # store the current result

        decl %ecx               # decrement the power
        jmp power_loop_start

end_power:
        movl -4(%ebp), %eax     # fetch return value into %eax
        movl %ebp, %esp         # restore the stack pointer
        popl %ebp               # restore the base pointer
        ret

