#!/bin/bash
#SBATCH --job-name=checkm_rgut_%j
#SBATCH --output=checkm_rgut_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=12:30:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=40 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL

module load python/3.6-conda5.2
source activate checkm

cd /fs/ess/PAS0439/MING/databases/RUG4941/MAGs/MAGS_for_checkm
part=$1
cp -R ${part} $TMPDIR/

checkm lineage_wf -x fna $TMPDIR/${part}  $TMPDIR/check_res_${part} -f ../../checkm/${part}_checkm.out -t 40 

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
