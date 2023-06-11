#!/bin/bash
#SBATCH --job-name=build_bracken_rumenmagsfull_%j
#SBATCH --output=build_braken_rumenmagsfull_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40  --partition=hugemem 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

module load python/3.6-conda5.2
source activate kraken-2.1.2

START=$SECONDS

cd /fs/scratch/PAS0439/Ming/databases/

bracken-build -d kraken2_gtdb207_rumen_mags_full -t 40  -l 150 


DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS