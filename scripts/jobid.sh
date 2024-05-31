sacct -P --format=JobID%15,JobName%18,ReqCPUS,ReqMem,Timelimit,State,ExitCode,Start,elapsedRAW,CPUTimeRAW,MaxRSS,NodeList -j 35143731 \
    | grep ERR > blastn_full_FASTQ_vs_viral_sbatch_array.sacct
cat blastn_full_FASTQ_vs_viral_sbatch_array.sacct

sqlite3 -batch -separator "|" /proj/applied_bioinformatics/common_data/sample_collab.db \
    ".import ../blastn_full_FASTQ_vs_viral_sbatch_array.sacct blastn_viral_resources_used"


sqlite3 -box -batch /proj/applied_bioinformatics/common_data/sample_collab.db "select * from blastn_viral_resources_used where JobID like '35143731%';"