# Dynamic linking path
LD_LIBRARY_PATH := ./build
export LD_LIBRARY_PATH

# Common arguments
DEBUG_ARGS := #-g
INC_ARGS := -I inc
AS_ARGS_32 := $(DEBUG_ARGS) $(INC_ARGS) --32
LD_ARGS_32 := $(DEBUG_ARGS) -m elf_i386
AS_ARGS_64 := $(DEBUG_ARGS) $(INC_ARGS)
LD_ARGS_64 := $(DEBUG_ARGS)
C_ARGS := $(DEBUG_ARGS)

# Common test commands or arguments
PRINT_RECS := hexdump -e '"Name: " 2/40 "%s " "\n" "Address: " 1/240 "%s" "\n" "Age: " "%d\n"'
LOWERCASE_TEST_STRING := "iT's aLl uppErCaSE!\n"

# Target locations
vpath %.s src
vpath %.s inc
vpath %.c src
vpath %.o build
vpath % build

# Programs
PROGRAMS_32 := exit max power factorial toupper writerecs readrecs add-year\
		robust-add-year helloworld-nolib helloworld-lib printf-example\
		writerecs-shared readrecs-alloc conversion-program
PROGRAMS_64 := $(patsubst %,%-64,$(PROGRAMS_32))
C_PROGRAMS := hello-world-c

# Object files
OBJECTS_32 := $(patsubst %,%.o,$(PROGRAMS_32))
OBJECTS_64 := $(patsubst %,%.o,$(PROGRAMS_64))

# Default target
all: $(PROGRAMS_32) $(PROGRAMS_64) $(C_PROGRAMS)

# Clean up build artefacts
.PHONY: clean
clean:
	rm -rf build

# Build directory
build:
	mkdir build
$(PROGRAMS_32) $(PROGRAMS_64) $(C_PROGRAMS): | build
$(OBJECTS_32) $(OBJECST_64): | build

# Build objects 32-bit
build/exit.o: 03-exit.s
	as $(AS_ARGS_32) -o $@ $<
build/max.o: 03-max.s
	as $(AS_ARGS_32) -o $@ $<
build/power.o: 04-power.s
	as $(AS_ARGS_32) -o $@ $<
build/factorial.o: 04-factorial.s
	as $(AS_ARGS_32) -o $@ $<
build/toupper.o: 05-toupper.s
	as $(AS_ARGS_32) -o $@ $<
build/readrec.o: 06-readrec.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/writerec.o: 06-writerec.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/count-chars.o: 06-count-chars.s
	as $(AS_ARGS_32) -o $@ $<
build/write-newline.o: 06-write-newline.s linux-32.s
	as $(AS_ARGS_32) -o $@ $<
build/writerecs.o: 06-writerecs.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/readrecs.o: 06-readrecs.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/add-year.o: 06-add-year.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/error-exit.o: 07-error-exit.s linux-32.s
	as $(AS_ARGS_32) -o $@ $<
build/robust-add-year.o: 07-robust-add-year.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/helloworld-nolib.o: 08-helloworld-nolib.s linux-32.s
	as $(AS_ARGS_32) -o $@ $<
build/helloworld-lib.o: 08-helloworld-lib.s
	as $(AS_ARGS_32) -o $@ $<
build/printf-example.o: 08-printf-example.s
	as $(AS_ARGS_32) -o $@ $<
build/writerecs-shared.o: 06-writerecs.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/alloc.o: 09-alloc.s linux-32.s
	as $(AS_ARGS_32) -o $@ $<
build/readrecs-alloc.o: 09-readrecs-alloc.s linux-32.s record-def.s
	as $(AS_ARGS_32) -o $@ $<
build/integer-to-string.o: 10-integer-to-string.s
	as $(AS_ARGS_32) -o $@ $<
build/conversion-program.o: 10-conversion-program.s linux-32.s
	as $(AS_ARGS_32) -o $@ $<

# Build shared objects 32-bit
build/librecord.so: readrec.o writerec.o
	ld $(LD_ARGS_32) -shared -o $@ $^

# Build executables-32
build/exit: exit.o
	ld $(LD_ARGS_32) -o $@ $^
build/max: max.o
	ld $(LD_ARGS_32) -o $@ $^
build/power: power.o
	ld $(LD_ARGS_32) -o $@ $^
build/factorial: factorial.o
	ld $(LD_ARGS_32) -o $@ $^
build/toupper: toupper.o
	ld $(LD_ARGS_32) -o $@ $^
build/writerecs: writerecs.o writerec.o
	ld $(LD_ARGS_32) -o $@ $^
build/readrecs: readrecs.o readrec.o count-chars.o write-newline.o
	ld $(LD_ARGS_32) -o $@ $^
build/add-year: add-year.o readrec.o writerec.o
	ld $(LD_ARGS_32) -o $@ $^
build/robust-add-year: robust-add-year.o error-exit.o write-newline.o\
		count-chars.o readrec.o writerec.o
	ld $(LD_ARGS_32) -o $@ $^
