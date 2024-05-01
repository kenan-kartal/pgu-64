# Dynamic linking path
LD_LIBRARY_PATH := ./build
export LD_LIBRARY_PATH

# Common arguments
AS_ARGS_32 := --32
LD_ARGS_32 := -m elf_i386
INC_ARGS := -I inc

# Common test commands or arguments
PRINT_RECS := hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'
LOWERCASE_TEST_STRING := "iT's aLl uppErCaSE!\n"

# Target locations
vpath %.s src
vpath %.c src
vpath % build

# Programs
PROGRAMS_32 := exit max power factorial toupper writerecs readrecs add-year\
	       robust-add-year helloworld-nolib helloworld-lib printf-example\
	       writerecs-shared readrecs-alloc conversion-program
PROGRAMS_64 := $(patsubst %,%-64,$(PROGRAMS_32))
OTHER_PROGRAMS := hello-world-c

# Default target
all: $(PROGRAMS_32) $(PROGRAMS_64) $(OTHER_PROGRAMS)

# Clean up build artefacts
.PHONY: clean
clean:
	rm -rf build

# Build artefacts
build:
	mkdir build
$(PROGRAMS_32) $(PROGRAMS_64) $(OTHER_PROGRAMS): | build
exit: 03-exit.s
	as $(AS_ARGS_32) -o build/exit.o $<
	ld $(LD_ARGS_32) -o build/exit build/exit.o
exit-64: 03-exit-64.s
	as -o build/exit-64.o $<
	ld -o build/exit-64 build/exit-64.o
max: 03-max.s
	as $(AS_ARGS_32) -o build/max.o $<
	ld $(LD_ARGS_32) -o build/max build/max.o
max-64: 03-max-64.s
	as -o build/max-64.o $<
	ld -o build/max-64 build/max-64.o
power: 04-power.s
	as $(AS_ARGS_32) -o build/power.o $<
	ld $(LD_ARGS_32) -o build/power build/power.o
power-64: 04-power-64.s
	as -o build/power-64.o $<
	ld -o build/power-64 build/power-64.o
factorial: 04-factorial.s
	as $(AS_ARGS_32) -o build/factorial.o $<
	ld $(LD_ARGS_32) -o build/factorial build/factorial.o
factorial-64: 04-factorial-64.s
	as -o build/factorial-64.o $<
	ld -o build/factorial-64 build/factorial-64.o
toupper: 05-toupper.s
	as $(AS_ARGS_32) -o build/toupper.o $<
	ld $(LD_ARGS_32) -o build/toupper build/toupper.o
toupper-64: 05-toupper-64.s
	as -o build/toupper-64.o $<
	ld -o build/toupper-64 build/toupper-64.o
readrec.o: 06-readrec.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/readrec.o $<
writerec.o: 06-writerec.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/writerec.o $<
count-chars.o: 06-count-chars.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/count-chars.o $<
write-newline.o: 06-write-newline.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/write-newline.o $<
writerecs: 06-writerecs.s\
		writerec.o
	as $(AS_ARGS_32) $(INC_ARGS) -o build/writerecs.o $<
	ld $(LD_ARGS_32) -o build/writerecs\
		build/writerec.o build/writerecs.o
readrecs: 06-readrecs.s\
		readrec.o count-chars.o write-newline.o
	as $(AS_ARGS_32) $(INC_ARGS) -o build/readrecs.o $<
	ld $(LD_ARGS_32) -o build/readrecs\
		build/readrec.o build/count-chars.o build/write-newline.o\
		build/readrecs.o
add-year: 06-add-year.s\
		readrec.o writerec.o
	as $(AS_ARGS_32) $(INC_ARGS) -o build/add-year.o $<
	ld $(LD_ARGS_32) -o build/add-year\
		build/readrec.o build/writerec.o build/add-year.o
readrec-64.o: 06-readrec-64.s
	as $(INC_ARGS) -o build/readrec-64.o $<
writerec-64.o: 06-writerec-64.s
	as $(INC_ARGS) -o build/writerec-64.o $<
