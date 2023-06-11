#!/bin/bash
#SBATCH --job-name=dramv_%j
#SBATCH --output=dramv_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

part=${1}

module load python/3.6-conda5.2
source activate dram

START=$SECONDS

part=${1}
cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/prophage_rumen_mags_vs2_vibrant_intersection_split/

DRAM-v.py annotate -i ../dram_annotation/${part}/for-dramv/final-viral-combined-for-dramv.fa  -v ../dram_annotation/${part}/for-dramv/viral-affi-contigs-for-dramv.tab -o ../dram_annotation/${part}/annotation
DRAM-v.py distill -i ../dram_annotation/${part}/annotation/annotations.tsv -o ../dram_annotation/${part}/distill


DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS