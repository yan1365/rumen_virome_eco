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

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/09_inStrain_RVD


bowtie2-build /fs/ess/PAS0439/MING/virome/checkv_trimmed_for_dowmstream/RVD_resources/RVD.fa  bt2/rvd.bt2

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS