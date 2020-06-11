#! /usr/bin/env python
# andres.amaya.diaz@gmail.com Feb 2012

import os
import re
import sys
import MySQLdb

ssh_command = os.environ['SSH_ORIGINAL_COMMAND']
user = sys.argv[1]

m = re.search("^(git-receive-pack|git-upload-pack) '(\w+)\.git'$", ssh_command)
if m == None:
    exit(1)

command = m.group(1)
repoName = m.group(2)

db=MySQLdb.connect(host='localhost',user='root',
passwd='ceis12345*',db='captivaproject')

cursor=db.cursor()

sql='SELECT Repository.id, Repository.name, Repository.Owner FROM Repository INNER JOIN repository_writeusers ON Repository.id = repository_writeusers.Repository_id WHERE Repository.name="'+repoName+'" AND repository_writeusers.writeUsers_id='+user
cursor.execute(sql)
resultado=cursor.fetchone()

if resultado == None and command == "git-upload-pack":
	sql='SELECT Repository.id, Repository.name, Repository.Owner FROM Repository INNER JOIN repository_readusers ON Repository.id = repository_readusers.Repository_id WHERE Repository.name="'+repoName+'" AND repository_readusers.readUsers_id='+user
	cursor.execute(sql)
	resultado=cursor.fetchone()

if resultado != None:
	arg = "%s '/home/git/repo/%s.git'" %(command, repoName)
	os.execv("/usr/bin/git-shell", ["/usr/bin/git-shell","-c", arg])