# Uranium SPH Plate-Impact Template

This repository contains a compact Fortran template for a two-dimensional smoothed particle hydrodynamics (SPH) plate-impact exercise. It was prepared by Zhang Kun at NUDT as a teaching template: students forked the repository, changed the template for their own paths or parameter studies, and submitted their work through GitHub.

The current version keeps only the runnable template code and removes the old student submission-link files from the repository root.

## Model Scope

- Method: smoothed particle hydrodynamics (SPH)
- Problem type: two rectangular uranium-like plates in a simplified plate-impact setup
- Language: Fortran
- Units used in the original teaching code: `g`, `cm`, and `s`
- Output files:
  - `ans_initial.txt`
  - `ans_final.txt`

The template can be used to adjust the initial impact velocity and inspect the evolution of particle pressure and density fields. The output files can be imported into Tecplot 3 for post-processing and visualization.

## Repository Layout

```text
.
|-- variable.f90       # Shared simulation variables
|-- init.f90           # Particle layout, material constants, and initial conditions
|-- sub_function.f90   # SPH kernel, density, stress, motion, and output routines
|-- sph.f90            # Main program
|-- Makefile           # gfortran build helper
|-- exe.rar            # Original precompiled executable package kept for reference
`-- README.md
```

## Requirements

- A Fortran compiler with Fortran 90 support.
- Tested build command uses `gfortran`.

## Build

Using the Makefile:

```bash
make
```

Or compile manually:

```bash
gfortran -O2 -Wall -Wextra -o sph_plate_impact variable.f90 sub_function.f90 init.f90 sph.f90
```

## Run

```bash
./sph_plate_impact
```

On Windows PowerShell after compiling with MinGW gfortran:

```powershell
./sph_plate_impact.exe
```

The program writes initial and final particle states to:

```text
ans_initial.txt
ans_final.txt
```

## Precompiled Package

`exe.rar` contains the original precompiled executable package used in the teaching exercise. The source code is kept as the main reference, and the archive is retained for convenience.

## Notes

This template demonstrates a basic SPH plate-impact workflow, including particle initialization, kernel-gradient evaluation, density update, pressure calculation, stress update, and explicit motion integration. The initial velocity is defined in `init.f90` and can be modified for different impact cases.

## Attribution

Written by Zhang Kun, National University of Defense Technology (NUDT).
