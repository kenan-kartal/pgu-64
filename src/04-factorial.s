# PURPOSE:      Computes the factorial and shows how to
#               write recursive functions.
#

.section .text

.global _start
_start:
        pushl $4                # call factorial with an argument
        call factorial
        addl $4, %esp           # discard the argument pushed for
                                # calling the function.
        movl %eax, %ebx         # return the result back to shell
        movl $1, %eax
        int $0x80

.type factorial, @function
factorial:
        pushl %ebp
        movl %esp, %ebp
        movl 8(%ebp), %eax      # move the first argument to %eax
        cmpl $1, %eax           # if 1, return
        je end_factorial
        decl %eax               # otherwise decrement
        pushl %eax              # recurse
        call factorial
        movl 8(%ebp), %ebx      # multiply returned value (%eax)
        imull %ebx, %eax        # and argument (%ebx)
        
end_factorial:
        movl %ebp, %esp
        popl %ebp
        ret

