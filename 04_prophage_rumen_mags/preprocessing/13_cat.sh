#!/bin/bash
#SBATCH --job-name=cat_%j
#SBATCH --output=cat_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=10:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

module load python/3.6-conda5.2
source activate /fs/ess/PAS0439/MING/conda/cat

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags
CAT contigs -c  prophage_rumen_mags_vOTUs.fa -d /fs/scratch/PAS0439/Ming/databases/CAT_prepare_20210107/2021-01-07_CAT_database/ -t /fs/scratch/PAS0439/Ming/databases/CAT_prepare_20210107/2021-01-07_taxonomy

CAT add_names -i out.CAT.contig2classification.txt -o prophage_votus_taxa_cat.tsv -t /fs/scratch/PAS0439/Ming/databases/CAT_prepare_20210107/2021-01-07_taxonomy --only_official --exclude_scores
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
