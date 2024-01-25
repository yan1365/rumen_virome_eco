#!/bin/bash
#SBATCH --job-name=minced_%j
#SBATCH --output=minced_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=12:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

cd /fs/ess/PAS0439/MING/databases/RUG4941/MAGs_high_quality/genomes

module load python/3.6-conda5.2
source activate minced

for f in *.fna;
do minced -spacers -minNR 2 ${f}  ../minced_out/${f%.fna}


done


DURATION=$(( SECONDS - START ))
