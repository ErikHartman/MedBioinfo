#!/bin/bash
#
#SBATCH --ntasks=1                   # nb of *tasks* to be run in // (usually 1), this task can be multithreaded (see cpus-per-task)
#SBATCH --nodes=1                    # nb of nodes to reserve for each task (usually 1)
#SBATCH --cpus-per-task=4            # nb of cpu (in fact cores) to reserve for each task /!\ job killed if commands below use more cores
#SBATCH --mem=90GB                  # amount of RAM to reserve for the tasks /!\ job killed if commands below use more RAM
#SBATCH --time=0-01:00               # maximal wall clock duration (D-HH:MM) /!\ job killed if commands below take more time than reservation
#SBATCH -o ./data/slurm_out/slurm.%A.%a.out   # standard output (STDOUT) redirected to these files (with Job ID and array ID in file names)
#SBATCH -e ./data/slurm_out/slurm.%A.%a.err   # standard error  (STDERR) redirected to these files (with Job ID and array ID in file names)
# /!\ Note that the ./outputs/ dir above needs to exist in the dir where script is submitted **prior** to submitting this script

kraken_db="/proj/applied_bioinformatics/common_data/kraken_database/"
kraken_img="/proj/applied_bioinformatics/common_data/kraken2.sif"
data_1="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/ERR6913189.flash.notCombined_1.fastq.gz"
data_2="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs/ERR6913189.flash.notCombined_2.fastq.gz"

srun --cpus-per-task=1 --time=00:60:00 --job-name=kraken2 \
    singularity exec -B /proj:/proj $kraken_img kraken2 --db $kraken_db \
    --threads 1 --use-mpa-style --paired --gzip-compressed \
    --report /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/kraken2/report.txt \
    --output /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/kraken2/analysis.txt \
    $data_1 $data_2
