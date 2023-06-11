#!/bin/bash
#SBATCH --job-name=prodigal_%j
#SBATCH --output=prodigal_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=16:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439
#SBATCH --mail-user=yan1365,yan.1365@osu.edu


cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags

START=$SECONDS


module load python/3.6-conda5.2
source activate prodigal-2.6.3

prodigal -i prophage_rumen_mags_category2.fasta  -p meta -a prophage_rumen_mags_category2.faa

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS