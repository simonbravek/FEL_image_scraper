import pymysql, os

DATABASE_NAME = 'scraper'
SCHEME_NAME = 'scraper_scheme.sql'
DIRECTORY_PATH = os.path.dirname(__file__)
SCHEME_PATH = os.path.join(DIRECTORY_PATH, SCHEME_NAME)

connection = pymysql.connect(
    host="localhost",
    user="simon",
    password="CCahuV+%VEs@1"
)

cursor = connection.cursor()


def check_if_database_exists(database_name):
    try:
        cursor.execute("SHOW DATABASES LIKE %s", (database_name,))
        if cursor.fetchone() is not None:
            return True
        else:
            return False
    except Exception as e:
        print(f"Error: {e}")
        print("Problem finding database. End of program")
        connection.commit()
        cursor.close()
        connection.close()
        exit()

def build_database():
    # Read the SQL script from the file
    with open(SCHEME_PATH, 'r') as file:
        database_init = file.read()

    # Split the script into individual SQL statements and execute each one
    for statement in database_init.split(';'):
        if statement.strip():
                cursor.execute(statement)

def main():

    database_exists = check_if_database_exists(DATABASE_NAME)

    if database_exists:
        print("Database unchanged, initialization checked.")
    else:
        build_database()
        print("Database and tables have been initialized successfully.")
        
    # Commit any changes
    connection.commit()

    # Close the cursor and connection
    cursor.close()
    connection.close()

if __name__ == "__main__":
    main()