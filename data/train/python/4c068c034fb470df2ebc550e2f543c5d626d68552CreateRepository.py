from tuf.libtuf import *

public_root_key = import_rsa_publickey_from_file("keystore/root_key.pub")
public_root_key2 = import_rsa_publickey_from_file("keystore/root_key2.pub")

repository = create_new_repository("repository/")
repository.root.add_key(public_root_key)
repository.root.add_key(public_root_key2)

repository.root.threshold = 2

private_root_key = import_rsa_privatekey_from_file("keystore/root_key", password="asd123")
private_root_key2 = import_rsa_privatekey_from_file("keystore/root_key2", password="asd123")

repository.root.load_signing_key(private_root_key)
repository.root.load_signing_key(private_root_key2)
repository.status()

generate_and_write_rsa_keypair("keystore/targets/targets_key", password="asd123")
generate_and_write_rsa_keypair("keystore/release/release_key", password="asd123")
generate_and_write_rsa_keypair("keystore/timestamp/timestamp_key", password="asd123")

repository.targets.add_key(import_rsa_publickey_from_file("keystore/targets/targets_key.pub"))
repository.release.add_key(import_rsa_publickey_from_file("keystore/release/release_key.pub"))
repository.timestamp.add_key(import_rsa_publickey_from_file("keystore/timestamp/timestamp_key.pub"))

private_targets_key = import_rsa_privatekey_from_file("keystore/targets/targets_key", password="asd123")
private_release_key = import_rsa_privatekey_from_file("keystore/release/release_key", password="asd123")
private_timestamp_key = import_rsa_privatekey_from_file("keystore/timestamp/timestamp_key", password="asd123")

repository.targets.load_signing_key(private_targets_key)
repository.release.load_signing_key(private_release_key)
repository.timestamp.load_signing_key(private_timestamp_key)

repository.timestamp.expiration = "2014-11-20 12:08:00"

repository.write()