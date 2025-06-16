#!/bin/bash
#SBATCH --job-name=LS50m_compartment
#SBATCH --account=hammou0
#SBATCH --partition=standard
#SBATCH --cpus-per-task=2
#SBATCH --output=output/ls50m_compartment_%j.out
#SBATCH --error=error/ls50m_compartment_%j.err
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=10G
#SBATCH --time=0:30:00
#SBATCH --profile=Task

# === CONFIGURATION ===
BASE_DIR=/nfs/turbo/umms-minjilab/zapell/juicer/juicer
GENOME=mm10
OUTDIR=$BASE_DIR/work/mm10_spermatid/LS50m/aligned/compartments_mm10_annot
JUICER_TOOLS=$BASE_DIR/scripts/juicer_tools.jar   # <-- Set path to juicer_tools.jar
HIC_FILE=$BASE_DIR//work/mm10_spermatid/LS50m/aligned/inter_30.hic                        # <-- Your .hic file
NORM=VC                                   # Normalization: KR, VC, NONE
RES=500000                               # Resolution in bp

mkdir -p "$OUTDIR"
# === mm10 chromosomes ===
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 X Y)

echo "$HIC_FILE"
echo $HIC_FILE

# === Loop and generate compartment annotations ===
for chr in "${chroms[@]}"; do
    echo "Processing chr$chr..."


  # Step 1: Run eigenvector
    java -Xmx8g -jar "$JUICER_TOOLS" eigenvector "$NORM" "$HIC_FILE" chr$chr BP "$RES" "$OUTDIR/chr${chr}_pc1_raw.txt"

  # Step 2: Convert to bedGraph format for Juicebox
    awk -v chr=chr$chr -v res=$RES '{
    start = (NR - 1) * res;
    end = start + res;
    if ($1 != "NaN") print chr"\t"start"\t"end"\t"$1;
    }' "$OUTDIR/chr${chr}_pc1_raw.txt" >> "$OUTDIR/compartments_pc1.bedGraph"

  # Optional: Remove raw PC1 file
#  rm "$OUTDIR/chr${chr}_pc1_raw.txt"
done

echo "✅ All Juicebox-compatible compartment annotation files saved in: $OUTDIR"
