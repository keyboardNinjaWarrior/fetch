fetch: fetch.o
	ld -o fetch fetch.o

fetch.o: fetch.s exit.s
	as --gstabs -o fetch.o fetch.s

mem: mem.o
	ld -o mem mem.o

mem.o: mem.s exit.s stack.s
	as -o mem.o mem.s

and: and.o
	ld -o and and.o

and.o: and.s exit.s
	as -o and.o and.s
