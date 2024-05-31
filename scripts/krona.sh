#!/bin/bash
#
#SBATCH --ntasks=1                   # nb of *tasks* to be run in // (usually 1), this task can be multithreaded (see cpus-per-task)
#SBATCH --nodes=1                    # nb of nodes to reserve for each task (usually 1)
#SBATCH --cpus-per-task=4            # nb of cpu (in fact cores) to reserve for each task /!\ job killed if commands below use more cores
#SBATCH --mem=90GB                  # amount of RAM to reserve for the tasks /!\ job killed if commands below use more RAM
#SBATCH --time=0-01:00               # maximal wall clock duration (D-HH:MM) /!\ job killed if commands below take more time than reservation
#SBATCH -o ./data/slurm_out/slurm.%A.%a.out   # standard output (STDOUT) redirected to these files (with Job ID and array ID in file names)
#SBATCH -e ./data/slurm_out/slurm.%A.%a.err   # standard error  (STDERR) redirected to these files (with Job ID and array ID in file names)
#SBATCH --array=1-14    

# /!\ Note that the ./outputs/ dir above needs to exist in the dir where script is submitted **prior** to submitting this script


kraken_img="/proj/applied_bioinformatics/common_data/kraken2.sif"

workdir="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo"
datadir="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/kraken2"
accnum_file="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt"

echo START: `date`

accnum=$(sed -n "$SLURM_ARRAY_TASK_ID"p ${accnum_file})

data="${datadir}/${accnum}_bracken_report.txt"
krona_output="${workdir}/analyses/krona/${accnum}_krona.txt"
html_output="${workdir}/analyses/krona/${accnum}_krona.html"

python /proj/applied_bioinformatics/tools/KrakenTools/kreport2krona.py \
    -r $data \
    -o $krona_output

sed -i -E 's/\b[scogfkp]\__//g' $krona_output


singularity exec $kraken_img ktImportText $krona_output \
    -o $html_output