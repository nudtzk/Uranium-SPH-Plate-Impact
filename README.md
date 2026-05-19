# Uranium SPH Plate-Impact Template

This repository contains a compact Fortran template for a two-dimensional smoothed particle hydrodynamics (SPH) plate-impact exercise. It was originally prepared by Kun Zhang as a teaching template: students forked the repository, changed the template for their own paths or parameter studies, and submitted their work through GitHub.

The current version keeps only the runnable template code and removes the old student submission-link files from the repository root.

## Model Scope

- Method: smoothed particle hydrodynamics (SPH)
- Problem type: two rectangular uranium-like plates in a simplified plate-impact setup
- Language: Fortran
- Units used in the original teaching code: `g`, `cm`, and `s`
- Output files:
  - `ans_initial.txt`
  - `ans_final.txt`

The code is intentionally small and explicit. It is meant for teaching and code-reading rather than production-scale impact simulation.

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

`exe.rar` contains the original precompiled executable package that was used in the teaching exercise. The source code in this repository is the preferred reference, but the archive is kept so the original runnable package is not lost.

## Notes

This is a teaching template, not a calibrated research solver. It is useful for demonstrating SPH data structures, particle loops, kernel-gradient evaluation, density update, a simplified Gruneisen-type pressure update, and explicit time integration.

## Attribution

Template author and instructor: Kun Zhang.

The repository was used as a GitHub-based coding and submission exercise for students working on SPH and plate-impact simulation examples.
