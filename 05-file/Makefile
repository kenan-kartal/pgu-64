all:
	mkdir -p build
	as -g -o build/toupper.o toupper.s
	ld -g -o build/toupper build/toupper.o

test:
	echo "convert this to UPPer-CasE\n" >> ./build/in
	./build/toupper ./build/in ./build/out
	cat ./build/out

