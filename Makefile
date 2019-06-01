# Makefile
all: mul
 
mul: mul.o
	arm-linux-gnueabihf-gcc -o $@ $+
 
mul.o : mul.s
	arm-linux-gnueabihf-as -mfpu=neon -o $@ $<
 
clean:
	rm -vf mul *.o
