#!/bin/bash
#SBATCH --job-name=phagcnnew_%j
#SBATCH --output=phagcnnew_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=2:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

module load python/3.6-conda5.2
source activate /fs/scratch/PAS0439/Ming/conda/phagcn-new-ictv/PhaGCN_newICTV

cd /fs/scratch/PAS0439/Ming/conda/phagcn-new-ictv/PhaGCN_newICTV

python run_Speed_up.py --contigs /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/prophage_rumen_mags_vOTUs.fa --len 8000

mv final_prediction.csv /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/prophage_votus_taxa_phagcn_new_ictv.csv

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
