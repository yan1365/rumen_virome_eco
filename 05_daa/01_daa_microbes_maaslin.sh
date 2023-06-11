#!/bin/bash
#SBATCH --job-name=maaslin
#SBATCH --nodes=1 --ntasks-per-node=8
#SBATCH --time=04:00:00
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

module load R/4.1.0-gnu9.1 

R CMD BATCH 01_daa_microbes_maaslin.R

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS