#!/bin/bash
#SBATCH --job-name=network_%j
#SBATCH --output=network_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=14:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

module load python/3.6-conda5.2
source activate /fs/ess/PAS0439/MING/conda/MYENV


START=$SECONDS
python pre_df_for_network.py

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS