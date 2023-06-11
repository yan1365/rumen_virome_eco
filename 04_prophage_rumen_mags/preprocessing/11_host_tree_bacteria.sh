#!/bin/bash
#SBATCH --job-name=iqtree_bacteria_host_%j
#SBATCH --output=iqtree_bacteria_host_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=18:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

START=$SECONDS

cd  /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags/prophage_host_tree/bacteria-host-gtdb-tk-out/align/backup48

module load python/3.6-conda5.2
source activate /fs/ess/PAS0439/MING/conda/iqtree

iqtree -nt 40 -s gtdbtk.bac120.user_msa.fasta -redo -bb 1000 -m MFP -mset WAG,LG,JTT,Dayhoff -mrate E,I,G,I+G -mfreq FU -wbtl 
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
