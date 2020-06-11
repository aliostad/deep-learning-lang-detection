
//--------------------------------------------------
// Django
//--------------------------------------------------
source venv/bin/activate
./manage.py runserver &

python manage.py inspectdb > somefile.txt
./manage.py shell


./manage.py sqlclear app_name | ./manage.py dbshell 
./manage.py syncdb

./manage.py schemamigration --initial southtut
./manage.py migrate southtut

./manage.py schemamigration my_app_name --auto --stdout
./manage.py migrate myapp --db-dry-run
 
./manage.py migrate --list

$ ./manage.py dbshell
psql=# CREATE DATABASE djtest; 


./manage.py schemamigration main --auto --update

- python manage.py validate //– Checks for any errors in the construction of your models.
- python manage.py sqlcustom app_name //– Outputs any custom SQL statements 
//(such as table modifications or constraints) that are defined for the application.
- python manage.py sqlclear app_name //– Outputs the necessary DROP TABLE statements for this app, 
// according to which tables already exist in your database (if any).
- python manage.py sqlindexes app_name // – Outputs the CREATE INDEX statements for this app.
python manage.py sqlall app_name // – A combination of all the SQL from the sql, sqlcustom, and sqlindexes commands.
- python manage.py shell

//--------------------------------------------------
// HEROKU
//--------------------------------------------------
heroku config | grep HEROKU_POSTGRESQL
heroku config | grep DATABASE_URL
//--------------------------------------------------

