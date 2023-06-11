#!/bin/bash
#SBATCH --job-name=drep_instrain_%j
#SBATCH --output=drep_instrain_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=16:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS
module load python/3.6-conda5.2
source activate drep

cd /fs/scratch/PAS0439/Ming/databases/RUG4941_rumen_mags_hungate_high_quality/MAGs

dRep dereplicate ../drep_for_instrain -g ./*.fasta --S_algorithm fastANI  --greedy_secondary_clustering -ms 10000 -pa 0.9 -sa 0.98 -nc 0.30 -cm larger -p 40 --ignoreGenomeQuality --extra_weight_table ../extra_weighted_table.tsv 

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
