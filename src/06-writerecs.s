.include "linux-32.s"
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
        .asciz "build/recs.dat"

        .equ ST_FILE_DESCRIPTOR, -4

.section .text

.global _start
_start:
        movl %esp, %ebp
        subl $4, %esp

        # Open the file
        movl $SYS_OPEN, %eax
        movl $file_name, %ebx
        movl $0101, %ecx                # O_CREAT | O_WRONLY
        movl $0644, %edx
        int $LINUX_SYSCALL

        # Store the file descriptor away
        movl %eax, ST_FILE_DESCRIPTOR(%ebp)

        # Write the first record
        pushl ST_FILE_DESCRIPTOR(%ebp)
        pushl $record1
        call write_record
        addl $8, %esp

        # Write the second record
        pushl ST_FILE_DESCRIPTOR(%ebp)
        pushl $record2
        call write_record
        addl $8, %esp

        # Write the third record
        pushl ST_FILE_DESCRIPTOR(%ebp)
        pushl $record3
        call write_record
        addl $8, %esp

        # Close the file descriptor
        movl $SYS_CLOSE, %eax
        movl ST_FILE_DESCRIPTOR(%ebp), %ebx
        int $LINUX_SYSCALL

        # Exit the program
        movl $SYS_EXIT, %eax
        movl $0, %ebx
        int $LINUX_SYSCALL

