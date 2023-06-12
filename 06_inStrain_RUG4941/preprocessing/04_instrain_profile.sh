#!/bin/bash
#SBATCH --job-name=instrain_profile_%j
#SBATCH --output=instrain_profile_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40 --partition=largemem
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS
module load python/3.6-conda5.2
source activate bowtie2-2.4.4

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/08_inStrain_rug4941


sample=$1
echo ${sample}
cp /fs/scratch/PAS0439/Ming/975_clean_reads/${sample} $TMPDIR/
cp /fs/scratch/PAS0439/Ming/975_clean_reads/${sample%_1.fastq.gz}_2.fastq.gz $TMPDIR/
cp -R bt2/ $TMPDIR/

bowtie2 -p 40 -x $TMPDIR/bt2/repre_genomes_instrain.bt2 -1  $TMPDIR/${sample} -2 $TMPDIR/${sample%_1.fastq.gz}_2.fastq.gz > $TMPDIR/${sample%_1.fastq.gz}.sam

conda deactivate

source activate samtools-1.13 
samtools view -S -b $TMPDIR/${sample%_1.fastq.gz}.sam > $TMPDIR/${sample%_1.fastq.gz}.bam

conda deactivate 

source activate instrain
inStrain profile $TMPDIR/${sample%_1.fastq.gz}.bam rug_hunage_rumnemamgs_drep98.fasta -o $TMPDIR/${sample%_1.fastq.gz}.profile -p 40 -g  repre_genomes_instrain.genes.fna -s genomes.stb --database_mode

cp -R $TMPDIR/${sample%_1.fastq.gz}.profile instrain_profiles/
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS