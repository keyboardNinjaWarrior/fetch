fetch: fetch.o
	ld -o fetch fetch.o exit.o
	
fetch.o exit.o: fetch.s exit.s lain.sixel
	as -g -o fetch.o fetch.s
	as -g -o exit.o exit.s

#	as -o fetch.o fetch.s
#	as -o exit.o exit.s
