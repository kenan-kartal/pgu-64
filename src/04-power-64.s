# PURPOSE:      Illustrates how functions and stack work.
#               This program will compute the value of
#               2^3+5^2
#
# Everyhing in this program is stored in register,
# so the data section has nothing.
.section .data

.section .text

.global _start
_start:
        movq $2, %rdi   # set the first argument
        movq $3, %rsi   # set the second argument
        call power      # call the function
        pushq %rax      # save the first answer before
                        # calling the next function

        movq $5, %rdi   # set the first argument
        movq $2, %rsi   # set the second argument
        call power      # call the function

        popq %rdi       # second answer is already in %rax
                        # first answer was pushed on the stack
                        # pop it into %rdi
        
        addq %rax, %rdi # add them together
                        # result is in %rdi
        movl $60, %eax  # exit
        syscall

# PURPOSE:      Computes the value of a number
#               raised to a power.
#
# INPUT:        rdi: base
#               rsi: power
#
# OUTPUT:       Result as a return value
#
# NOTES:        Power must be 1 or greater
#
# VARIABLES:
#               -8(%rbp) - holds the current result
#               %rax - temp storage
#
.type power, @function
power:
        pushq %rbp              # save old base pointer
        movq %rsp, %rbp         # make stack pointer the base pointer
        subq $8, %rsp           # get room for local storage

        movq %rdi, -8(%rbp)     # store current result

power_loop_start:
        cmpq $1, %rsi           # if power is 1, we are done
        je end_power
        movq -8(%rbp), %rax     # fetch the current result
        imulq %rdi, %rax        # multiply the current result
                                # by the base number
        movq %rax, -8(%rbp)     # store the current result

        decq %rsi               # decrement the power
        jmp power_loop_start

end_power:
        movq -8(%rbp), %rax     # fetch return value into %rax
        movq %rbp, %rsp         # restore the stack pointer
        popq %rbp               # restore the base pointer
        ret

