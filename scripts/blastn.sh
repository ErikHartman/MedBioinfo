#!/bin/bash

srun --cpus-per-task=1 --time=00:30:00 singularity exec \
    /proj/applied_bioinformatics/users/x_erhar/myimage.sif seqkit sample -n 100 \
    /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/ERR6913108.flash.extendedFrags.fastq.gz \
    > /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/100_subset.fastq


srun --cpus-per-task=1 --time=00:30:00 singularity exec \
    /proj/applied_bioinformatics/users/x_erhar/myimage.sif seqkit sample -n 1000 \
    /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/ERR6913108.flash.extendedFrags.fastq.gz \
    > /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/1000_subset.fastq

srun --cpus-per-task=1 --time=00:30:00 singularity exec \
    /proj/applied_bioinformatics/users/x_erhar/myimage.sif seqkit sample -n 10000 \
    /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/ERR6913108.flash.extendedFrags.fastq.gz \
    > /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/10000_subset.fastq



srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif \
    seqkit fq2fa /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/100_subset.fastq \
    -o /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/100_subset.fasta

srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif \
    seqkit fq2fa /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/1000_subset.fastq \
    -o /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/1000_subset.fasta

srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif \
    seqkit fq2fa /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/10000_subset.fastq \
    -o /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/10000_subset.fasta