count-chars-64.o: 06-count-chars-64.s
	as $(INC_ARGS) -o build/count-chars-64.o $<
write-newline-64.o: 06-write-newline-64.s
	as $(INC_ARGS) -o build/write-newline-64.o $<
writerecs-64: 06-writerecs-64.s\
		writerec-64.o
	as $(INC_ARGS) -o build/writerecs-64.o $<
	ld -o build/writerecs-64\
		build/writerecs-64.o build/writerec-64.o
readrecs-64: 06-readrecs-64.s\
		readrec-64.o count-chars-64.o write-newline-64.o
	as $(INC_ARGS) -o build/readrecs-64.o $<
	ld -o build/readrecs-64\
		build/readrecs-64.o build/readrec-64.o build/count-chars-64.o\
		build/write-newline-64.o
add-year-64: 06-add-year-64.s\
		readrec-64.o writerec-64.o
	as $(INC_ARGS) -o build/add-year-64.o $<
	ld -o build/add-year-64\
		build/add-year-64.o build/readrec-64.o build/writerec-64.o
error-exit.o: 07-error-exit.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/error-exit.o $<
robust-add-year: 07-robust-add-year.s\
		error-exit.o write-newline.o count-chars.o readrec.o writerec.o
	as $(AS_ARGS_32) $(INC_ARGS) -o build/robust-add-year.o $<
	ld $(LD_ARGS_32) -o build/robust-add-year\
		build/robust-add-year.o build/error-exit.o build/write-newline.o\
		build/count-chars.o build/readrec.o build/writerec.o
error-exit-64.o: 07-error-exit-64.s
	as $(INC_ARGS) -o build/error-exit-64.o $<
robust-add-year-64: 07-robust-add-year-64.s\
		error-exit-64.o write-newline-64.o count-chars-64.o\
		readrec-64.o writerec-64.o
	as $(INC_ARGS) -o build/robust-add-year-64.o $<
	ld -o build/robust-add-year-64\
		build/robust-add-year-64.o build/error-exit-64.o\
		build/write-newline-64.o build/count-chars-64.o\
		build/readrec-64.o build/writerec-64.o
helloworld-nolib: 08-helloworld-nolib.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/helloworld-nolib.o $<
	ld $(LD_ARGS_32) -o build/helloworld-nolib build/helloworld-nolib.o
helloworld-lib: 08-helloworld-lib.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/helloworld-lib.o $<
	ld $(LD_ARGS_32) -dynamic-linker /lib/ld-linux.so.2 -lc\
		-o build/helloworld-lib build/helloworld-lib.o
helloworld-nolib-64: 08-helloworld-nolib-64.s
	as $(INC_ARGS) -o build/helloworld-nolib-64.o $<
	ld -o build/helloworld-nolib-64 build/helloworld-nolib-64.o
helloworld-lib-64: 08-helloworld-lib-64.s
	as $(INC_ARGS) -o build/helloworld-lib-64.o $<
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc\
		-o build/helloworld-lib-64 build/helloworld-lib-64.o
printf-example: 08-printf-example.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/printf-example.o $<
	ld $(LD_ARGS_32) -dynamic-linker /lib/ld-linux.so.2 -lc\
		-o build/printf-example build/printf-example.o
printf-example-64: 08-printf-example-64.s
	as $(INC_ARGS) -o build/printf-example-64.o $<
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc\
		-o build/printf-example-64 build/printf-example-64.o
librecord.so: readrec.o\
		writerec.o
	ld $(LD_ARGS_32) -shared -o build/librecord.so\
		build/readrec.o build/writerec.o
writerecs-shared: 06-writerecs.s\
		librecord.so
	as $(AS_ARGS_32) $(INC_ARGS) -o build/writerecs-shared.o $<
	ld $(LD_ARGS_32) -dynamic-linker /lib/ld-linux.so.2\
		-L build -lrecord\
		-o build/writerecs-shared build/writerecs-shared.o
librecord-64.so: readrec-64.o\
		writerec-64.o
	ld -shared -o build/librecord-64.so\
		build/readrec-64.o build/writerec-64.o
