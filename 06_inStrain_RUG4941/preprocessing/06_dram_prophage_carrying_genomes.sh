#!/bin/bash
#SBATCH --job-name=dram_genome_%j
#SBATCH --output=dram_genome_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=6:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=10 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu


module load python/3.6-conda5.2
source activate dram

START=$SECONDS
genome=$1

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/08_inStrain_rug4941/prophage_carrying_genome_annotate/MAGs

DRAM.py annotate  \
        -i ${genome}\
        -o  ../dram_anno_genomes/${genome}\
        --threads 10

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS