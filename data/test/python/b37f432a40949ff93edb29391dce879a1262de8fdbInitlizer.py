#####################################################################################################################
#											HASHTAG.py - HashTagging for dummies									#
#####################################################################################################################
import QueryDispatch

def initDatabase(cur=None,type="sqlite3"):
	if type=="sqlite3":
		cur.execute(QueryDispatch["sqlite3"]["tableCreation"])
	elif type=="mysql":
		cur.execute(QueryDispatch["mysql"]["databaseCreation"])
		cur.execute(QueryDispatch["mysql"]["tableCreation"])
	elif type=="postgres":
		cur.execute(QueryDispatch["postgresql"]["databaseCreation"])
		cur.execute(QueryDispatch["postgresql"]["tableCreation"])

