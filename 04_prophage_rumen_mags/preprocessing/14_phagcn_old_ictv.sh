#!/bin/bash
#SBATCH --job-name=phagcnold_%j
#SBATCH --output=phagcnold_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=8:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

module load python/3.6-conda5.2
source activate /fs/scratch/PAS0439/Ming/conda/phagcn-old-ictv/PhaGCN

cd /fs/scratch/PAS0439/Ming/conda/phagcn-old-ictv/PhaGCN

python run_Speed_up.py --contigs /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/prophage_votu.fasta --len 5000

mv final_prediction.csv /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/prophage_votus_taxa_phagcn_old_ictv.csv

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
