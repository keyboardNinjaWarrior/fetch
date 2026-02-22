fetch: fetch.o output.o
	ld -o fetch fetch.o output.o

fetch.o: fetch.s exit.s output.s
	as -o fetch.o fetch.s

output.o: output.s stack.s
	as -o output.o output.s
