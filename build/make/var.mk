#paths
current		:= ./../..
build		:= $(current)/build
src		:= $(current)/src
debug		:= $(build)/debug
exe		:= $(build)/exe
obj		:= $(build)/obj
inc		:= $(src)/include
lib		:= $(src)/lib

#compiler
cc 		:= gcc
flags		:= -fno-asynchronous-unwind-tables -nostdlib -I$(inc)
optim		:= -O0

vpath %.c $(src) %.o $(obj) %.h $(headers)
