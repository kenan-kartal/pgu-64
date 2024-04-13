LD_LIBRARY_PATH = ./build
export LD_LIBRARY_PATH

all: exit max power factorial toupper record robust-add-year\
	helloworld-nolib helloworld-lib printf-example shared-record

exit: build build/exit build/exit-64
max: build build/max build/max-64
power: build build/power build/power-64
factorial: build build/factorial build/factorial-64
toupper: build build/toupper build/toupper-64
record: build\
	build/writerecs build/readrecs build/add-year\
	build/writerecs-64 build/readrecs-64 build/add-year-64
robust-add-year: build build/robust-add-year build/robust-add-year-64
helloworld-nolib: build build/helloworld-nolib build/helloworld-nolib-64
helloworld-lib: build build/helloworld-lib build/helloworld-lib-64
printf-example: build build/printf-example build/printf-example-64
shared-record: build build/writerecs-shared build/writerecs-shared-64

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
build/count-chars.o: src/06-count-chars.s
	as --32 -I inc -o build/count-chars.o src/06-count-chars.s
build/write-newline.o: src/06-write-newline.s
	as --32 -I inc -o build/write-newline.o src/06-write-newline.s
build/writerecs: src/06-writerecs.s\
		build/writerec.o
	as --32 -I inc -o build/writerecs.o src/06-writerecs.s
	ld -m elf_i386 -o build/writerecs\
		build/writerec.o build/writerecs.o
build/readrecs: src/06-readrecs.s\
		build/readrec.o build/count-chars.o build/write-newline.o
	as --32 -I inc -o build/readrecs.o src/06-readrecs.s
	ld -m elf_i386 -o build/readrecs\
		build/readrec.o build/count-chars.o build/write-newline.o\
		build/readrecs.o
build/add-year: src/06-add-year.s\
		build/readrec.o build/writerec.o
	as --32 -I inc -o build/add-year.o src/06-add-year.s
	ld -m elf_i386 -o build/add-year\
		build/readrec.o build/writerec.o build/add-year.o
build/readrec-64.o: src/06-readrec-64.s
	as -I inc -o build/readrec-64.o src/06-readrec-64.s
build/writerec-64.o: src/06-writerec-64.s
	as -I inc -o build/writerec-64.o src/06-writerec-64.s
build/count-chars-64.o: src/06-count-chars-64.s
	as -I inc -o build/count-chars-64.o src/06-count-chars-64.s
build/write-newline-64.o: src/06-write-newline-64.s
	as -I inc -o build/write-newline-64.o src/06-write-newline-64.s
build/writerecs-64: src/06-writerecs-64.s\
		build/writerec-64.o
	as -I inc -o build/writerecs-64.o src/06-writerecs-64.s
	ld -o build/writerecs-64\
		build/writerecs-64.o build/writerec-64.o
build/readrecs-64: src/06-readrecs-64.s\
		build/readrec-64.o build/count-chars-64.o build/write-newline-64.o
	as -I inc -o build/readrecs-64.o src/06-readrecs-64.s
	ld -o build/readrecs-64\
		build/readrecs-64.o build/readrec-64.o build/count-chars-64.o\
		build/write-newline-64.o
build/add-year-64: src/06-add-year-64.s\
		build/readrec-64.o build/writerec-64.o
	as -I inc -o build/add-year-64.o src/06-add-year-64.s
	ld -o build/add-year-64\
		build/add-year-64.o build/readrec-64.o build/writerec-64.o
build/error-exit.o: src/07-error-exit.s
	as --32 -I inc -o build/error-exit.o src/07-error-exit.s
build/robust-add-year: src/07-robust-add-year.s\
		build/error-exit.o build/write-newline.o build/count-chars.o\
		build/readrec.o build/writerec.o
	as --32 -I inc -o build/robust-add-year.o src/07-robust-add-year.s
	ld -m elf_i386 -o build/robust-add-year\
		build/robust-add-year.o build/error-exit.o build/write-newline.o\
		build/count-chars.o build/readrec.o build/writerec.o
