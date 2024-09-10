import json, requests, os

# Initialize essential constants from the NAMUS website

ORIGIN = 'https://www.namus.gov'
API_ENDPOINT = ORIGIN + "/api"
STATE_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/States"
CASE_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/{case_type}/Cases/{namus_number}"
SEARCH_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/{case_type}/Search"
DATA_OUTPUT = "./output/{case_type}/{case_type}.json"

# the site has a limit to the search not to overload.  
# The database is huge enough to exceed the limit. 
# Thats why I load the data based on individual states to future proof.
# TODO make it based on size and unlimited
  
SEARCH_LIMIT = 10000

# the canvas is taken from inspected request when you search on the namus site

PAYLOAD_NAME = 'search_payload.json'
DIRECTORY_PATH = os.path.dirname(__file__)
PAYLOAD_PATH = os.path.join(DIRECTORY_PATH, PAYLOAD_NAME)

# predefining all current case ids in NAMUS database
search_cases = []
# predefining all full cases about people not included in OUR database and waiting to be added
database_cases = []

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

        payload = fill_template(payload_origin, state=state, take=1)
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




def pull_our_database():
    print("> Pulling our database")
    

def see_whats_new():
    print("> Searching for new content") 

    
# Here I fetch the full data from the database about persons no 

def fetch_namus_database(cases, case_type="MissingPersons"):
    print("> Fetching database")
    for case in cases:
        namus_number = case["namus2Number"]

        print("> Fetching: ", namus_number)

        url = CASE_ENDPOINT.format(case_type=case_type, namus_number=namus_number)
        response = requests.get(url, headers=search_headers)
        result = json.loads(response.content)
        database_cases.append(result)
def

def push_to_our_database():
    print("> Pushing cases to our database")


def main():
    states_info = fetch_namus_states(test=True)
    search_payload_origin = load_payload()
    fetch_namus_search(search_payload_origin, states_info)
    pull_our_database()
    see_whats_new()



    print("\n", search_cases, "\n")

    fetch_namus_database(search_cases)

    print("\n", database_cases, "\n")

    push_to_our_database()

if __name__ == "__main__":
    main()