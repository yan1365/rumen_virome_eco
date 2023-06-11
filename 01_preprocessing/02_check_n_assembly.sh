#!/bin/bash
#SBATCH --job-name=assembly_n_%j
#SBATCH --output=assembly_n_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=1:30:00
#SBATCH --nodes=1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
#SBATCH --ntasks-per-node=1 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL

## dir %in% ASS  cattle  CBR  mix   sheep
dir=$1
module load python/3.6-conda5.2 ${dir}
source activate /fs/ess/PAS0439/MING/conda/MYENV

./check_n_assembly.py   ${dir}
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
