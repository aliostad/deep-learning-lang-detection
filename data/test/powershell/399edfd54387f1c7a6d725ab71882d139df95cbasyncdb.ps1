$PYTHON_PATH = 'C:\Python27\python.exe'

Clear-Host

# Clean Up
if (Test-Path 'db.sqlite3') { 
	Remove-Item 'db.sqlite3' 
}

# Sync
.$PYTHON_PATH 'manage.py' 'makemigrations'
.$PYTHON_PATH 'manage.py' 'migrate'
	
.$PYTHON_PATH 'manage.py' 'loaddata' 'cards\fixtures\cardtypes.json'
.$PYTHON_PATH 'manage.py' 'loaddata' 'cardsources\fixtures\battlepacks.json'
.$PYTHON_PATH 'manage.py' 'loaddata' 'cardsources\fixtures\boosters.json'
.$PYTHON_PATH 'manage.py' 'loaddata' 'cardsources\fixtures\players.json'
	
.$PYTHON_PATH 'manage.py' 'createsuperuser'
	
if (Test-Path 'cards.json') {
	.$PYTHON_PATH 'manage.py' 'loaddata' 'cards.json'
}