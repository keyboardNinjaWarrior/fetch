fetch: fetch.o
	ld -o fetch fetch.o

fetch.o: fetch.s exit.s
	as --gstabs -o fetch.o fetch.s

test: test.o
	ld -o test test.o
	gdb ./test

test.o: test.s exit.s
	as --gstabs -o test.o test.s
