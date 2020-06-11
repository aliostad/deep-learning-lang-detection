from tuf.repository_tool import *

import os

repository = load_repository("../repository")

list_of_targets = repository.get_filepaths_in_directory("../repository/targets/", recursive_walk=False, followlinks=True)

repository.targets.clear_targets()
repository.targets.add_targets(list_of_targets)


private_targets_key =  import_ed25519_privatekey_from_file("/home/clienttuf/custominstallerbuilder/keystore/targets", "passwd")
repository.targets.load_signing_key(private_targets_key)

private_snapshot_key = import_ed25519_privatekey_from_file("/home/clienttuf/custominstallerbuilder/keystore/snapshot", "passwd")
repository.snapshot.load_signing_key(private_snapshot_key)

private_timestamp_key = import_ed25519_privatekey_from_file("/home/clienttuf/custominstallerbuilder/keystore/timestamp", "passwd")
repository.timestamp.load_signing_key(private_timestamp_key)

repository.write()
