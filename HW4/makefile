FC = mpif90
FFLAGS =
DFLAGS =
LFLAGS =

.PHONY: clean

all: hellompi.ex sendReceive.ex pingPong.ex ring.ex pi.ex

hellompi.ex: hellompi.o
	$(FC) $(LFLAGS) -o hellompi.ex hellompi.o
sendReceive.ex: sendReceive.o
	$(FC) $(LFLAGS) -o sendReceive.ex sendReceive.o
pingPong.ex: pingPong.o
	$(FC) $(LFLAGS) -o pingPong.ex pingPong.o
ring.ex: ring.o
	$(FC) $(LFLAGS) -o ring.ex ring.o
pi.ex: pi.o
	$(FC) $(LFLAGS) -o pi.ex pi.o
%.o : %.f90
	$(FC) -c $(DFLAGS) $<
clean:
	rm -f hellompi.ex
	rm -f sendReceive.ex
	rm -f pingPong.ex
	rm -f ring.ex
	rm -f pi.ex
	rm -f *.o
	rm -f *.err
