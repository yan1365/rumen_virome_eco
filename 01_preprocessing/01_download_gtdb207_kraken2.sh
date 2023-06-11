#!/bin/bash
#SBATCH --job-name=download_db_%j
#SBATCH --output=download_db_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=10:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

cd /fs/scratch/PAS0439/Ming/faa

module load python/3.6-conda5.2
source activate axel

cd /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rgut6000

axel -n 40 http://ftp.tue.mpg.de/ebio/projects/struo2/GTDB_release207/kraken2/hash.k2d

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS