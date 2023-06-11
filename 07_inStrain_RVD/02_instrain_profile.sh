#!/bin/bash
#SBATCH --job-name=instrain_profile_%j
#SBATCH --output=instrain_profile_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --mail-type=ALL
#SBATCH --account=PAS0439

START=$SECONDS
module load python/3.6-conda5.2
source activate bowtie2-2.4.4

id=$1
#sample_list=sample_list_${id}.txt
sample_list=more_${id}.txt
for sample in $(cat ${sample_list});
do cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/09_inStrain_RVD
source activate bowtie2-2.4.4

echo ${sample}
cp /fs/scratch/PAS0439/Ming/975_clean_reads/${sample} $TMPDIR/
cp /fs/scratch/PAS0439/Ming/975_clean_reads/${sample%_1.fastq.gz}_2.fastq.gz $TMPDIR/
cp -R bt2/ $TMPDIR/

bowtie2 -p 12 -x $TMPDIR/bt2/rvd.bt2 -1  $TMPDIR/${sample} -2 $TMPDIR/${sample%_1.fastq.gz}_2.fastq.gz > $TMPDIR/${sample%_1.fastq.gz}.sam

conda deactivate

source activate samtools-1.13 
samtools view -S -b $TMPDIR/${sample%_1.fastq.gz}.sam > $TMPDIR/${sample%_1.fastq.gz}.bam

conda deactivate 

source activate instrain
inStrain profile $TMPDIR/${sample%_1.fastq.gz}.bam /fs/ess/PAS0439/MING/virome/checkv_trimmed_for_dowmstream/RVD_resources/RVD.fa -o $TMPDIR/${sample%_1.fastq.gz}.profile -p 12 -g  RVD.fna -s genomes.stb --database_mode --skip_plot_generation


cp -R $TMPDIR/${sample%_1.fastq.gz}.profile instrain_profiles/
conda deactivate 
done
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
sacct -j $SLURM_JOB_ID -o JobID,AllocTRES%50,Elapsed,CPUTime,TresUsageInTot,MaxRSS