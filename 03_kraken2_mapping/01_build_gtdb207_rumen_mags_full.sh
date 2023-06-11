#!/bin/bash
#SBATCH --job-name=build_kraken2_rumen_magsfull_%j
#SBATCH --output=build_kraken2_rumen_magsfull_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40 --partition=largemem
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

module load python/3.6-conda5.2
source activate kraken-2.1.2

START=$SECONDS

#cd /fs/scratch/PAS0439/Ming/databases/rumen_mags_high_quality/dereplicated_genomes_with_taxid

#for f in $(ls *.fasta);
#do kraken2-build --add-to-library ${f} --threads 40 --db /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full;
#done 

#cd /fs/scratch/PAS0439/Ming/databases/gtdb_R207_repre_genomes/genomes_add_taxid
#for f in *.fna;
#do kraken2-build --add-to-library ${f} --threads 40 --db /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full;
#done 

# cp /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_7176/taxonomy /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full/taxonomy
kraken2-build --build --threads 40 --db /fs/scratch/PAS0439/Ming/databases/kraken2_gtdb207_rumen_mags_full


DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS