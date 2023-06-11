#!/bin/bash
#SBATCH --job-name=amrfinder_%j
#SBATCH --output=amrfinder_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=10:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS


module load python/3.6-conda5.2
source activate /fs/ess/PAS0439/MING/conda/AMRFinder

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/amr
amrfinder -n ../prophage_rumen_mags_category2.fasta  -o prophage_rumen_mags_category2_amrfinder_out.fasta --threads 20

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
