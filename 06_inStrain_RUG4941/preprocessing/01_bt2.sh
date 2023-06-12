#!/bin/bash
#SBATCH --job-name=bt2_diet_%j
#SBATCH --output=bt2_diet_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS
module load python/3.6-conda5.2
source activate bowtie2-2.4.4

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/08_inStrain_rug4941

bowtie2-build rug_hunage_rumnemamgs_drep98.fasta  bt2/repre_genomes_instrain.bt2

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS