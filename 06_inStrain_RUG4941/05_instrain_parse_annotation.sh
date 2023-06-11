#!/bin/bash
#SBATCH --job-name=parse_anno_%j
#SBATCH --output=parse_anno_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=20:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS
module load python/3.6-conda5.2
source activate instrain

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/08_inStrain_rug4941/instrain_profiles

inStrain parse_annotations -i $(cat ../../../scripts/08_inStrain_RUG4941/instrain_compare.txt) -o ../cazy_parse_anno_out -a ../geneAnnotations_CAZyme.csv -p 20

DURATION=$(( SECONDS - START )) 

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
