all: mul

first: mul.o
	gcc -o $@ $+
mul.o : mul.s
	as -o $@ $<
clean: 
	rm -vf mul *.o
