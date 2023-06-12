#!/bin/bash
#SBATCH --job-name=prodigal_diet_%j
#SBATCH --output=prodigal_diet_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40 
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS
module load python/3.6-conda5.2
source activate prodigal-2.6.3 

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/08_inStrain_rug4941

prodigal -i rug_hunage_rumnemamgs_drep98.fasta -d repre_genomes_instrain.genes.fna -a repre_genomes_instrain.genes.faa

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS