import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from sqlite3 import connect

# Day 1
conn = connect('/proj/applied_bioinformatics/common_data/sample_collab.db')
df = pd.read_sql("select JobName,CPUTimeRAW,MaxRSS,read_count,base_count from blastn_viral_resources_used cpu inner join sample_annot spl on cpu.JobName=spl.run_accession;", conn)

df["read_count"] = df["read_count"].astype(float)
df["CPUTimeRAW"] = df["CPUTimeRAW"].astype(float)

fig = plt.figure()
plt.scatter(df["read_count"], df["CPUTimeRAW"])

plt.savefig("counts_v_raw.png")

# Day 3

df_job = pd.read_sql("SELECT * FROM kraken2_viral_resources_used", conn)


def job_id_has_correct_format(id):
    if not "_" in id:
        return False
    first_part = id.split("_")[0]
    first_part = str.lower(first_part)
    if first_part not in (["kraken2", "bracken"]):
        return False
    return True


print(df_job)
print(df_job["JobName"].unique())

df_job["id_format_correct"] = df_job["JobName"].apply(lambda x: job_id_has_correct_format(x))
df_job = df_job[df_job["id_format_correct"] == True]

df_job["accession"] = df_job["JobName"].apply(lambda x: str(x).split("_")[1])
df_job["kraken_or_bracken"] = df_job["JobName"].apply(lambda x: str(x).split("_")[0])
df_reads = pd.read_sql("""SELECT * from sample_annot""", conn)

print(df_job.head())
print(df_reads.head())

df_merged = df_job.merge(df_reads, left_on="accession", right_on="run_accession", how="inner")

df_merged["read_count"] = df_merged["read_count"].astype(float)
df_merged["CPUTimeRAW"] = df_merged["CPUTimeRAW"].astype(float)

print(df_merged)
print(df_merged.columns)
fig, axs = plt.subplots(1,2)

sns.scatterplot(df_merged[df_merged["kraken_or_bracken"] == "kraken2"] ,x="read_count", y="CPUTimeRAW", ax=axs[0], hue="ReqCPUS")
sns.scatterplot(df_merged[df_merged["kraken_or_bracken"] == "bracken"] ,x="read_count", y="CPUTimeRAW", ax=axs[1])

axs[0].set_title("Kraken2")
axs[1].set_title("Bracken")


plt.savefig("counts_v_raw_kraken.png")
