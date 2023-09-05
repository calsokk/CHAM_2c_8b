CPU_ARCH = x86
CFLAGS += -g -O2 -Wall -m64
all: mvp_fpga_test

mvp_fpga_test : mvp_fpga_test.c
	@gcc mvp_fpga_test.c -o $@ ${CFLAGS} -L${CURDIR} -I${CURDIR} -lndd -lm -lpthread -lrt

clean:
	/bin/rm -f mvp_fpga_test *.o
