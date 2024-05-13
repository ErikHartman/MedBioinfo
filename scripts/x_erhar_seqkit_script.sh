#!/bin/bash

#ls /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/*.fastq.gz | xargs -I {} sh -c 'echo -n "{}: "; zcat "{}" | grep -c "^@"'


ls /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/*.fastq.gz | srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs seqkit stats --threads 1 

ls /proj/applied_bioinformatics/users/x_erhar/MedBioinfo/data/sra_fastq/*.fastq.gz | srun --cpus-per-task=1 --time=00:30:00 singularity exec /proj/applied_bioinformatics/users/x_erhar/myimage.sif xargs seqkit stats --unique --threads 1 