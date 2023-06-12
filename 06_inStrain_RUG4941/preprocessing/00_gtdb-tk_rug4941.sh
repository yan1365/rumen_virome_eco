#!/bin/bash
#SBATCH --job-name=gtdbtk_rgut_%j
#SBATCH --output=gtdbtk_rgut_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=20:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=60 --partition=hugemem
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL

module load python/3.6-conda5.2
source activate /fs/scratch/PAS0439/Ming/conda/gtdbtk-2.1.1

cd /fs/ess/PAS0439/MING/databases/RUG4941/

mkdir gtdb-tk-out-RUG4941
cp -R MAGs/ $TMPDIR/

# something went wrong in setting the environmental variable, need to run the following line of script every time running gtdbtk
export GTDBTK_DATA_PATH=/fs/scratch/PAS0439/Ming/conda/gtdbtk-2.1.1/share/gtdbtk-2.1.1/db

gtdbtk classify_wf -x fna.gz --genome_dir $TMPDIR/MAGs  --out_dir $TMPDIR/gtdb-tk-out-RUG4941 --cpus 60 

cp $TMPDIR/gtdb-tk-out-RUG4941/gtdbtk.ar53.summary.tsv gtdb-tk-out-RUG4941/
cp $TMPDIR/gtdb-tk-out-RUG4941/gtdbtk.bac120.summary.tsv gtdb-tk-out-RUG4941/

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
