all:
	mkdir -p build
	as -o build/func.o func.s
	as -o build/power.o power.s
	ld -o build/func build/*.o

test:
	./build/func; echo $$?

