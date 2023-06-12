#!/bin/bash
#SBATCH --job-name=virsorter2_%j
#SBATCH --output=virsorter2_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439



### load vs2 environment before submiting the job due to a module load error

START=$SECONDS
id=${1}
sample_list=rug4941_rumen_mags_${id}.txt   
echo -e "processing sample list ${id}\n"
for sample in $(cat ${sample_list});
do echo "processing sample ${sample}";

### If you prefer the full sequences (ending with ||full) not to be trimmed and leave it to specialized tools such as checkV, you can use --keep-original-seq option.
virsorter run --keep-original-seq -i /fs/scratch/PAS0439/Ming/databases/RUG4941_rumen_mags_hungate_high_quality/MAGs/${sample}   \
-w /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/vs2_pass1/${sample%.fasta} --include-groups dsDNAphage,ssDNA --min-length 5000 --min-score 0.5 -j 40 all

done

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS