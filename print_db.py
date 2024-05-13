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

conn = sqlite3.connect(db_filename)
c = conn.cursor()

c.execute("SELECT * FROM bioinformaticians LIMIT 5;")
print_pretty(c.fetchall(), c)

c.execute("SELECT * FROM sample2bioinformatician LIMIT 5;")
print_pretty(c.fetchall(), c)

c.close()