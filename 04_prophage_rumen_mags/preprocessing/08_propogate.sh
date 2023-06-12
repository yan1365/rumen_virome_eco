#!/bin/bash
#SBATCH --job-name=propogate_%j
#SBATCH --output=propogate_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=8:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu


START=$SECONDS
module load python/3.6-conda5.2
source activate propagate 

id=${1}
file=rug4941_rumen_mags_propogate${id}.txt

for f in $(cat ${file});
do cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags;
Propagate -f rug_hungate_prophage_scaffolds_for_propogate.fasta -r /fs/scratch/PAS0439/Ming/975_clean_reads/${f} /fs/scratch/PAS0439/Ming/975_clean_reads/${f%_1.fastq.gz}_2.fastq.gz -v prophage_rug_hungate_scaffold_coordinates_for_propogate.tsv -o propogate_out/${f%_1.fastq.gz} --clean -t 10
done
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS
