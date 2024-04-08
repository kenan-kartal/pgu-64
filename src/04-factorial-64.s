# PURPOSE:      Computes the factorial and shows how to
#               write recursive functions.
#

.section .text

.global _start
_start:
        movq $4, %rdi           # call factorial with an argument
        call factorial
        movq %rax, %rdi         # return the result back to shell
        movq $60, %rax
        syscall

.type factorial, @function
factorial:
        pushq %rbp
        movq %rsp, %rbp
        subq $8, %rsp
        movq %rdi, %rax
        cmpq $1, %rax           # if 1, return
        je end_factorial
        movq %rdi, -8(%rbp)     # other wise store the argument
        decq %rdi               # decrement
        call factorial          # and recurse
        movq -8(%rbp), %rdi     # multiply returned value (%rax)
        imulq %rdi, %rax        # and argument (%rdi)
        
end_factorial:
        movq %rbp, %rsp
        popq %rbp
        ret

