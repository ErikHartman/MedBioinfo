#!/bin/bash

#SBATCH --ntasks=1                  
#SBATCH --nodes=1                    
#SBATCH --cpus-per-task=1          
#SBATCH --mem=1GB       
#SBATCH --time=0-00:15   
#SBATCH -o slurm.%A.%a.out  
#SBATCH -e slurm.%A.%a.err   
#SBATCH --job-name=combine_bracken_report  

bracken_out_dir="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/kraken2" ## path to directory with bracken output files
accnum_file="/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/x_erhar_run_accessions.txt" ## path to file with the list of accessions 

# add header
echo -e "accession_number\tname\ttaxonomy_id\taxonomy_lvl\tkraken_assigned_reads\tadded_reads\tnew_est_reads\tfraction_total_reads" > ${bracken_out_dir}/combined_bracken.out
# append all files with column accession number (Out files should be: {accession_number}.braken.out)
srun xargs -I{} -a $accnum_file awk -v id={} 'NR > 1 {print id "\t" $0}' ${bracken_out_dir}/{}_bracken_analysis.txt >> ${bracken_out_dir}/combined_bracken.out