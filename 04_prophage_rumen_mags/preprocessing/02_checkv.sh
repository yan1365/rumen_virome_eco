#!/bin/bash
#SBATCH --job-name=checkv_%j
#SBATCH --output=checkv_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=1:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/scripts/04_prophage_rumen_mags/samples

START=$SECONDS
id=${1}
dataset=rug4941_rumen_mags_${id}.txt
echo "processing ${dataset}"

module load python/3.6-conda5.2
source activate checkv 

for f in $(cat ${dataset});
do

echo ${f};

checkv end_to_end -t 10 /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/vs2_pass1/${f}/final-viral-combined.fa  /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/checkv/${f}   -d /fs/ess/PAS0439/MING/databases/checkv-db-v1.0
done

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS