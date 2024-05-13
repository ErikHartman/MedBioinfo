import sqlite3

def print_pretty(rows, c):
    if not rows:
        print("No rows to print.")
        return
    print("\n")
    column_names = [desc[0] for desc in c.description]
    
    print(" | ".join(column_names))
    print("-" * (len(" | ".join(column_names))))
    
    for row in rows:
        print(" | ".join(str(value) for value in row))

db_filename = "/proj/applied_bioinformatics/common_data/sample_collab.db"

#db_filename = "/proj/applied_bioinformatics/users/x_erhar/MedBioinfo/analyses/sample_collab.db"

conn = sqlite3.connect(db_filename)
c = conn.cursor()

c.execute("SELECT * FROM bioinformaticians LIMIT 5;")
print_pretty(c.fetchall(), c)

c.execute("SELECT * FROM sample2bioinformatician LIMIT 5;")
print_pretty(c.fetchall(), c)

c.execute("INSERT INTO bioinformaticians (username, firstname, lastname) VALUES ('x_erhar', 'Erik', 'Hartman')")
conn.commit()

c.execute("SELECT * FROM bioinformaticians LIMIT 5;")
print_pretty(c.fetchall(), c)


c.execute("SELECT * FROM sample_annot LIMIT 5;")
print_pretty(c.fetchall(), c)


c.execute("""SELECT sa.patient_code
            FROM sample_annot AS sa
            LEFT JOIN sample2bioinformatician AS s2b 
            ON sa.patient_code = s2b.patient_code
            ORDER BY username ASC LIMIT 5;""")

rows = c.fetchall()
for row in rows:
    patient_id = row[0]
    c.execute(f"INSERT INTO sample2bioinformatician (username, patient_code) VALUES ('x_erhar', '{patient_id}')")
    conn.commit()
c.execute("SELECT * FROM sample2bioinformatician WHERE username='x_erhar'")
print_pretty(c.fetchall(), c)

c.execute("""SELECT sa.patient_code
            FROM sample_annot AS sa
            LEFT JOIN sample2bioinformatician AS s2b 
            ON sa.patient_code = s2b.patient_code
            WHERE username = 'x_erhar';""")
conn.commit()
print_pretty(c.fetchall(), c)



c.close()