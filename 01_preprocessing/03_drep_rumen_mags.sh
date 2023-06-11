#!/bin/bash
#SBATCH --job-name=drep_%j
#SBATCH --output=drep_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20  
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

module load python/3.6-conda5.2
source activate drep 

START=$SECONDS

dRep dereplicate --ignoreGenomeQuality /fs/scratch/PAS0439/Ming/databases/rumen_mags_high_quality/MAGs -p 20 -pa 0.999 --SkipSecondary  -g /fs/scratch/PAS0439/Ming/databases/rumen_mags_high_quality/MAGs/*.fasta
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS