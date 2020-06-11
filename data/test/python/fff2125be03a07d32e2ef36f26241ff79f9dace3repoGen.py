from tuf.libtuf import *
import os

secret_root_1      = "mysecret1"
secret_targets_1   = "mysecret4"
secret_release_1   = "mysecret6"
secret_timestamp_1 = "mysecret8"
secret_claimed_1   = "mysecret10"
secret_recent_1    = "mysecret12"
secret_unclaimed_1 = "mysecret14"

repoPath   = "/tmp/gemsontuf/repository/"

#public key import
print "Importing keys"
publicRoot1 = import_rsa_publickey_from_file("keys/root_key1.pub")
publicTargets1 = import_rsa_publickey_from_file("keys/targets_key1.pub")
publicRelease1 = import_rsa_publickey_from_file("keys/release_key1.pub")
publicTimestamp1 = import_rsa_publickey_from_file("keys/timestamp_key1.pub")
publicClaimed1 = import_rsa_publickey_from_file("keys/claimed_key1.pub")
publicRecent1 = import_rsa_publickey_from_file("keys/recent_key1.pub")
publicUnclaimed1 = import_rsa_publickey_from_file("keys/unclaimed_key1.pub")

#private key import second parameter is so you don't have to type a password in
privateRoot1 = import_rsa_privatekey_from_file("keys/root_key1", password=secret_root_1)
privateTargets1 = import_rsa_privatekey_from_file("keys/targets_key1", password=secret_targets_1)
privateRelease1 = import_rsa_privatekey_from_file("keys/release_key1", password=secret_release_1)
privateTimestamp1 = import_rsa_privatekey_from_file("keys/timestamp_key1", password=secret_timestamp_1)
privateClaimed1 = import_rsa_privatekey_from_file("keys/claimed_key1", password=secret_claimed_1)
privateRecent1 = import_rsa_privatekey_from_file("keys/recent_key1", password=secret_recent_1)
privateUnclaimed1 = import_rsa_privatekey_from_file("keys/unclaimed_key1", password=secret_unclaimed_1)


#create new repository directory
print "Building repository"
repository = create_new_repository(repoPath)

#adds public keys to directory
repository.root.add_key(publicRoot1)
repository.targets.add_key(publicTargets1)
repository.release.add_key(publicRelease1)
repository.timestamp.add_key(publicTimestamp1)

#create thresholds
repository.root.threshold = 1
repository.targets.threshold = 1
repository.release.threshold = 1
repository.timestamp.threshold = 1

#load singing keys
repository.root.load_signing_key(privateRoot1)
repository.targets.load_signing_key(privateTargets1)
repository.release.load_signing_key(privateRelease1)
repository.timestamp.load_signing_key(privateTimestamp1)

#expiration date
repository.timestamp.expiration = "2014-10-10 12:00:00"

#create delegations
repository.targets.delegate("claimed", [publicClaimed1], [])
repository.targets.claimed.load_signing_key(privateClaimed1)

repository.targets.delegate("recent", [privateRecent1], [])
repository.targets.recent.load_signing_key(privateRecent1)

repository.targets.delegate("unclaimed", [privateUnclaimed1], [])
repository.targets.unclaimed.load_signing_key(privateUnclaimed1)

#Add new targets
#print "Building targets file"
#targetFiles = repository.get_filepaths_in_directory(repoPath + "targets/", recursive_walk=True, followlinks=True)
#repository.targets.add_targets(targetFiles)

#prints some information about the repository setup
repository.status()

#tries to create repository 
print "Writing repository-stage"
try:
  repository.write()
except tuf.Error, e:
  print e 

