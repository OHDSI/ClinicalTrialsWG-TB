import os
import psycopg2


POSTGRES_DB = os.environ.get('POSTGRES_DB')
POSTGRES_USER = os.environ.get('POSTGRES_USER')
POSTGRES_PASSWORD = os.environ.get('POSTGRES_PASSWORD')


# Database connection details
conn = psycopg2.connect(
    dbname=POSTGRES_DB,
    user=POSTGRES_USER,
    password=POSTGRES_PASSWORD,
    host="localhost",
    port="5432"
)

# List of SQL files to execute
sql_files = ['src/cdm_ddl.sql',
             'src/cdm_location.sql',
             'src/cdm_care_site.sql',
             'src/cdm_person.sql',
             'src/cdm_observation_period.sql']

try:
    # Create a cursor object
    cur = conn.cursor()

    # Execute each script sequentially
    for sql_file in sql_files:
        with open(sql_file, 'r') as file:
            sql_script = file.read()
            cur.execute(sql_script)
            print(f"{sql_file} executed successfully")

    # Commit the changes
    conn.commit()

except Exception as err:
    print(f"Error: {err}")
    conn.rollback()

finally:
    # Close cursor and connection
    cur.close()
    conn.close()
