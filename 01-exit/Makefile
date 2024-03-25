all:
	mkdir -p build
	as -o build/exit.o exit.s
	ld -o build/exit build/exit.o

test:
	./build/exit; echo $$?

