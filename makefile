fetch: fetch.o read_char_from_file.o write_char.o
	ld -o fetch fetch.o read_char_from_file.o write_char.o

fetch.o: fetch.s exit.s read_char_from_file.s write_char.s
	as --gstabs -o fetch.o fetch.s

read_char_from_file.o: read_char_from_file.s stack.s
	as --gstabs -o read_char_from_file.o read_char_from_file.s

write_char.o: write_char.s stack.s
	as --gstabs -o write_char.o write_char.s
