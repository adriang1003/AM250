FC = mpif90
FFLAGS =
DFLAGS =
LFLAGS =

.PHONY: clean

all: latency.ex

latency.ex: latency.o
	$(FC) $(LFLAGS) -o latency.ex latency.o
%.o : %.f90
	$(FC) -c $(DFLAGS) $<
clean:
	rm -f *.ex
	rm -f *.o
	rm -f *.err
