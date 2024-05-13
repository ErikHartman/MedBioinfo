#!/bin/bash

echo "script start: download and initial sequencing read quality control"
date

sqlite3 -batch /proj/applied_bioinformatics/common_data/sample_collab.db "select * from sample2bioinformatician;"

sqlite3 -batch -noheader -csv /proj/applied_bioinformatics/common_data/sample_collab.db "select run_accession from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='x_erhar';" > /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt

#split the reads in two files (paired end forward and reverse reads)
#while you are experimenting, you may want to start with just one single run accession ID, as well as add the -X 10 option in order to just download the first 10 reads. This is fast enough to authorise not going through SLRUM srun for such a miniature test command
#check how the downloaded files have been named in ./data/sra_fastq, and because we only downloaded the first 10 reads, we can even do zcat ./data/sra_fastq/your_fastq_file_names
#you should have two files per accession identifier, because paired end Illumina sequencing usually produce distinct forward and a reverse read files

singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif fastq-dump ERR6913102 --disable-multithreading --gzip --split-files --readids --outdir /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/ -X 10

echo "... running singularity fastq-dump with slurm ..."
cat /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt | srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs fastq-dump --disable-multithreading --gzip --split-files --readids --outdir /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/

date

echo "script end."