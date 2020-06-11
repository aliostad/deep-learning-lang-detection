from tuf.libtuf import *
import distutils.core
import sys

repository = load_repository("repository/")

if len(sys.argv) == 4:
	releaseKeyFile = sys.argv[1]
	f = open(releaseKeyFile)
	releasePassword = f.readline()

	timestampKeyFile = sys.argv[2]
	f = open(timestampKeyFile)
	timestampPassword = f.readline()

	targetsKeyFile = sys.argv[3]
	f = open(targetsKeyFile)
	targetsPassword = f.readline()

	private_targets_key = import_rsa_privatekey_from_file("keystore/targets/targets_key", password=targetsPassword)
	private_release_key = import_rsa_privatekey_from_file("keystore/release/release_key", password=releasePassword)
	private_timestamp_key = import_rsa_privatekey_from_file("keystore/timestamp/timestamp_key", password=timestampPassword)

	repository.targets.load_signing_key(private_targets_key)
	repository.release.load_signing_key(private_release_key)
	repository.timestamp.load_signing_key(private_timestamp_key)

	#clear current targets
	for target in repository.targets.target_files:
		repository.targets.remove_target("repository/targets/"+target)

	#Add targets
	release_targets = repository.get_filepaths_in_directory("repository/targets/update/",recursive_walk=True, followlinks=True)
	repository.targets.add_targets(release_targets)
	beta_targets = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/releases/",recursive_walk=True, followlinks=True)
	repository.targets.add_targets(beta_targets)

	repository.write()

	# copy subdirectory example
	stagedMetadata = "repository/metadata.staged"
	metadata = "repository/metadata"
	distutils.dir_util.copy_tree(stagedMetadata, metadata)
else:
	print "updaterelease.py [release password path] [timmpstamp password path] [targets password path]"