build/error-exit-64.o: src/07-error-exit-64.s
	as -I inc -o build/error-exit-64.o src/07-error-exit-64.s
build/robust-add-year-64: src/07-robust-add-year-64.s\
		build/error-exit-64.o build/write-newline-64.o build/count-chars-64.o\
		build/readrec-64.o build/writerec-64.o
	as -I inc -o build/robust-add-year-64.o src/07-robust-add-year-64.s
	ld -o build/robust-add-year-64\
		build/robust-add-year-64.o build/error-exit-64.o\
		build/write-newline-64.o build/count-chars-64.o\
		build/readrec-64.o build/writerec-64.o
build/helloworld-nolib: src/08-helloworld-nolib.s
	as --32 -I inc -o build/helloworld-nolib.o src/08-helloworld-nolib.s
	ld -m elf_i386 -o build/helloworld-nolib build/helloworld-nolib.o
build/helloworld-lib: src/08-helloworld-lib.s
	as --32 -I inc -o build/helloworld-lib.o src/08-helloworld-lib.s
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc\
		-o build/helloworld-lib build/helloworld-lib.o
build/helloworld-nolib-64: src/08-helloworld-nolib-64.s
	as -I inc -o build/helloworld-nolib-64.o src/08-helloworld-nolib-64.s
	ld -o build/helloworld-nolib-64 build/helloworld-nolib-64.o
build/helloworld-lib-64: src/08-helloworld-lib-64.s
	as -I inc -o build/helloworld-lib-64.o src/08-helloworld-lib-64.s
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc\
		-o build/helloworld-lib-64 build/helloworld-lib-64.o
build/printf-example: src/08-printf-example.s
	as --32 -I inc -o build/printf-example.o src/08-printf-example.s
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc\
		-o build/printf-example build/printf-example.o
build/printf-example-64: src/08-printf-example-64.s
	as -I inc -o build/printf-example-64.o src/08-printf-example-64.s
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc\
		-o build/printf-example-64 build/printf-example-64.o
build/librecord.so: build/readrec.o build/writerec.o
	ld -m elf_i386 -shared -o build/librecord.so\
		build/readrec.o build/writerec.o
build/writerecs-shared: src/06-writerecs.s build/librecord.so
	as --32 -I inc -o build/writerecs-shared.o src/06-writerecs.s
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2\
		-L build -lrecord\
		-o build/writerecs-shared build/writerecs-shared.o
build/librecord-64.so: build/readrec-64.o build/writerec-64.o
	ld -shared -o build/librecord-64.so\
		build/readrec-64.o build/writerec-64.o
build/writerecs-shared-64: src/06-writerecs-64.s build/librecord-64.so
	as -I inc -o build/writerecs-shared-64.o src/06-writerecs-64.s
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -L build -lrecord-64\
		-o build/writerecs-shared-64 build/writerecs-shared-64.o

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
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs.dat
test-readrecs:
	build/readrecs
test-add-year:
	-rm build/recs2.dat
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs.dat
	build/add-year
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs2.dat
test-writerecs-64:
	-rm build/recs-64.dat
	build/writerecs-64
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs-64.dat
test-readrecs-64:
	build/readrecs-64
test-add-year-64:
	-rm build/recs2-64.dat
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs-64.dat
	build/add-year-64
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs2-64.dat
test-robust-add-year:
	-rm build/recs.dat
	build/robust-add-year; echo $$?
test-robust-add-year-64:
	-rm build/recs-64.dat
	build/robust-add-year-64; echo $$?
test-helloworld-nolib:
	build/helloworld-nolib
test-helloworld-lib:
	build/helloworld-lib
test-helloworld-nolib-64:
	build/helloworld-nolib-64
test-helloworld-lib-64:
	build/helloworld-lib-64
test-printf-example:
	build/printf-example
test-printf-example-64:
	build/printf-example-64
test-writerecs-shared:
	-rm build/recs.dat
	build/writerecs-shared
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs.dat
test-writerecs-shared-64:
	-rm build/recs-64.dat
	build/writerecs-shared-64
	hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'\
		build/recs-64.dat

