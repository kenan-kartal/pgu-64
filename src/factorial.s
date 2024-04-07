# PURPOSE:      Computes the factorial and shows how to
#               write recursive functions.
.text
.global _start

_start:
pushq $5                # Call factorial with an argument.
call factorial
addq $8, %rsp           # Discard the argument pushed for
                        # calling the function.
movq %rax, %rbx         # Return the result back to shell.
movq $1, %rax
int $0x80

.type factorial STT_FUNC
factorial:
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %rax
cmpq $1, %rax
je end_factorial
decq %rax
pushq %rax              # Recurse.
call factorial
movq 16(%rbp), %rbx     # Multiply returned value (%rax)
imulq %rbx, %rax        # and argument (%rbx).

end_factorial:
movq %rbp, %rsp
popq %rbp
ret

