from tuf.libtuf import *
import distutils.core

repository = load_repository("repository/")
#added following 6 lines of code DM
private_release_key = import_rsa_privatekey_from_file("keystore/release/release_key", password="asd123")
private_timestamp_key = import_rsa_privatekey_from_file("keystore/timestamp/timestamp_key", password="asd123")

repository.release.load_signing_key(private_release_key)
repository.timestamp.load_signing_key(private_timestamp_key)

private_nightly_key = import_rsa_privatekey_from_file("keystore/nightly/nightly_key", password="asd123")
repository.targets.load_signing_key(private_nightly_key)

#clear current targets
for target in repository.targets.target_files:
	repository.targets.remove_target("repository/targets/"+target)

#Add targets
release_targets = repository.get_filepaths_in_directory("repository/targets/update/",recursive_walk=True, followlinks=True)
repository.targets.add_targets(release_targets)
#beta_targets = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/releases/",recursive_walk=True, followlinks=True)
#repository.targets.add_targets(beta_targets)

# repository.write_partial() replaced with following - DM
repository.write

# copy subdirectory example
stagedMetadata = "repository/metadata.staged"
metadata = "repository/metadata"
distutils.dir_util.copy_tree(stagedMetadata, metadata)
