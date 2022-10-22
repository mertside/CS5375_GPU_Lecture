#!/bin/bash

#SBATCH --job-name=CS5375_GPU_Lecture
#SBATCH --output=%x.%j.o
#SBATCH --error=%x.%j.e
#SBATCH --partition=matador
#SBATCH --nodes=1

nvcc add_v5.cu -o add_v5.exe
./add_v5.exe
