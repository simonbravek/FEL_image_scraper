import pymysql, json, requests, os
from datetime import datetime
from credentials import HOST, USER, PASSWORD

# How many search results do we take (10000 for server use, 1 for debugging)
TAKE = 5
# Initialize essential constants from the NAMUS website

DIRECTORY_PATH = os.path.dirname(__file__)
ORIGIN = 'https://www.namus.gov'
API_ENDPOINT = ORIGIN + "/api"
STATE_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/States"
CASE_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/{case_type}/Cases/{namus_number}"
SEARCH_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/{case_type}/Search"
DATA_OUTPUT = "./output/{case_type}/{case_type}.json"
DATABASE_NAME = 'scraper'
SCHEME_NAME = 'scraper_scheme.sql'
SCHEME_PATH = os.path.join(DIRECTORY_PATH, SCHEME_NAME)


# the site has a limit to the search not to overload.  
# The database is huge enough to exceed the limit. 
# Thats why I load the data based on individual states to future proof.
# TODO make it based on size and unlimited
  
SEARCH_LIMIT = 10000

# the canvas is taken from inspected request when you search on the namus site

PAYLOAD_NAME = 'search_payload.json'
PAYLOAD_PATH = os.path.join(DIRECTORY_PATH, PAYLOAD_NAME)

# predefining all current case ids in NAMUS database
search_cases = []
# predefining all full cases about people not included in OUR database and waiting to be added
database_cases = []


connection = pymysql.connect(
    host=HOST,
    user=USER,
    password=PASSWORD
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



                
# took from the inspected request on namus site

search_headers = {
    'Accept' : 'application/json',
    'Host' : 'www.namus.gov',
    'Origin': ORIGIN,
    'Content-Type': 'application/json;charset=UTF-8',
    'Referer': 'https://www.namus.gov/MissingPersons/Search',
    'Connection': 'keep-alive',
}

# here it gets the list of NAMUS from the site itself

def fetch_namus_states(test=False):
    if test == True:
        states_info = [{"name" : "Alabama"},{"name" : "Alaska"}]
    
    else:
        print("> Fetching states")
        states_info = requests.get(STATE_ENDPOINT).json()
    
    return states_info

def load_payload():
    print("> Loading payload")
    with open(PAYLOAD_PATH, 'r') as file:
        payload_origin = file.read()
    return payload_origin

# here the template of payload is filled
# it will open the template given and change the variable values for the arguments given

def fill_template(template, **kwargs):
    for key, value in kwargs.items():
        template = template.replace(f"{{{key}}}", str(value))
    return template

# this function will get all case id numbers from the NAMUS database at the given moment


def fetch_namus_search(payload_origin, states_info, case_type="MissingPersons"):
    print("> Fetching search")
    for state_info in states_info:
        state = state_info['name']

        print("> Fetching:", state)

        payload = fill_template(payload_origin, state=state, take=TAKE)
        url = SEARCH_ENDPOINT.format(case_type=case_type)
        try:
            response = requests.post(url, headers=search_headers, data=payload)
            results = json.loads(response.content)
            results = results['results']
            search_cases.extend(results)
        
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 404:
                print("API returned 404 error: Not Found\n")
            else:
                print("API returned an error.\n")
        
        except Exception as e:
            print("An error occured.\n")

        fetched_namus_search_set = set()
        
        for case in search_cases:
            fetched_namus_search_set.add(case["namus2Number"])
        print("All cases numbers found in namus search ", fetched_namus_search_set)

        return(fetched_namus_search_set)




def pull_our_database(fetched_namus_search_set):
    print("> Pulling our database")
    cursor.execute("SELECT namus_number FROM cases")
    our_namus_numbers = cursor.fetchall()
    our_namus_numbers_set = set(num for inner_tuple in our_namus_numbers for num in inner_tuple)
    new_content_in_namus_set = fetched_namus_search_set - our_namus_numbers_set
    print("New content is: ", new_content_in_namus_set)


    
# Here I fetch the full data from the namus database about persons

def fetch_namus_database(fetched_namus_search_set, case_type="MissingPersons"):
    print("> Fetching whole cases")
    for namus_number in fetched_namus_search_set:
        print("> Fetching namus case number: ", namus_number)

        url = CASE_ENDPOINT.format(case_type=case_type, namus_number=namus_number)
        response = requests.get(url, headers=search_headers)
        result = json.loads(response.content)
        database_cases.append(result)




def push_to_our_database():
    print("> Pushing cases to our database")
    for case in database_cases:
        url = f'"www.namus.gov{case["images"][0]["files"]["original"]["href"]}"'
        cursor.execute(f'INSERT INTO personal_ages (min_missing_age, max_missing_age, min_current_age, max_current_age) VALUES ({case["subjectIdentification"]["currentMinAge"]}, {case["subjectIdentification"]["currentMaxAge"]}, {case["subjectIdentification"]["computedMissingMinAge"]}, {case["subjectIdentification"]["computedMissingMinAge"]})')
        cursor.execute('INSERT INTO person_instances (age_id) VALUES (LAST_INSERT_ID())')
        cursor.execute(f'INSERT INTO cases (person_instance_id, fetch_date) VALUES (LAST_INSERT_ID(), "{datetime.now()}")')
        cursor.execute(f'INSERT INTO images (person_instance_id, image_url) VALUES (LAST_INSERT_ID(), {url})')





def main():
    database_exists = check_if_database_exists(DATABASE_NAME)

    if database_exists:
        print("Database unchanged, initialization checked.")
    else:
        build_database()
        print("Database and tables have been initialized successfully.")
    cursor.execute("USE scraper")


    states_info = fetch_namus_states(test=True)
    search_payload_origin = load_payload()

    fetched_namus_search_set = fetch_namus_search(search_payload_origin, states_info)
    pull_our_database(fetched_namus_search_set)



    # print("\n", search_cases, "\n")
    fetch_namus_database(fetched_namus_search_set)
    # print("\n", database_cases, "\n")


    push_to_our_database()


    # Commit any changes
    connection.commit()

    # Close the cursor and connection
    cursor.close()
    connection.close()





if __name__ == "__main__":
    main()