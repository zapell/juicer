#!/bin/bash
#SBATCH --job-name=LS_juicer_full_std
#SBATCH --account=hammou0
#SBATCH --partition=largemem
#SBATCH --cpus-per-task=36
#SBATCH --output=output/lsfull_juicer_std_%j.out
#SBATCH --error=error/lsfull_juicer_std_%j.err
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=1000G
#SBATCH --time=96:00:00
#SBATCH --profile=Task

my_job_header

module load Bioinformatics
module load bwa
module load samtools


cd $BASE_DIR


# Paths
#JUICER_DIR=./juicer
BASE_DIR=/nfs/turbo/umms-minjilab/zapell/juicer/juicer
GENOME=mm10
REFERENCE=$BASE_DIR/references/mm10_index/mm10_no_alt_analysis_set_ENCODE.fa
CHROMSIZES=$BASE_DIR/references/mm10_no_alt.chrom.sizes_ENCSR425FOI.tsv
SITES=$BASE_DIR/restriction_sites/mm10_GATC_GANTC.txt.gz
FASTQ_DIR=$BASE_DIR/work/mm10_spermatid/LS_full
OUTPUT_DIR=$BASE_DIR/work/mm10_spermatid/LS_full/output


#export USE_CP="1"

# Run Juicer
bash $BASE_DIR/scripts/juicer.sh \
    -g $GENOME \
    -z $REFERENCE \
    -p $CHROMSIZES \
    -y $SITES \
    -D $BASE_DIR \
    -t 36 \
    -T 36 \
    -d $FASTQ_DIR \
    -q standard \
    -l largemem \
    -A "hammou0" \
    -L "72:00:00" \
    -Q "10:00:00" 

