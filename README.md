# international_anotated_image_scraper
The anotated photo server project done on FEL ČVUT during the summer. All sources, my own scraper files and one big connected database maker. 

1. The database scheme map here https://drawsql.app/teams/johannes-kepler-grammar-school/diagrams/missing-persons-database
2. The best sources to continue with my project here
   https://www.missingkids.org/gethelpnow/search/poster-results
   https://api.missingkids.org/missingkids/servlet/JSONDataServlet?action=publicSearch&searchLang=en_US&search=new&subjToSearch=child&missState=CA&missCountry=US
   https://www.namus.gov/api/CaseSets/NamUs/MissingPersons/Cases/128188
   https://www.namus.gov/MissingPersons/Search
   https://aplikace.policie.cz/patrani-osoby/PersonDetail.aspx?person_id=17010812240510
   https://github.com/Prepager/namus-scraper/tree/master
   https://github.com/jcmack/missingpersons
   https://sandbox.oarc.ucla.edu/python-scraping-and-border-mapping
   
   https://trello.com/invite/b/669e3413c53bb9b769d12765/ATTI9bd0df9e693c15f0d44abd66da66a7cfF60C0E0F/scraper


3. I have some modules in my work and one complete blend for namus server
4. MariaDB, pymysql modules required
5. You just need to set a timer to run my script all_together.py and have search payload.json present in that same folder
6. Then you have the database growing in your MariaDB under name "scraper"
