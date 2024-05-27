#!/bin/bash

# I had separated the scripts. Here they have been merged for hand-in.

# x_erhar_read_QC.sh
sqlite3 -batch /proj/applied_bioinformatics/common_data/sample_collab.db "select * from sample2bioinformatician;"

sqlite3 -batch -noheader -csv /proj/applied_bioinformatics/common_data/sample_collab.db "select run_accession from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='x_erhar';" > /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt

singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif fastq-dump ERR6913102 --disable-multithreading --gzip --split-files --readids --outdir /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/ -X 10

echo "... running singularity fastq-dump with slurm ..."
cat /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt | srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs fastq-dump --disable-multithreading --gzip --split-files --readids --outdir /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/


# x_erhar_seqkit_script.sh
ls /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/*.fastq.gz | srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs seqkit stats --threads 1 

ls /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/*.fastq.gz | srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs seqkit stats --unique --threads 1 

# x_erhar_fastqc.sh
srun --cpus-per-task=2 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs -I{} -a /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt fastqc /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/{}_1.fastq.gz /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/{}_2.fastq.gz -o /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/fastqc --noextract 

# x_erhar_merging_paired.sh
srun --cpus-per-task=2 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif \
         xargs -a /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt \
         -I{} flash -z --threads=2 \
         --output-prefix={}.flash \
        --output-directory=/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs \
        /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/{}_1.fastq.gz  \
        /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/{}_2.fastq.gz \
        2>&1 | tee -a /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_flash2.log

# x_erhar_merging_bowtie.sh
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

