#!/bin/bash


srun --cpus-per-task=2 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif \
         xargs -a /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt \
         -I{} flash -z --threads=2 \
         --output-prefix={}.flash \
        --output-directory=/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs \
        /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/{}_1.fastq.gz  \
        /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/{}_2.fastq.gz \
        2>&1 | tee -a /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_flash2.log