from tuf.libtuf import *

repository = load_repository("repository/")
#repository.targets.add_target("repository/targets/updatexmls/release/update.xml")
#repository.targets.add_target("repository/targets/updatexmls/beta/update.xml")

release_targets = repository.get_filepaths_in_directory("repository/targets/update/",recursive_walk=True, followlinks=True)
repository.targets.add_targets(release_targets)
beta_targets = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/releases/",recursive_walk=True, followlinks=True)
repository.targets.add_targets(beta_targets)

#list_of_targets = repository.get_filepaths_in_directory("repository/targets/update/",recursive_walk=True, followlinks=True)
#repository.targets.add_targets(list_of_targets)
#list_of_targets2 = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/releases/",recursive_walk=True, followlinks=True)
#repository.targets.add_targets(list_of_targets2)

generate_and_write_rsa_keypair("keystore/nightly/nightly_key", bits=2048, password="asd123")
public_nightly_key = import_rsa_publickey_from_file("keystore/nightly/nightly_key.pub")

repository.targets.delegate("nightly", [public_nightly_key], [], 1, ["repository/targets/pub/mozilla.org/firefox/releases/"])

private_nightly_key = import_rsa_privatekey_from_file("keystore/nightly/nightly_key", password="asd123")
repository.targets.nightly.load_signing_key(private_nightly_key)

#Add Nightly/Aurora update.xml targets
#repository.targets.nightly.add_target("repository/targets/updatexmls/nightly/update.xml")
#repository.targets.nightly.add_target("repository/targets/updatexmls/aurora/update.xml")

nightly_targets = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/nightly/",recursive_walk=True, followlinks=True) 
repository.targets.nightly.add_targets(nightly_targets)

#Add Nightly/Aurora .mar targets
#list_of_nightly_targets = repository.get_filepaths_in_directory("repository/targets/pub/mozilla.org/firefox/nightly/",recursive_walk=True, followlinks=True) 
#repository.targets.nightly.add_targets(list_of_nightly_targets)
#print list_of_nightly_targets

private_targets_key = import_rsa_privatekey_from_file("keystore/targets/targets_key", password="asd123")
repository.targets.load_signing_key(private_targets_key)

private_root_key =  import_rsa_privatekey_from_file("keystore/root_key", password="asd123")
private_root_key2 =  import_rsa_privatekey_from_file("keystore/root_key2", password="asd123")
private_release_key =  import_rsa_privatekey_from_file("keystore/release/release_key", password="asd123")
private_timestamp_key =  import_rsa_privatekey_from_file("keystore/timestamp/timestamp_key", password="asd123")

repository.root.load_signing_key(private_root_key)
repository.root.load_signing_key(private_root_key2)
repository.release.load_signing_key(private_release_key)
repository.timestamp.load_signing_key(private_timestamp_key)

# Generate new versions of all the top-level metadata and increment version numbers.
repository.write()