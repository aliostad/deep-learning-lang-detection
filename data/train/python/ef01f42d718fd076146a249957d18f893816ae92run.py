import psycopg2
import sys
import theUI
from manage_db import manage_db
from import_data import import_data


if __name__ == '__main__':
	# manage_db() initializes and manage connection to the database
    mydb = manage_db('localhost','verkefni2', 'postgres', 'postgres')
    if mydb.missingData():
    	# import_data() imports the data to the postgresql database
    	data = import_data(mydb)

    # Creates average rating table from the infomation given to shorten the query time
    mydb.createAverageRatingsTable()
    # Starts the GUI for browsing the data
    window = theUI.loadUI(mydb)