writerecs-shared-64: 06-writerecs-64.s\
		librecord-64.so
	as $(INC_ARGS) -o build/writerecs-shared-64.o $<
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -L build -lrecord-64\
		-o build/writerecs-shared-64 build/writerecs-shared-64.o
alloc.o: 09-alloc.s
	as $(AS_ARGS_32) $(INC_ARGS) -o build/alloc.o $<
alloc-64.o: 09-alloc-64.s
	as $(INC_ARGS) -o build/alloc-64.o $<
readrecs-alloc: 09-readrecs-alloc.s\
		readrec.o count-chars.o write-newline.o alloc.o
	as $(AS_ARGS_32) $(INC_ARGS) -o build/readrecs-alloc.o $<
	ld $(LD_ARGS_32) -o build/readrecs-alloc\
		build/readrecs-alloc.o build/alloc.o\
		build/readrec.o build/count-chars.o build/write-newline.o
readrecs-alloc-64: 09-readrecs-alloc-64.s\
		readrec-64.o count-chars-64.o write-newline-64.o alloc-64.o
	as $(INC_ARGS) -o build/readrecs-alloc-64.o $<
	ld -o build/readrecs-alloc-64\
		build/readrecs-alloc-64.o build/readrec-64.o build/count-chars-64.o\
		build/write-newline-64.o build/alloc-64.o
integer-to-string.o: 10-integer-to-string.s
	as $(AS_ARGS_32) -o build/integer-to-string.o $<
conversion-program: 10-conversion-program.s\
		integer-to-string.o count-chars.o write-newline.o
	as $(AS_ARGS_32) $(INC_ARGS) -o build/conversion-program.o $<
	ld $(LD_ARGS_32) -o build/conversion-program build/conversion-program.o\
		build/integer-to-string.o build/count-chars.o build/write-newline.o
integer-to-string-64.o: 10-integer-to-string-64.s
	as -o build/integer-to-string-64.o $<
conversion-program-64: 10-conversion-program-64.s\
		integer-to-string-64.o count-chars-64.o write-newline-64.o
	as $(INC_ARGS) -o build/conversion-program-64.o $<
	ld -o build/conversion-program-64 build/conversion-program-64.o\
		build/integer-to-string-64.o build/count-chars-64.o\
		build/write-newline-64.o
hello-world-c: 11-hello-world.c
	gcc -o build/hello-world-c $<

# Tests
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
	echo $(LOWERCASE_TEST_STRING) > build/toupper_in
	build/toupper build/toupper_in build/toupper_out
	cat build/toupper_out
test-toupper-64:
	-rm build/toupper-64_out
	echo $(LOWERCASE_TEST_STRING) > build/toupper-64_in
	build/toupper-64 build/toupper-64_in build/toupper-64_out
	cat build/toupper-64_out
test-writerecs:
	-rm build/recs.dat
	build/writerecs
	$(PRINT_RECS) build/recs.dat
test-readrecs:
	build/readrecs
test-add-year:
	-rm build/recs2.dat
	$(PRINT_RECS) build/recs.dat
	build/add-year
	$(PRINT_RECS) build/recs2.dat
test-writerecs-64:
	-rm build/recs-64.dat
	build/writerecs-64
	$(PRINT_RECS) build/recs-64.dat
test-readrecs-64:
	build/readrecs-64
test-add-year-64:
	-rm build/recs2-64.dat
	$(PRINT_RECS) build/recs-64.dat
	build/add-year-64
	$(PRINT_RECS) build/recs2-64.dat
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
	$(PRINT_RECS) build/recs.dat
test-writerecs-shared-64:
	-rm build/recs-64.dat
	build/writerecs-shared-64
	$(PRINT_RECS) build/recs-64.dat
test-readrecs-alloc:
	build/readrecs-alloc
test-readrecs-alloc-64:
	build/readrecs-alloc-64
test-conversion-program:
	build/conversion-program
test-conversion-program-64:
	build/conversion-program-64
test-hello-world-c:
	build/hello-world-c
test-hello-world-pl:
	perl src/11-hello-world.pl
test-hello-world-py:
	python3 src/11-hello-world.py

