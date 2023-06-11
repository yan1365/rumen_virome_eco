#!/bin/bash
#SBATCH --job-name=SpiecEasi_test_%j
#SBATCH --output=SpiecEasi_test_%j.out
#SBATCH --nodes=1 --ntasks-per-node=20
#SBATCH --time=8:00:00
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

cat SpiecEasi.R
module load R/4.1.0-gnu9.1 

R CMD BATCH SpiecEasi.R

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS