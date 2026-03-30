.PHONY: run

run: test/fetch
	@echo Running...
	@clear
	@./test/fetch

test/fetch: obj/fetch.o obj/exit.o test
	ld -o test/fetch obj/fetch.o obj/exit.o
	
obj/fetch.o obj/exit.o: src/fetch.s src/exit.s rsc/lain.sixel obj
	as -g -o obj/fetch.o src/fetch.s
	as -g -o obj/exit.o src/exit.s

#	as -o fetch.o fetch.s
#	as -o exit.o exit.s

obj:
	mkdir obj

test:
	mkdir test
