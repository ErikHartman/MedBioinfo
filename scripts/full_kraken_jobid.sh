sacct -P --format=JobID%15,JobName%18,ReqCPUS,ReqMem,Timelimit,State,ExitCode,Start,elapsedRAW,CPUTimeRAW,MaxRSS,NodeList  -j 35185752 \
   | grep ERR > kraken2_vs_viral.sacct

sqlite3 -batch -separator "|" /proj/applied_bioinformatics/common_data/sample_collab.db \
    ".import kraken2_vs_viral.sacct kraken2_viral_resources_used"

sqlite3 -box -batch /proj/applied_bioinformatics/common_data/sample_collab.db "select * from kraken2_viral_resources_used where JobID like '35185752%';"


# This is the working one 35185752