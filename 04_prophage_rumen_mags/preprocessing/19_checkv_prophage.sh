#!/bin/bash
#SBATCH --job-name=checkv_%j
#SBATCH --output=checkv_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=04:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

# get number of host genes and viral genes
cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags

START=$SECONDS

module load python/3.6-conda5.2
source activate checkv 

checkv end_to_end -t 10  prophage_rumen_mags_vs2_vibrant_intersection_for_checkv.fa   prophage_rumen_mags_vs2_vibrant_intersection_checkv  -d /fs/ess/PAS0439/MING/databases/checkv-db-v1.0


DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS