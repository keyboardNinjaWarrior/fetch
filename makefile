fetch: fetch.o
	ld -o fetch fetch.o

fetch.o: fetch.s
	as -o fetch.o fetch.s
