#!/bin/bash
#SBATCH --job-name=gtdbtk_rgut_%j
#SBATCH --output=gtdbtk_rgut_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=10:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=48 --partition=hugemem
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL

module load python/3.6-conda5.2
source activate /fs/scratch/PAS0439/Ming/conda/gtdbtk-2.1.1

cd /fs/scratch/PAS0439/Ming/databases/rumen_mags_high_quality/
# something went wrong in setting the environmental variable, need to run the following line of script every time running gtdbtk
export GTDBTK_DATA_PATH=/fs/scratch/PAS0439/Ming/conda/gtdbtk-2.1.1/share/gtdbtk-2.1.1/db

gtdbtk classify_wf -x fasta --genome_dir dereplicated_genomes  --out_dir gtdb-tk-out-R207 --cpus 48 

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
