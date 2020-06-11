from time import strftime
import MySQLdb

api_name = raw_input('API Name: ')
api_url = raw_input('API URL: ')
crawl_frequency = raw_input('API Crawl Frequency(in mins): ')
last_crawl = strftime("%H:%M:%S")

db = MySQLdb.connect(host="localhost", user="root", passwd="password", db="dataweave")
cursor = db.cursor()

cursor.execute('''INSERT INTO api_list (api_name, api_url, last_crawl, crawl_frequency) VALUES (%s, %s, %s, %s)''', (api_name, api_url, last_crawl, crawl_frequency))
db.commit()

print '\nAPI added!\n'