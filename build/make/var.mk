#compiler
cc 		:= clang
flags		:= -fno-asynchronous-unwind-tables -nostdlib
optim		:= -O0

#paths
current		:= ./../..
build		:= $(current)/build
src		:= $(current)/src
debug		:= $(build)/debug
exe		:= $(build)/exe
obj		:= $(build)/obj
headers		:= $(build)/include

vpath %.c $(src) %.o $(obj) %.h $(headers)
