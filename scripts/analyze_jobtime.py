import pandas as pd
import matplotlib.pyplot as plt

from sqlite3 import connect
conn = connect('/proj/applied_bioinformatics/common_data/sample_collab.db')


df = pd.read_sql("select JobName,CPUTimeRAW,MaxRSS,read_count,base_count from blastn_viral_resources_used cpu inner join sample_annot spl on cpu.JobName=spl.run_accession;", conn)


df["read_count"] = df["read_count"].astype(float)

df["CPUTimeRAW"] = df["CPUTimeRAW"].astype(float)
print(df.columns)
print(df.head())

fig = plt.figure()

plt.scatter(df["read_count"], df["CPUTimeRAW"])

plt.savefig("counts_v_raw.png")