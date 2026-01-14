fetch: fetch.o
	ld -o fetch fetch.o

fetch.o: fetch.s
	as -o fetch.o fetch.s

mem: mem.o
	ld -o mem mem.o

mem.o: mem.s
	as -o mem.o mem.s
