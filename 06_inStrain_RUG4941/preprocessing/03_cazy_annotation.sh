#!/bin/bash
#SBATCH --job-name=dbcan_diet_%j
#SBATCH --output=dbcan_diet_%j.out
# Walltime Limit: hh:mm:ss 
#SBATCH --time=128:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --account=PAS0439
#SBATCH --mail-type=ALL
#SBATCH --mail-user=yan1365,yan.1365@osu.edu

START=$SECONDS

cd  /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/08_inStrain_rug4941

module load python/3.6-conda5.2
source activate instrain 
#hmmpress /fs/ess/PAS0439/MING/databases/dbcan/dbCAN-HMMdb-V11.txt

hmmscan --domtblout repre_genomes_instrain.genes.faa_vs_dbCAN_v11.dm /fs/ess/PAS0439/MING/databases/dbcan/dbCAN-HMMdb-V11.txt repre_genomes_instrain.genes.faa > /dev/null ;
sh /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/scripts/07_inStrain/hmmscan-parser.sh repre_genomes_instrain.genes.faa_vs_dbCAN_v11.dm > repre_genomes_instrain.genes.faa_vs_dbCAN_v11.dm.ps ; cat repre_genomes_instrain.genes.faa_vs_dbCAN_v11.dm.ps | awk '$5<1e-15&&$10>0.35' > repre_genomes_instrain.genes.faa_vs_dbCAN_v11.dm.ps.stringent
DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."
