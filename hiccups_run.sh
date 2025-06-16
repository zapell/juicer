#!/bin/bash
#SBATCH --job-name=juicer_hiccups_cpu
#SBATCH --output=output/hiccups_cpu_%j.out
#SBATCH --error=error/hiccups_cpu_%j.err
#SBATCH --partition=standard
#SBATCH --cpus-per-task=8
#SBATCH --mem=72G
#SBATCH --time=8:00:00
#SBATCH --account=hammou0
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL

#module load cuda/12.8
#nvidia-smi

# to use gpu uncomment above, set partition to gpu, add in #SBBATCH --gpus=1, and remove --cpu from the java command below

BASE_DIR=/nfs/turbo/umms-minjilab/zapell/juicer/juicer
GENOME=mm10
OUTPUT_DIR=$BASE_DIR/work/mm10_spermatid/LS50m/aligned

# Run HiCCUPS on GPU
java -jar ${BASE_DIR}/scripts/juicer_tools.jar hiccups -m 512 \
--cpu \
--threads 8 \
-r 5000,10000,25000 \
-k SCALE \
-f .1,.1,.1 \
-p 4,2,1 \
-i 7,5,3 \
-t 0.02,1.5,1.75,2 \
-d 20000,20000,50000 \
 $OUTPUT_DIR/inter_30.hic $OUTPUT_DIR/hiccups_output