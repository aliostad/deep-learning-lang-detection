from tuf.libtuf import *
import distutils.core

repository = load_repository("repository/")
#added following 6 lines of code DM
private_targets_key = import_rsa_privatekey_from_file("keystore/targets/targets_key", password="asd123")
private_release_key = import_rsa_privatekey_from_file("keystore/release/release_key", password="asd123")
private_timestamp_key = import_rsa_privatekey_from_file("keystore/timestamp/timestamp_key", password="asd123")

repository.targets.load_signing_key(private_targets_key)
repository.release.load_signing_key(private_release_key)
repository.timestamp.load_signing_key(private_timestamp_key)

private_nightly_key = import_rsa_privatekey_from_file("keystore/nightly/nightly_key", password="asd123")
repository.targets.nightly.load_signing_key(private_nightly_key)

#clear current targets
for target in repository.targets.nightly.target_files:
	repository.targets.nightly.remove_target("repository/targets/"+target)

#add new targets
nightly_targets = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/nightly/",recursive_walk=True, followlinks=True) 
repository.targets.nightly.add_targets(nightly_targets)
#repository.targets.nightly.version = repository.targets.nightly.version + 1

# repository.write_partial() replaced with following - DM
repository.write

# copy subdirectory example
stagedMetadata = "repository/metadata.staged"
metadata = "repository/metadata"
distutils.dir_util.copy_tree(stagedMetadata, metadata)
