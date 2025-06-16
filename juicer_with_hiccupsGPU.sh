#!/bin/bash


cd $BASE_DIR


# Paths
#JUICER_DIR=./juicer
BASE_DIR=/nfs/turbo/umms-minjilab/zapell/juicer/juicer
GENOME=mm10
REFERENCE=$BASE_DIR/references/mm10_index/mm10_no_alt_analysis_set_ENCODE.fa
CHROMSIZES=$BASE_DIR/references/mm10_no_alt.chrom.sizes_ENCSR425FOI.tsv
SITES=$BASE_DIR/restriction_sites/mm10_GATC_GANTC.txt.gz
FASTQ_DIR=$BASE_DIR/work/mm10_spermatid/LS50m
OUTPUT_DIR=$BASE_DIR/work/mm10_spermatid/LS50m/output

# Submit CPU-only Juicer steps (everything except HiCCUPS)
cpu_jobid=$(sbatch --parsable <<'EOF'
#!/bin/bash
#SBATCH --job-name=LS50m_juicer
#SBATCH --account=hammou0
#SBATCH --partition=standard
#SBATCH --cpus-per-task=24
#SBATCH --output=output/ls50mjuicer_%j.out
#SBATCH --error=error/ls50mjuicer_%j.err
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --profile=Task

my_job_header

module load Bioinformatics
module load bwa
module load samtools



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
    -L "8:00:00" \
    -Q "5:00:00" \
    -S final \
    -e final
EOF
)

echo "Submitted CPU job as $cpu_jobid"

# Submit GPU HiCCUPS step, dependent on CPU job finishing successfully
sbatch --dependency=afterok:$cpu_jobid <<'EOF'
#!/bin/bash
#SBATCH --job-name=juicer_hiccups_gpu
#SBATCH --output=hiccups_gpu_%j.out
#SBATCH --error=hiccups_gpu_%j.err
#SBATCH --partition=gpu
#SBATCH --gpus=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=8:00:00
#SBATCH --account=hammou0
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL

module load cuda/11.8.0
module load java

# Run HiCCUPS on GPU
${juiceDir}/scripts/juicer_hiccups.sh -j ${juiceDir}/scripts/juicer_tools -i $outputdir/inter_30.hic \
 -g $GENOME \
 -m 512 \
-c (all chromosomes) \
-r 5000,10000,25000 \
-k SCALE \ 
-f .1,.1,.1 \
-p 4,2,1 \
-i 7,5,3 \
-t 0.02,1.5,1.75,2 \
-d 20000,20000,50000 \
EOF