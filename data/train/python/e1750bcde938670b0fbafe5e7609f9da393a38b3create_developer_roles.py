#!/usr/bin/env python
from tuf.repository_tool import *

repository = load_repository('repository')

# The keys for the 'developer-signed' roles.
requests_pub = import_ed25519_publickey_from_file("keystore/requests.pub")
numpy_pub = import_ed25519_publickey_from_file("keystore/numpy.pub")


# Delegate trust to these two 'developer-signed' roles, and load their
# private keys so that their metadata can be created and signed.
requests_packages = repository.get_filepaths_in_directory('repository/targets/packages/requests', recursive_walk=True)
repository.targets("developer-signed").delegate("requests", [requests_pub], requests_packages, restricted_paths=["repository/targets/packages/requests"])
repository.targets("developer-signed")("requests").load_signing_key(import_ed25519_privatekey_from_file("keystore/requests", password='pw'))

numpy_packages = repository.get_filepaths_in_directory('repository/targets/packages/numpy', recursive_walk=True)
repository.targets("recently-developer-signed").delegate("numpy", [numpy_pub], numpy_packages, restricted_paths=["repository/targets/packages/numpy"])
repository.targets("recently-developer-signed")("numpy").load_signing_key(import_ed25519_privatekey_from_file("keystore/numpy", password='pw'))

# Load the "on-pypi" keys so that the changes can written to disk.
repository.targets("developer-signed").load_signing_key(import_ed25519_privatekey_from_file("keystore/developer-signed", password='pw'))
repository.targets("recently-developer-signed").load_signing_key(import_ed25519_privatekey_from_file("keystore/recently-developer-signed", password='pw'))
repository.snapshot.load_signing_key(import_ed25519_privatekey_from_file("keystore/snapshot", password='pw'))
repository.timestamp.load_signing_key(import_ed25519_privatekey_from_file("keystore/timestamp", password='pw'))

# Write out all the required metadata.
repository.write()
