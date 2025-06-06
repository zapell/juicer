#!/bin/bash
#SBATCH --job-name=ES50m_juicer
#SBATCH --account=hammou0
#SBATCH --partition=standard
#SBATCH --cpus-per-task=24
#SBATCH --output=output/es50mjuicer_%j.out
#SBATCH --error=error/es50mjuicer_%j.err
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=64G
#SBATCH --time=12:00:00
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
FASTQ_DIR=$BASE_DIR/work/mm10_spermatid/ES50m
OUTPUT_DIR=$BASE_DIR/work/mm10_spermatid/ES50m/output


#export USE_CP="1"

# Run Juicer
bash $BASE_DIR/scripts/juicer.sh \
    -g $GENOME \
    -z $REFERENCE \
    -p $CHROMSIZES \
    -y $SITES \
    -D $BASE_DIR \
    -t 24 \
    -d $FASTQ_DIR \
    -q standard \
    -l standard \
    -A "hammou0" \
    -L "5:00:00" \
    -Q "5:00:00"

