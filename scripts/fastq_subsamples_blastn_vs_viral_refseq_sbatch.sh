#!/bin/bash
#
#SBATCH --partition=fast             # long, fast, etc.
#SBATCH --ntasks=1                   # nb of *tasks* to be run in // (usually 1), this task can be multithreaded (see cpus-per-task)
#SBATCH --nodes=1                    # nb of nodes to reserve for each task (usually 1)
#SBATCH --cpus-per-task=4            # nb of cpu (in fact cores) to reserve for each task /!\ job killed if commands below use more cores
#SBATCH --mem=250GB                  # amount of RAM to reserve for the tasks /!\ job killed if commands below use more RAM
#SBATCH --time=0-02:00               # maximal wall clock duration (D-HH:MM) /!\ job killed if commands below take more time than reservation
#SBATCH -o ./outputs/slurm.%A.%a.out   # standard output (STDOUT) redirected to these files (with Job ID and array ID in file names)
#SBATCH -e ./outputs/slurm.%A.%a.err   # standard error  (STDERR) redirected to these files (with Job ID and array ID in file names)
# /!\ Note that the ./outputs/ dir above needs to exist in the dir where script is submitted **prior** to submitting this script
#SBATCH --array=1-100                # 1-N: clone this script in an array of N tasks: $SLURM_ARRAY_TASK_ID will take the value of 1,2,...,N
#SBATCH --job-name=MedBioinfo        # name of the task as displayed in squeue & sacc, also encouraged as srun optional parameter
#SBATCH --mail-type END              # when to send an email notiification (END = when the whole sbatch array is finished)
#SBATCH --mail-user me@geemail.com


srun /proj/applied_bioinformatics/tools/ncbi-blast-2.15.0+-src/blastn \
     -query /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/100_subset.fasta \
     -db /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blast_db/refseq_viral_genomic \
     -out /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blastn_searches/100.out -evalue 1e-5 \
     -num_threads 1 \
     -outfmt 6 \

srun /proj/applied_bioinformatics/tools/ncbi-blast-2.15.0+-src/blastn \
     -query /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/1000_subset.fasta \
     -db /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blast_db/refseq_viral_genomic \
     -out /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blastn_searches/1000.out -evalue 1e-5 \
     -num_threads 1 \
     -outfmt 6 \

srun /proj/applied_bioinformatics/tools/ncbi-blast-2.15.0+-src/blastn \
     -query /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/10000_subset.fasta \
     -db /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blast_db/refseq_viral_genomic \
     -out /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blastn_searches/10000.out -evalue 1e-5 \
     -num_threads 1 \
     -outfmt 6 \


