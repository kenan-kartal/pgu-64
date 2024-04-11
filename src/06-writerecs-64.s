.include "linux-64.s"
.include "record-def.s"

.section .data

# Constant data of the records we want to write
# Each text data item is padded to the proper
# length with null (i.e 0) bytes.

record1:
0:      .asciz "Fredrick"
        .ds.b 40-(.-0b)         # Pad to 40 bytes

1:      .asciz "Bartlett"
        .ds.b 40-(.-1b)         # Pad to 40 bytes

2:      .asciz "4242 S Prairie\nTulsa, OK 55555"
        .ds.b 240-(.-2b)        # Pad to 240 bytes

        .int 45

record2:
0:      .asciz "Marilyn"
        .ds.b 40-(.-0b)

1:      .asciz "Taylor"
        .ds.b 40-(.-1b)

2:      .asciz "2224 S Johannan St\nChicago, IL 12345"
        .ds.b 240-(.-2b)

        .int 29

record3:
0:      .asciz "Derrick"
        .ds.b 40-(.-0b)

1:      .asciz "McIntire"
        .ds.b 40-(.-1b)

2:      .asciz "500 W Oakland\nSan Diego, CA 54321"
        .ds.b 240-(.-2b)

        .int 36

# This is the name of the file we will write to
file_name:
        .asciz "build/recs-64.dat"

        .equ ST_FILE_DESCRIPTOR, -8

.section .text

.global _start
_start:
        movq %rsp, %rbp
        subq $8, %rsp

        # Open the file
        movq $SYS_OPEN, %rax
        movq $file_name, %rdi
        movq $0101, %rsi                # O_CREAT | O_WRONLY
        movq $0644, %rdx
        syscall

        # Store the file descriptor away
        movq %rax, ST_FILE_DESCRIPTOR(%rbp)

        # Write the first record
        movq ST_FILE_DESCRIPTOR(%rbp), %rdi
        movq $record1, %rsi
        call write_record

        # Write the second record
        movq ST_FILE_DESCRIPTOR(%rbp), %rdi
        movq $record2, %rsi
        call write_record

        # Write the third record
        movq ST_FILE_DESCRIPTOR(%rbp), %rdi
        movq $record3, %rsi
        call write_record

        # Close the file descriptor
        movq $SYS_CLOSE, %rax
        movq ST_FILE_DESCRIPTOR(%rbp), %rdi
        syscall

        # Exit the program
        movq $SYS_EXIT, %rax
        movq $0, %rdi
        syscall

