all:
	mkdir build
	as -o build/max.o max.s
	ld -o build/max build/max.o

test:
	./max; echo $$?