build/helloworld-nolib: helloworld-nolib.o
	ld $(LD_ARGS_32) -o $@ $^
build/helloworld-lib: helloworld-lib.o
	ld $(LD_ARGS_32) -o $@ $^\
		-dynamic-linker /lib/ld-linux.so.2 -lc
build/printf-example: printf-example.o
	ld $(LD_ARGS_32) -o $@ $^\
		-dynamic-linker /lib/ld-linux.so.2 -lc
build/writerecs-shared: writerecs.o librecord.so
	ld $(LD_ARGS_32) -o $@ $<\
		-dynamic-linker /lib/ld-linux.so.2 -Lbuild -lrecord
build/readrecs-alloc: readrecs-alloc.o readrec.o count-chars.o write-newline.o alloc.o
	ld $(LD_ARGS_32) -o $@ $^
build/conversion-program: conversion-program.o\
		integer-to-string.o count-chars.o write-newline.o
	ld $(LD_ARGS_32) -o $@ $^

# Build objects-64:
build/exit-64.o: 03-exit-64.s
	as $(AS_ARGS_64) -o $@ $<
build/max-64.o: 03-max-64.s
	as $(AS_ARGS_64) -o $@ $<
build/power-64.o: 04-power-64.s
	as $(AS_ARGS_64) -o $@ $<
build/factorial-64.o: 04-factorial-64.s
	as $(AS_ARGS_64) -o $@ $<
build/toupper-64.o: 05-toupper-64.s
	as $(AS_ARGS_64) -o $@ $<
build/readrec-64.o: 06-readrec-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/writerec-64.o: 06-writerec-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/count-chars-64.o: 06-count-chars-64.s
	as $(AS_ARGS_64) -o $@ $<
build/write-newline-64.o: 06-write-newline-64.s linux-64.s
	as $(AS_ARGS_64) -o $@ $<
build/writerecs-64.o: 06-writerecs-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/readrecs-64.o: 06-readrecs-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/add-year-64.o: 06-add-year-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/error-exit-64.o: 07-error-exit-64.s linux-64.s
	as $(AS_ARGS_64) -o $@ $<
build/robust-add-year-64.o: 07-robust-add-year-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/helloworld-nolib-64.o: 08-helloworld-nolib-64.s linux-64.s
	as $(AS_ARGS_64) -o $@ $<
build/helloworld-lib-64.o: 08-helloworld-lib-64.s
	as $(AS_ARGS_64) -o $@ $<
build/printf-example-64.o: 08-printf-example-64.s
	as $(AS_ARGS_64) -o $@ $<
build/writerecs-shared-64.o: 06-writerecs-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/alloc-64.o: 09-alloc-64.s linux-64.s
	as $(AS_ARGS_64) -o $@ $<
build/readrecs-alloc-64.o: 09-readrecs-alloc-64.s linux-64.s record-def.s
	as $(AS_ARGS_64) -o $@ $<
build/integer-to-string-64.o: 10-integer-to-string-64.s
	as $(AS_ARGS_64) -o $@ $<
build/conversion-program-64.o: 10-conversion-program-64.s linux-64.s
	as $(AS_ARGS_64) -o $@ $<

# Build shared objects 64-bit
build/librecord-64.so: readrec-64.o writerec-64.o
	ld $(LD_ARGS_64) -shared -o $@ $^

# Build executables-64
build/exit-64: exit-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/max-64: max-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/power-64: power-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/factorial-64: factorial-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/toupper-64: toupper-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/writerecs-64: writerecs-64.o writerec-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/readrecs-64: readrecs-64.o readrec-64.o count-chars-64.o write-newline-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/add-year-64: add-year-64.o readrec-64.o writerec-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/robust-add-year-64: robust-add-year-64.o error-exit-64.o write-newline-64.o\
		count-chars-64.o readrec-64.o writerec-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/helloworld-nolib-64: helloworld-nolib-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/helloworld-lib-64: helloworld-lib-64.o
	ld $(LD_ARGS_64) -o $@ $^\
		-dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc
build/printf-example-64: printf-example-64.o
	ld $(LD_ARGS_64) -o $@ $^\
		-dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc
build/writerecs-shared-64: writerecs-64.o librecord-64.so
	ld $(LD_ARGS_64) -o $@ $<\
		-dynamic-linker /lib64/ld-linux-x86-64.so.2 -Lbuild -lrecord-64
build/readrecs-alloc-64: readrecs-alloc-64.o readrec-64.o count-chars-64.o\
		write-newline-64.o alloc-64.o
	ld $(LD_ARGS_64) -o $@ $^
build/conversion-program-64: conversion-program-64.o\
		integer-to-string-64.o count-chars-64.o write-newline-64.o
	ld $(LD_ARGS_64) -o $@ $^

# Build C programs
hello-world-c: 11-hello-world.c
	gcc $(C_ARGS) -o build/$@ $<

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

