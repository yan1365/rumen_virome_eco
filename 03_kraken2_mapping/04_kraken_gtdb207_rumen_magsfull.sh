#!/bin/bash
#SBATCH --job-name=k2_benchmark_gtdb207_rumenmagsfull_%j
#SBATCH --output=k2_benchmark_gtdb207_rumenmagsfull_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=8:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20  --partition=largemem
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu
#SBATCH --mem=377gb

module load python/3.6-conda5.2
source activate kraken-2.1.2

START=$SECONDS

part=$1  ##01 to 60 
echo ${part}

file=kraken_${part}.txt
for f in $(cat ${file});
do echo ${f}; 
kraken2 --paired /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/clean_reads/${f}  /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/clean_reads/${f%_1.fq.gz}_2.fq.gz --db /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full   --threads 20  --output /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/01_kraken2_mapping/gtdb207_rumenmagsfull/tmp/${f%_1.fq.gz}.out  --report /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/01_kraken2_mapping/gtdb207_rumenmagsfull/tmp/${f%_1.fq.gz}.report
done


DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS