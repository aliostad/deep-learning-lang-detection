#creates a new repo except simulates arbitrary package by 
#overwriting part of a real package 
#this also sets us up for arbitraryTwo.py

from tuf.libtuf import *
import sys
import os
import shutil
import SimpleHTTPServer
import SocketServer

#requires path to the gemsontuf folder and the client folder usually /tmp/.gemtuf/client
if len(sys.argv) == 1:
	print "requires at least one argument [path to gemsontuf]"
	print "can have two [path to gemsontuf] [path to client folder]"
	sys.exit()
if len(sys.argv) == 2:
	sys.argv.append("/tmp/.gemtuf/client")


generate_and_write_rsa_keypair("./key", bits=2048, password="password")

pubRootKey = import_rsa_publickey_from_file("./key.pub")
priRootKey = import_rsa_privatekey_from_file("./key", password="password")
shutil.rmtree("./repository")
os.makedirs("./repository")
repository = create_new_repository("./repository")

repository.root.add_key(pubRootKey)
repository.targets.add_key(pubRootKey)
repository.release.add_key(pubRootKey)
repository.timestamp.add_key(pubRootKey)

repository.root.threshhold = 1
repository.root.load_signing_key(priRootKey)
repository.targets.load_signing_key(priRootKey)
repository.release.load_signing_key(priRootKey)
repository.timestamp.load_signing_key(priRootKey)

repository.timestamp.expiration = "2014-10-28 12:08:00"

os.rmdir("./repository/targets/")
shutil.copytree(sys.argv[1] + "repository/targets", "./repository/targets/")
list_of_targets = repository.get_filepaths_in_directory("./repository/targets",
                                                        recursive_walk=True, followlinks=True)
repository.targets.add_targets(list_of_targets)

repository.write()

shutil.rmtree(sys.argv[2])
os.rename("./repository/metadata.staged", "./repository/metadata")
create_tuf_client_directory("./repository", sys.argv[2])

f = open("./repository/targets/gems/arbitrary-0.0.6.gem", "r+b")
f.write("000000")
f.close()

os.chdir("./repository")
Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer(("", 9294), Handler)
print "start server"
httpd.serve_forever()

