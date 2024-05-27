#!/bin/bash
#
#SBATCH --ntasks=1                   # nb of *tasks* to be run in // (usually 1), this task can be multithreaded (see cpus-per-task)
#SBATCH --nodes=1                    # nb of nodes to reserve for each task (usually 1)
#SBATCH --cpus-per-task=4            # nb of cpu (in fact cores) to reserve for each task /!\ job killed if commands below use more cores
#SBATCH --mem=250GB                  # amount of RAM to reserve for the tasks /!\ job killed if commands below use more RAM
#SBATCH --time=0-02:00               # maximal wall clock duration (D-HH:MM) /!\ job killed if commands below take more time than reservation
#SBATCH -o ./outputs/slurm.%A.%a.out   # standard output (STDOUT) redirected to these files (with Job ID and array ID in file names)
#SBATCH -e ./outputs/slurm.%A.%a.err   # standard error  (STDERR) redirected to these files (with Job ID and array ID in file names)
# /!\ Note that the ./outputs/ dir above needs to exist in the dir where script is submitted **prior** to submitting this script
#SBATCH --array=1-2                # 1-N: clone this script in an array of N tasks: $SLURM_ARRAY_TASK_ID will take the value of 1,2,...,N
#SBATCH --mail-type END              # when to send an email notiification (END = when the whole sbatch array is finished)
#SBATCH --mail-user erik.hartman@med.lu.se

#################################################################
# Preparing work (cd to working dir, get hold of input data, convert/un-compress input data when needed etc.)
workdir="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo"
datadir="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs"
accnum_file="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt"

echo START: `date`

module load seqkit blast #as required

mkdir -p ${workdir}      # -p because it creates all required dir levels **and** doesn't throw an error if the dir exists :)
cd ${workdir}

# this extracts the item number $SLURM_ARRAY_TASK_ID from the file of accnums
accnum=$(sed -n "$SLURM_ARRAY_TASK_ID"p ${accnum_file})
input_file="${datadir}/${accnum}.flash.extendedFrags.fastq" #to the merged reads


# if the command below can't cope with compressed input
srun gunzip "${input_file}.gz"

# fastq to fasta
srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif \
    seqkit fq2fa ${input_file} \
    -o /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs_fasta/${accnum}.fasta

# because there are mutliple jobs running in // each output file needs to be made unique by post-fixing with $SLURM_ARRAY_TASK_ID and/or $accnum
output_file="${workdir}/data/blastn_searches/blastn.${SLURM_ARRAY_TASK_ID}.${accnum}.out"

#################################################################
# Start work
srun --job-name=${accnum} some_abc_software --threads ${SLURM_CPUS_PER_TASK} --in ${input_file} --out ${output_file}

srun --job-name=${accnum} /proj/applied_bioinformatics/tools/ncbi-blast-2.15.0+-src/blastn \
     -query /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs_fasta/${accnum}.fasta \
     -db /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/blast_db/refseq_viral_genomic \
     -out ${output_file} -evalue 1e-5 \
     -num_threads 1 \
     -outfmt 6 \


#################################################################
# Clean up (eg delete temp files, compress output, recompress input etc)
rm /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/merged_pairs_fasta/${accnum}.fasta
srun gzip ${input_file}
srun gzip ${output_file}
echo END: `date`