#!/bin/bash
#SBATCH --job-name=checkm_rgut_%j
#SBATCH --output=checkm_rgut_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=8:30:00
#SBATCH --nodes=20 
#SBATCH --ntasks-per-node=1 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL

module load python/3.6-conda5.2
source activate checkm


part=$1
checkm lineage_wf /fs/scratch/PAS0439/Ming/databases/Rgut/tmp_${part}  ../checkm_res/check_res_${part} -f ../checkm_res/${part}_checkm.out -t 20 

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
