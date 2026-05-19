FC ?= gfortran
FFLAGS ?= -O2 -Wall -Wextra
TARGET := sph_plate_impact
SOURCES := variable.f90 sub_function.f90 init.f90 sph.f90
OBJECTS := $(SOURCES:.f90=.o)

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(FC) $(FFLAGS) -o $@ $(OBJECTS)

%.o: %.f90
	$(FC) $(FFLAGS) -c $<

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) *.o *.mod ans_initial.txt ans_final.txt
