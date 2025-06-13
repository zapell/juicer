#!/bin/bash
#SBATCH --job-name=juicer_stats
#SBATCH --account=hammou0
#SBATCH --mail-user=zapell@umich.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --profile=Task
#SBATCH --output=stats_%j.out
#SBATCH --error=stats_%j.err
#SBATCH --partition=standard
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=2:00:00

perl SLURM/scripts/statistics.pl -q 30 \
  -o work/mm10_spermatid/ES50m/aligned/inter_NEW.txt \
  -s restriction_sites/mm10_GATC_GANTC.txt.gz \
  -l '(GAATAATC|GAATACTC|GAATAGTC|GAATATTC|GAATGATC|GACTAATC|GACTACTC|GACTAGTC|GACTATTC|GACTGATC|GAGTAATC|GAGTACTC|GAGTAGTC|GAGTATTC|GAGTGATC|GATCAATC|GATCACTC|GATCAGTC|GATCATTC|GATCGATC|GATTAATC|GATTACTC|GATTAGTC|GATTATTC|GATTGATC)' \
  work/mm10_spermatid/ES50m/aligned/merged1.txt