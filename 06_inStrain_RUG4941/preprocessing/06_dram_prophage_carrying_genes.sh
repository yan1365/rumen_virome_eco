#!/bin/bash
#SBATCH --job-name=dram_gene_%j
#SBATCH --output=dram_gene_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=6:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=10 
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu


module load python/3.6-conda5.2
source activate dram

START=$SECONDS
#id=$1
#gene=prophage_rug4941_instrain.part_${id}.faa
gene=$1 # gene_under_selection.faa/coexist_prophage_gene_under_selection.faa
cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/08_inStrain_rug4941/prophage_carrying_genome_annotate #/prophage_rug4941_instrain_split

DRAM.py annotate_genes \
        -i ${gene}\
        -o  dram_anno/${gene%.faa}_anno\
        --threads 10

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS