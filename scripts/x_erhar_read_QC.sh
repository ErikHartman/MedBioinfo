#!/bin/bash

echo "script start: download and initial sequencing read quality control"
date

sqlite3 -batch /proj/applied_bioinformatics/common_data/sample_collab.db "select * from sample2bioinformatician;"

sqlite3 -batch -noheader -csv /proj/applied_bioinformatics/common_data/sample_collab.db "select run_accession from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='x_erhar';" > /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt

singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif fastq-dump ERR6913102 --disable-multithreading --gzip --split-files --readids --outdir /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/ -X 10

echo "... running singularity fastq-dump with slurm ..."
cat /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt | srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs fastq-dump --disable-multithreading --gzip --split-files --readids --outdir /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/

date

echo "script end."