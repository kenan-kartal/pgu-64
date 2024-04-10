all: exit max power factorial toupper record

exit: build build/exit build/exit-64
max: build build/max build/max-64
power: build build/power build/power-64
factorial: build build/factorial build/factorial-64
toupper: build build/toupper build/toupper-64
record: build build/readrec.o build/writerec.o\
	build/count-chars.o build/write-newline.o\
	build/writerecs

build:
	mkdir build

build/exit: src/03-exit.s
	as --32 -o build/exit.o src/03-exit.s
	ld -m elf_i386 -o build/exit build/exit.o
build/exit-64: src/03-exit-64.s
	as -o build/exit-64.o src/03-exit-64.s
	ld -o build/exit-64 build/exit-64.o
build/max: src/03-max.s
	as --32 -o build/max.o src/03-max.s
	ld -m elf_i386 -o build/max build/max.o
build/max-64: src/03-max-64.s
	as -o build/max-64.o src/03-max-64.s
	ld -o build/max-64 build/max-64.o
build/power: src/04-power.s
	as --32 -o build/power.o src/04-power.s
	ld -m elf_i386 -o build/power build/power.o
build/power-64: src/04-power-64.s
	as -o build/power-64.o src/04-power-64.s
	ld -o build/power-64 build/power-64.o
build/factorial: src/04-factorial.s
	as --32 -o build/factorial.o src/04-factorial.s
	ld -m elf_i386 -o build/factorial build/factorial.o
build/factorial-64: src/04-factorial-64.s
	as -o build/factorial-64.o src/04-factorial-64.s
	ld -o build/factorial-64 build/factorial-64.o
build/toupper: src/05-toupper.s
	as --32 -o build/toupper.o src/05-toupper.s
	ld -m elf_i386 -o build/toupper build/toupper.o
build/toupper-64: src/05-toupper-64.s
	as -o build/toupper-64.o src/05-toupper-64.s
	ld -o build/toupper-64 build/toupper-64.o
build/readrec.o: src/06-readrec.s
	as --32 -I inc -o build/readrec.o src/06-readrec.s
build/writerec.o: src/06-writerec.s
	as --32 -I inc -o build/writerec.o src/06-writerec.s
build/writerecs: src/06-writerecs.s
	as --32 -I inc -o build/writerecs.o src/06-writerecs.s
	ld -m elf_i386 -o build/writerecs\
		build/writerec.o build/writerecs.o
build/count-chars.o: src/06-count-chars.s
	as --32 -I inc -o build/count-chars.o src/06-count-chars.s
build/write-newline.o: src/06-write-newline.s
	as --32 -I inc -o build/write-newline.o src/06-write-newline.s

test-exit:
	build/exit; echo $$?
test-exit-64:
	build/exit-64; echo $$?
test-max:
	build/max; echo $$?
test-max-64:
	build/max-64; echo $$?
test-power:
	build/power; echo $$?
test-power-64:
	build/power-64; echo $$?
test-factorial:
	build/factorial; echo $$?
test-factorial-64:
	build/factorial-64; echo $$?
test-toupper:
	-rm build/toupper_out
	echo "iT's aLl uppErCaSE!\n" > build/toupper_in
	build/toupper build/toupper_in build/toupper_out
	cat build/toupper_out
test-toupper-64:
	-rm build/toupper-64_out
	echo "iT's aLl uppErCaSE!\n" > build/toupper-64_in
	build/toupper-64 build/toupper-64_in build/toupper-64_out
	cat build/toupper-64_out
test-writerecs:
	-rm build/recs.dat
	build/writerecs
	cat build/recs.dat; echo ''

