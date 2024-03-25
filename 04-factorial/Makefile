all:
	mkdir build
	as -o build/factorial.o factorial.s
	ld -o build/factorial build/factorial.o

test:
	./build/factorial; echo $$?

