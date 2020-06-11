
# http://msdn.microsoft.com/en-us/library/dd938892(v=sql.100).aspx

# load SMO DLLs
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')  | out-null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended')  | out-null

#create a server object
$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') 'OAK'

# explore server object and databases property
$srv.databases | select Id, Name 

#create simpledb using SMO
#Creates a new database using defaults

$dbname = 'SMOSimple_DB'
$db = new-object ('Microsoft.SqlServer.Management.Smo.Database') ($srv, $dbname)
$db.Create()

#rename the database
$db.rename("SMOSimple_rename")

# show renamed database
$srv.databases | select Id, Name 

#a couple of interesting properties IsDatabaseSnapshot and IsDatabaseSnapshotBase
$db.IsDatabaseSnapshot
$db.IsDatabaseSnapshotBase

#show all properties and methods
$db | get-member

# drop new db
$db.Drop()