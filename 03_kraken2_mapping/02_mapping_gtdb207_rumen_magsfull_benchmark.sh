#!/bin/bash
#SBATCH --job-name=k2_benchmark_gtdb207_rumenmagsfull_%j
#SBATCH --output=k2_benchmark_gtdb207_rumenmagsfull_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24 --partition=largemem
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

module load python/3.6-conda5.2
source activate kraken-2.1.2

START=$SECONDS

cd /fs/scratch/PAS0439/Ming/virome_res/reads_for_mapping_rate_comparison/clean_reads

part=$1  ##01 to 10 
## Reads derived from the study "Investigation of fiber utilization in the rumen of dairy cows based on metagenome-assembled genomes and single-cell RNA sequencing"

file=${part}_kraken2_reads_mapping_benchmark.txt 
for f in $(cat ${file});
do echo ${f}; 
kraken2 --paired ${f}  ${f%_1.fastq_clean.gz}_2.fastq_clean.gz --db /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full   --threads 24  --output /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/01_kraken2_mapping/gtdb207_rumenmagsfull/benchmark/${f%_1.fastq_clean.gz}.out  --report /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/01_kraken2_mapping/gtdb207_rumenmagsfull/benchmark/${f%_1.fastq_clean.gz}.report
done


DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS