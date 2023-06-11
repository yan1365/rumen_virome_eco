#!/bin/bash
START=$SECONDS

module load python/3.6-conda5.2
source activate seqkit 

cd /fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/04_prophage_rumen_mags
seqkit split2 prophage_rumen_mags_vs2_vibrant_intersection.fa  -p 80 -O prophage_rumen_mags_vs2_vibrant_intersection_split -f

DURATION=$(( SECONDS - START ))

echo "Completed in $DURATION seconds."