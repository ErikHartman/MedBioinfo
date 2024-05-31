SQL_STATEMENT="
CREATE TABLE IF NOT EXISTS bracken_abundances_long (
    accession_number TEXT NOT NULL,
    name TEXT NOT NULL,
    taxonomy_id TEXT NOT NULL,
    taxonomy_lvl TEXT NOT NULL,
    kraken_assigned_reads INTEGER NOT NULL,
    added_reads INTEGER NOT NULL,
    new_est_reads INTEGER NOT NULL,
    fraction_total_reads REAL NOT NULL
    
);
"
DB_PATH="/proj/applied_bioinformatics/common_data/sample_collab.db"
sqlite3 "$DB_PATH" "$SQL_STATEMENT"