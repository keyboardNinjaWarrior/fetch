include var.mk

main := fetch

$(exe)/main: $(obj)/main.c $(exe)
	gcc $(flags) $(optim) $(obj)/main.c -o $(exe)/$(main)
	./$(exe)/$(main)

$(obj)/main.o: $(src)/main.c $(obj)
	gcc $(flags) $(optim) $(src)/main.c -o $(obj)/main.o

#files
$(exe): $(build) 
	-mkdir $(exe)

$(obj): $(build)
	-mkdir $(obj)

$(build):
	-mkdir $(build)
