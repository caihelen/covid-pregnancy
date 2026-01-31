#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH --partition=week
#SBATCH --time=4-00:00:00
#SBATCH --mem=12G

module load fastp/0.23.2-GCCcore-10.2.0

INDEX=0
mapfile -t ARRAY < fnames.txt
while [ ${INDEX} -le  ${#ARRAY[*]} ]
do
	echo "${INDEX}"
	FQ1="${ARRAY[$INDEX]}"
	INDEX=$((INDEX +1))
	FQ2="${ARRAY[$INDEX]}"
	INDEX=$((INDEX +1))
	echo "${FQ1}"
	echo "${FQ2}"
	OUT1="$(echo "$FQ1" | awk '{gsub("/gpfs/gibbs/project/pattabiraman/my399/pattabiraman/covid/RNASeq_RAW/[EP0-9]+_RNAseq_R[AaWw]+/", "./fastp_outs_trimmed/"); print}')"
	OUT2="$(echo "$FQ2" | awk '{gsub("/gpfs/gibbs/project/pattabiraman/my399/pattabiraman/covid/RNASeq_RAW/[EP0-9]+_RNAseq_R[AaWw]+/", "./fastp_outs_trimmed/"); print}')"
	outdir="$(echo "$FQ2" | awk '{gsub("/gpfs/gibbs/project/pattabiraman/my399/pattabiraman/covid/RNASeq_RAW/[EP0-9]+_RNAseq_R[AaWw]+/", "./fastp_outs_trimmed/"); print}')"
	echo "${OUT1}"
	echo "${OUT2}"
	echo "Starting fastp run at $(date)"
	HTML=$(echo "$OUT2" | awk '{gsub(/R[12]_001.fastq.gz/, "fastp.html"); print}')
	echo "HTML:    ${HTML}"
	fastp -i $FQ1 -I $FQ2 -o $OUT1 -O $OUT2 -h $HTML
done

