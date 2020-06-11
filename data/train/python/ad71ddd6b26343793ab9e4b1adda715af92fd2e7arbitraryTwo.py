#this works best if arbitraryOne.py was run first
#it simulates our attacker taking control of the server and writing a new release/timestamp
#since the attacker doesn't have the targets key this will fail

from tuf.libtuf import *
import os
import SimpleHTTPServer
import SocketServer
import hashlib

os.rename("./repository/metadata", "./repository/metadata.staged")

repository = load_repository("./repository")

pubRootKey = import_rsa_publickey_from_file("./key.pub")
priRootKey = import_rsa_privatekey_from_file("./key", password="password")

repository.release.add_key(pubRootKey)
repository.timestamp.add_key(pubRootKey)

repository.release.load_signing_key(priRootKey)
repository.timestamp.load_signing_key(priRootKey)

repository.timestamp.expiration = "2014-10-29 12:08:00"

shutil.copyfile("./repository/metadata.staged/targets.txt", "./repository/metadata.staged/tmp")
f = open("./repository/metadata.staged/targets.txt", "w+b")
tmp = open("./repository/metadata.staged/tmp", "r+b")


for l in f:
	try:
		k = l.index("c5d031")
		e = l.index("d7\"")
		m = hashlib.sha256()
		gem = open("./repository/targets/gems/arbitrary-0.0.6.gem", "r")
		m.update(gem.read())
		ha = m.hexdigest()

		f.write(l[0,k])
		f.write(ha)
		f.write("\"\n")
		continue
	except(ValueError):
		pass
	f.write(l)

	

repository.write( True )

os.rename("./repository/metadata.staged", "./repository/metadata")

os.chdir("./repository")
Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer(("", 9294), Handler)
print "start server"
httpd.serve_forever()
