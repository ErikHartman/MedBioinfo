import pandas as pd
from sqlite3 import connect
import seaborn as sns
import matplotlib.pyplot as plt

conn = connect('/proj/applied_bioinformatics/common_data/sample_collab.db')
df = pd.read_sql("select * from bracken_abundances_long", conn)

ct_values  = pd.read_sql("select * from CtValues", conn)

sample_annot = pd.read_sql("select * from sample_annot", conn)

grouped_df = df.groupby("accession_number").sum()
print(grouped_df["fraction_total_reads"])

df_sars = df[df["name"].str.contains("Severe acute respiratory")].sort_values("fraction_total_reads", ascending=False)

print("Top COVID: ", df_sars[0:20])

combined = df_sars.merge(sample_annot, left_on="accession_number", right_on="run_accession")

plt.figure()

sns.scatterplot(combined, x="fraction_total_reads", y="Ct")

plt.savefig("sars_ct_corr.png")

negative = combined[combined["host_disease_status"] == "negative"]
print("N negative and COVID: ", len(negative))


rna = combined[combined["miscellaneous_parameter"] == "Symptomatic-RNA-sequenced"]

print("Number of RNA: ", len(rna))

common_pathogens = ['Dolosigranulum pigrum','Haemophilus influenzae', 'Haemophilus parainfluenzae',
'Klebsiella pneumoniae','Streptococcus pneumoniae','Staphylococcus aureus','Influenza A virus',
'Severe acute respiratory syndrome-related coronavirus','Chlamydia pneumoniae',
'Haemophilus parainfluenzae','Serratia marcescens','Enterobacter hormaechei',
'Enterobacter cloacae', 'Enterobacter asburiae','Burkholderia multivorans',
'Human coronavirus HKU1','Human coronavirus NL63','Rhinovirus A']

common_pathogens_df = df[df["name"].isin(common_pathogens)].groupby("name").sum().sort_values("fraction_total_reads", ascending=False)

print("Top common pathogens: ", common_pathogens_df[0:10])

df_pivot = df.pivot(index='accession_number', columns='name', values='fraction_total_reads')
