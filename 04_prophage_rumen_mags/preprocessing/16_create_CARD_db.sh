#!/bin/bash
#SBATCH --job-name=card_db_%j
#SBATCH --output=card_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=12:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/amr

module load python/3.6-conda5.2
source activate checkv

makeblastdb -in /fs/ess/PAS0439/MING/databases/CARD/protein_fasta_protein_homolog_model.fasta  -dbtype prot -out CARD_db

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
