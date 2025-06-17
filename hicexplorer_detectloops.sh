#!/bin/bash
#SBATCH --job-name=LS50m_hicexplorer_loops
#SBATCH --account=hammou0
#SBATCH --partition=standard
#SBATCH --cpus-per-task=4
#SBATCH --output=output/LS50m_hicexplorer_loops_%j.out
#SBATCH --error=error/LS50m_hicexplorer_loops_%j.err
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=10G
#SBATCH --time=10:00:00
#SBATCH --profile=Task

BASE_DIR=/nfs/turbo/umms-minjilab/zapell/juicer/juicer/work/mm10_spermatid/LS50m/aligned

#hicConvertFormat -m $BASE_DIR/inter_30.hic --inputFormat hic --outputFormat cool -o $BASE_DIR/inter_30_10kb.cool --resolutions 10000
hic2cool convert $BASE_DIR/inter_30.hic $BASE_DIR/inter_30_10kb.cool -r 10000

hicDetectLoops \
    --matrix $BASE_DIR/inter_30_10kb.cool \
    --outFileName $BASE_DIR/inter_30_loops.bedGraph