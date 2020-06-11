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

	nightlyKeyFile = sys.argv[3]
	f = open(nightlyKeyFile)
	nightlyPassword = f.readline()

	private_release_key = import_rsa_privatekey_from_file("keystore/release/release_key", password=releasePassword)
	private_timestamp_key = import_rsa_privatekey_from_file("keystore/timestamp/timestamp_key", password=timestampPassword)
	private_nightly_key = import_rsa_privatekey_from_file("keystore/nightly/nightly_key", password=nightlyPassword)

	repository.release.load_signing_key(private_release_key)
	repository.timestamp.load_signing_key(private_timestamp_key)
	repository.targets.nightly.load_signing_key(private_nightly_key)

	#clear current targets
	for target in repository.targets.nightly.target_files:
		repository.targets.nightly.remove_target("repository/targets/"+target)

	#add new targets
	nightly_targets = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/nightly/",recursive_walk=True, followlinks=True) 
	repository.targets.nightly.add_targets(nightly_targets)
	#repository.targets.nightly.version = repository.targets.nightly.version + 1

	repository.write()

	# copy subdirectory example
	stagedMetadata = "repository/metadata.staged"
	metadata = "repository/metadata"
	distutils.dir_util.copy_tree(stagedMetadata, metadata)
else:
	print "updatenightly.py [release password path] [timmpstamp password path] [nightly password path]"