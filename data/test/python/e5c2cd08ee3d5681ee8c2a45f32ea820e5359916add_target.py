from tuf.repository_tool import *

import os

repository = load_repository("./repo")

list_of_targets = repository.get_filepaths_in_directory("./repo/targets/", recursive_walk=False, followlinks=True)

repository.targets.clear_targets()
repository.targets.add_targets(list_of_targets)


private_targets_key =  import_rsa_privatekey_from_file("./keystore/targets_key", "password")
repository.targets.load_signing_key(private_targets_key)

private_snapshot_key = import_rsa_privatekey_from_file("./keystore/snapshot_key", "password")
repository.snapshot.load_signing_key(private_snapshot_key)

private_timestamp_key = import_rsa_privatekey_from_file("./keystore/timestamp_key", "password")
repository.timestamp.load_signing_key(private_timestamp_key)

repository.write()
