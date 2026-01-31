#!/bin/bash

#SBATCH --job-name=align
#SBATCH --partition=long
#SBATCH --time=14-00:00:00
#SBATCH --mem=32G

module load Salmon/1.4.0-gompi-2020b

INDEX=0
mapfile -t ARRAY < fnames.txt
while [ ${INDEX} -le  ${#ARRAY[*]} ]
do
	echo "${INDEX}"
	OUT1="${ARRAY[$INDEX]}"
	INDEX=$((INDEX +1))
	OUT2="${ARRAY[$INDEX]}"
	INDEX=$((INDEX +1))
	OUT1="$(echo "$OUT1" | awk '{gsub("/gpfs/gibbs/project/pattabiraman/my399/pattabiraman/covid/RNASeq_RAW/[EP0-9]+_RNAseq_R[AaWw]+/", "./fastp_outs_trimmed/"); print}')"
        OUT2="$(echo "$OUT2" | awk '{gsub("/gpfs/gibbs/project/pattabiraman/my399/pattabiraman/covid/RNASeq_RAW/[EP0-9]+_RNAseq_R[AaWw]+/", "./fastp_outs_trimmed/"); print}')"
	echo "${OUT1}"
	echo "${OUT2}"
	REF="/gpfs/gibbs/pi/ycga/mane/ycga_bioinfo/genomes/mm39/annotation/mm39rnaseq"
	source $REF
	OUTDIR="$(echo "$OUT2" | awk '{gsub("fastp_outs_trimmed", "salmon_outs"); print}')"
	OUTDIR="$(echo "$OUTDIR" | awk '{gsub("[A-Z_0-9]+.fastq.gz", ""); print}')"
	echo "OUTDIR: 	${OUTDIR}"
	echo "Starting alignment run at $(date)"
	salmon quant -i /home/hsc26/pi_pattabiraman/project/salmon_refs/GRCm39_salmon_index --libType A --gcBias -1 $OUT1 -2 $OUT2 --validateMappings -o $OUTDIR	
done

