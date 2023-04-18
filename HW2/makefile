FC = gfortran    
FFLAGS = -O3
DFLAGS = -g3
LFLAGS =

OBJECTS = mainTrap.o trap.o fx2.o fsinx.o
.PHONY: clean

all: trap.ex ones.ex

trap.ex: $(OBJECTS)
	$(FC) $(LFLAGS) -o trap.ex $(OBJECTS)
ones.ex: ones.o
	$(FC) $(LFLAGS) -o ones.ex ones.o
%.o : %.f90
	$(FC) -c $(DFLAGS) $<
clean:
	rm -f trap.ex $(OBJECTS)
	rm -f ones.ex
	rm -f *.o
