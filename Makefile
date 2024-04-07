all: exit

exit: build build/exit

build:
	mkdir build

build/exit: src/03-exit.s
	as --32 -o build/exit.o src/03-exit.s
	ld -m elf_i386 -o build/exit build/exit.o

test-exit:
	build/exit; echo $$?

