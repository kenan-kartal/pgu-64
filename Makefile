all: exit

exit: build build/exit build/exit-64

build:
	mkdir build

build/exit: src/03-exit.s
	as --32 -o build/exit.o src/03-exit.s
	ld -m elf_i386 -o build/exit build/exit.o
build/exit-64: src/03-exit-64.s
	as -o build/exit-64.o src/03-exit-64.s
	ld -o build/exit-64 build/exit-64.o

test-exit:
	build/exit; echo $$?
test-exit-64:
	build/exit-64; echo $$?

