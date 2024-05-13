#!/bin/bash


srun --cpus-per-task=2 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif flash ... \
        /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/ERR6913102_1.fastq.gz  \
        /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/ERR6913102_2.fastq.gz \
        2>&1 | tee -a /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_flash2.log