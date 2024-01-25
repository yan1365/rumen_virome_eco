#!/bin/bash
#SBATCH --job-name=blastn_%j
#SBATCH --output=blastn_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

cd /fs/ess/PAS0439/MING/databases/RUG4941

module load python/3.6-conda5.2
source activate checkv

#makeblastdb -in rvd_rug2_exclusive.fa -dbtype nucl -out rvd_rug2_blast_db/rvd_rug2_blast_db

for f in $(ls MAGs_high_quality/minced_out/*_spacers.fa);

do name=$(basename $f);
blastn -num_threads 10 -db rvd_rug2_blast_db/rvd_rug2_blast_db -query ${f} -dust no -qcov_hsp_perc 100  -outfmt 6 -evalue 1e-6 -out MAGs_high_quality/blastn_out/${name%_spacers.fa}.bln;
done




DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
