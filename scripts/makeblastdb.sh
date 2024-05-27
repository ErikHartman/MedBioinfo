#!/bin/bash

find /proj/applied_bioinformatics/common_data/refseq_viral_split -name '*.gz' -print0 | srun xargs -0 zcat | \
     srun --cpus-per-task=2 --time=00:30:00 \
     /proj/applied_bioinformatics/tools/ncbi-blast-2.15.0+-src/makeblastdb -dbtype nucl \
    -out /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blast_db/refseq_viral_genomic \
    -title blastn_data 

