#!/bin/bash
#SBATCH --job-name=card_db_%j
#SBATCH --output=card_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=6:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/amr

module load python/3.6-conda5.2
source activate checkv

blastp -num_threads 40 -db /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/amr/CARD_db -query ../prophage_rumen_mags_category2.faa  -outfmt "6 qseqid sseqid pident length qlen slen mismatch gapopen qstart qend sstart send evalue bitscore"  -evalue 1e-6 -out prophage_rumen_mags_category2_card.bln

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
