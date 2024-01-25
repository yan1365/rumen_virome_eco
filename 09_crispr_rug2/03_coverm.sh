#!/bin/bash
#SBATCH --job-name=coverm
#SBATCH --output=coverm.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=6:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

module load python/3.6-conda5.2
source activate /users/PAS1855/yan1365/miniconda3/envs/coverm-0.6.1

cd /fs/scratch/PAS0439/Ming/RUG2_clean_reads

sample_list_id=$1
sample_list=sample_list_${sample_list_id}.txt

for f in $(cat $sample_list);
do coverm genome -m covered_fraction --coupled ${f} ${f%_1.fastq.gz}_2.fastq.gz --genome-fasta-directory /fs/ess/PAS0439/MING/databases/RUG4941/MAGs_high_quality/genomes  --bam-file-cache-directory $TMPDIR --discard-unmapped -t 20 > /fs/ess/PAS0439/MING/databases/RUG4941/MAGs_high_quality/co_exist_genome/${f%_1.fastq.gz}.txt
done

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
