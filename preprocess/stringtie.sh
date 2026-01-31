#!/bin/bash

#SBATCH --job-name=stringt
#SBATCH --partition=week
#SBATCH --time=4-00:00:00
#SBATCH --mem=90G

module load StringTie/2.1.4-GCCcore-10.2.0

find . -name '*sorted*.bam' > fnames_sorted.txt

INDEX=0
mapfile -t ARRAY < fnames_sorted.txt
while [ ${INDEX} -le  ${#ARRAY[*]} ]
do
	echo "${INDEX}"
	INBAM="${ARRAY[$INDEX]}"
	INDEX=$((INDEX +1))
	echo "${INBAM}"

	REF="/gpfs/gibbs/pi/ycga/mane/ycga_bioinfo/genomes/mm39/annotation/mm39rnaseq"
	source $REF

	OUTGTF=${INBAM//.bam/.gtf}
	echo "GTF output:        ${OUTGTF}"

	OUTTAB=${INBAM//.bam/_gene_abund.tab}
	echo "Tab output:        ${OUTTAB}"

	echo "Starting Stringtie annotation at $(date)"
	stringtie -e -B -G $GTF -o $OUTGTF -A $OUTTAB $INBAM
	
done
