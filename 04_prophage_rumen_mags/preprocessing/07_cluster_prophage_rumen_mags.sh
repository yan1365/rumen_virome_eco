#!/bin/bash
#SBATCH --job-name=prophage_rumen_mags_votu_%j
#SBATCH --output=prophage_rumen_mags_votu_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=04:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS

module load python/3.6-conda5.2
source activate checkv 

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags

makeblastdb -in prophage_rumen_mags_category2.fasta -dbtype nucl -out myblast_db
blastn -query prophage_rumen_mags_category2.fasta  -db myblast_db -outfmt '6 std qlen slen' -max_target_seqs 10000 -out myblast_db.tsv -num_threads 10
python /fs/ess/PAS0439/MING/virome/checkv_trimmed_for_dowmstream/scripts/cluster_genome/anicalc.py -i myblast_db.tsv -o my_ani.tsv
python /fs/ess/PAS0439/MING/virome/checkv_trimmed_for_dowmstream/scripts/cluster_genome/aniclust.py --fna prophage_rumen_mags_category2.fasta --ani my_ani.tsv --out my_clusters.tsv --min_ani 95 --min_tcov 85 --min_qcov 0


DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS