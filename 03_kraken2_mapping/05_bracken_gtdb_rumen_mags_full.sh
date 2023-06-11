#!/bin/bash
#SBATCH --job-name=test_bracken_rumenmags_%j
#SBATCH --output=test_bracken_rumenmags_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=02:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=20  
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

module load python/3.6-conda5.2
source activate kraken-2.1.2

START=$SECONDS
cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/01_kraken2_mapping/gtdb207_rumenmagsfull/tmp

for f in *.report;
do bracken -d /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full -l 'G' -i ${f} -o ../bracken/${f%.report}_g.bracken -w ../bracken/${f%.report}_g.bracken_report -r 150;
bracken -d /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full -l 'S' -i ${f} -o ../bracken/${f%.report}_s.bracken -w ../bracken/${f%.report}_s.bracken_report -r 150; 
done

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS