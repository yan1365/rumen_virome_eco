#!/bin/bash
#SBATCH --job-name=vibrant_%j
#SBATCH --output=vibrant_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20 
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439


START=$SECONDS

module load python/3.6-conda5.2
source activate vibrant-1.2.1

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags

VIBRANT_run.py -no_plot  -virome -t 20 -i prophage_rug_hungate_vs2_keep1_2.fa -folder ./vibrant_out 

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS