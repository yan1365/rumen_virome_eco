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


module load python/3.6-conda5.2
source activate axel

cd /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rgut_full

axel -n 40 https://data.gtdb.ecogenomic.org/releases/release207/207.0/genomic_files_reps/gtdb_genomes_reps_r207.tar.gz

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS