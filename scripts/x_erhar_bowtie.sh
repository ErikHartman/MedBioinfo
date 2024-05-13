#!/bin/bash


srun --cpus-per-task=8 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif bowtie2 -x \
    /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/bowtie2_DBs/PhiX_bowtie2_DB \
    -U ./data/merged_pairs/ERR*.extendedFrags.fastq.gz -S /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/bowtie/x_erhar_merged2PhiX.sam \
    --threads 8 --no-unal \
    2>&1 | tee /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/bowtie/x_erhar_bowtie_merged2PhiX.log

srun --cpus-per-task=8 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif bowtie2 -x \
    /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/bowtie2_DBs/SC2_bowtie2_DB \
    -U ./data/merged_pairs/ERR*.extendedFrags.fastq.gz -S /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/bowtie/x_erhar_merged2SC2.sam \
    --threads 8 --no-unal \
    2>&1 | tee /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/bowtie/x_erhar_bowtie_merged2SC2.log