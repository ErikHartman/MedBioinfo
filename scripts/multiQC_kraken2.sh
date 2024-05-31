

srun singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif \
    multiqc --force --title "x_erhar all kraken2" \
    ./data/merged_pairs/ ./analyses/fastqc/ ./analyses/x_erhar_flash2.log ./analyses/bowtie/ ./analyses/kraken2/
