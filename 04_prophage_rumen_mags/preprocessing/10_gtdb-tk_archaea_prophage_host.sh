#!/bin/bash
#SBATCH --job-name=gtdbtk_%j
#SBATCH --output=gtdbtk_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=12:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=40 --partition=largemem
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL

module load python/3.6-conda5.2
source activate /fs/scratch/PAS0439/Ming/conda/gtdbtk-2.1.1 

export GTDBTK_DATA_PATH=/fs/scratch/PAS0439/Ming/conda/gtdbtk-2.1.1/share/gtdbtk-2.1.1/db

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/prophage_host_tree/
gtdbtk classify_wf --genome_dir archaea  --out_dir archaea-host-gtdb-tk-out --cpus 40

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
