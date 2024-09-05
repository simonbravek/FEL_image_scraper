import json, requests, os

ORIGIN = 'https://www.namus.gov'
API_ENDPOINT = ORIGIN + "/api"
STATE_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/States"
CASE_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/{case_type}/Cases/{namus_number}"
SEARCH_ENDPOINT = API_ENDPOINT + "/CaseSets/NamUs/{case_type}/Search"
DATA_OUTPUT = "./output/{case_type}/{case_type}.json"
SEARCH_LIMIT = 10000
PAYLOAD_NAME = 'search_payload.json'
DIRECTORY_PATH = os.path.dirname(__file__)
PAYLOAD_PATH = os.path.join(DIRECTORY_PATH, PAYLOAD_NAME)

search_cases = []
database_cases = []

search_headers = {
    'Accept' : 'application/json',
    'Host' : 'www.namus.gov',
    'Origin': ORIGIN,
    'Content-Type': 'application/json;charset=UTF-8',
    'Referer': 'https://www.namus.gov/MissingPersons/Search',
    'Connection': 'keep-alive',
}

def fetch_states(test=False):
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


def fill_template(template, **kwargs):
    for key, value in kwargs.items():
        template = template.replace(f"{{{key}}}", str(value))
    return template

def fetch_search(payload_origin, states_info, case_type="MissingPersons"):
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




def fetch_database(cases, case_type="MissingPersons"):
    print("> Fetching database")
    for case in cases:
        namus_number = case["namus2Number"]

        print("> Fetching: ", namus_number)

        url = CASE_ENDPOINT.format(case_type=case_type, namus_number=namus_number)
        response = requests.get(url, headers=search_headers)
        result = json.loads(response.content)
        database_cases.append(result)



def main():
    states_info = fetch_states(test=True)
    search_payload_origin = load_payload()
    fetch_search(search_payload_origin, states_info)

    print("\n", search_cases, "\n")

    fetch_database(search_cases)

    print("\n", database_cases, "\n")


if __name__ == "__main__":
    main()