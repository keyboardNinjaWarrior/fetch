include var.mk

$(exe)/fetch: $(lib)/main.s $(src)/fetch.c $(inc)/main.h $(exe)
	$(cc) $(flags) $(optim) -o $@ $(word 1, $^) $(word 2, $^) 

# files
$(lib)/main.s: $(lib)

$(src)/fetch.c: $(src)

$(inc)/main.h: $(inc)

# ----------------------
$(exe): $(build) 
	-mkdir $(exe)

$(obj): $(build)
	-mkdir $(obj)

$(build):
	-mkdir $(build)

$(inc): $(src)
	-mkdir $(inc)

$(src):
	-mkdir $(src)

$(lib): $(src)
	-mkdir $(lib)
