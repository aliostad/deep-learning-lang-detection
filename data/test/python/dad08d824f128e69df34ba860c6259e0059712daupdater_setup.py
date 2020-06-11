import os
import shutil
import tempfile

import tuf.repo.signerlib as signerlib
import tuf.repo.keystore as keystore
import tuf.rsa_key as rsa_key
import tuf.tests.unittest_toolbox as unittest_toolbox



unittest_toolbox = unittest_toolbox.Modified_TestCase
unittest_toolbox.bind_keys_to_roles()


def create_keystore(keystore_directory):
  if not unittest_toolbox.rsa_keystore or not unittest_toolbox.rsa_passwords:
    msg = 'Populate \'rsa_keystore\' and \'rsa_passwords\''+\
          ' before invoking this method.'
    sys.exit(msg)

  keystore._keystore = unittest_toolbox.rsa_keystore
  keystore._key_passwords = unittest_toolbox.rsa_passwords
  keystore.save_keystore_to_keyfiles(keystore_directory)



def build_server_repository(server_repository_dir, targets_dir):

  #  Make metadata directory inside client and server repository dir.
  server_metadata_dir = os.path.join(server_repository_dir, 'metadata')
  os.mkdir(server_metadata_dir)


  #  Make a keystore directory inside server's repository and populate it.
  keystore_dir = os.path.join(server_repository_dir, 'keystore')
  os.mkdir(keystore_dir)
  create_keystore(keystore_dir)


  #  Build config file.
  config_filepath = signerlib.build_config_file(server_repository_dir, 365,
                                                unittest_toolbox.semi_roledict)


  #  Role:keyids dictionary.
  role_keyids = {}
  for role in unittest_toolbox.semi_roledict.keys():
    role_keyids[role] = unittest_toolbox.semi_roledict[role]['keyids']

  #  Build root file.
  signerlib.build_root_file(config_filepath, role_keyids['root'],
                            server_metadata_dir)

  #  Build targets file.
  signerlib.build_targets_file(targets_dir, role_keyids['targets'],
                            server_metadata_dir)

  #  Build release file.
  signerlib.build_release_file(role_keyids['release'], server_metadata_dir)

  #  Build timestamp file.
  signerlib.build_timestamp_file(role_keyids['timestamp'], server_metadata_dir)




#  Create a complete client repository.
def create_repositories():
  '''
  Main directories have the following structure:

                        repository_dir
                             |
                     ------------------
                     |                |
       client_repository_dir      server_repository_dir



                   client_repository_dir
                             |
                          metadata
                             |
                      ----------------
                      |              |
                  previous        current


                   server_repository_dir
                             |
                 ----------------------------
                 |           |              |
             metadata     targets        keystore


  NOTE: Do not forget to remove the directory using remove_all_repositories
        after the tests.

  <Return>
    A tuple consisting of all repositories.
    (repository_dir, client_repository_dir, server_repository_dir)

  '''


  #  Make a temporary general repository directory.
  repository_directory = tempfile.mkdtemp()


  #  Make server repository and client repository directories.
  server_repository_dir  = os.path.join(repository_dir, 'server_repository')
  client_repository_dir  = os.path.join(repository_dir, 'client_repository')
  os.mkdir(server_repository_dir)
  os.mkdir(client_repository_dir)


  #  Make metadata directory inside client and server repository dir.
  client_metadata_dir = os.path.join(client_repository_dir, 'metadata')
  os.mkdir(client_metadata_dir)


  #  Make current and previous directories inside metadata dir.
  current_directory = os.path.join(client_metadata_dir, 'current')
  previous_directory = os.path.join(client_metadata_dir, 'previous')
  os.mkdir(current_directory)
  os.mkdir(previous_directory)


  #  Create a project directory.
  target_files = os.path.join(server_repository_dir, 'targets')
  more_targets = os.path.join(target_files, 'more_targets')
  os.mkdir(target_files)
  os.mkdir(more_targets)

  #  Populate the project directory with some files.
  file_path_1 = tempfile.mkstemp(suffix='.txt', dir=target_files)
  file_path_2 = tempfile.mkstemp(suffix='.txt', dir=target_files)
  file_path_3 = tempfile.mkstemp(suffix='.txt', dir=more_targets)
  data = 'Stored data'
  file_1 = open(file_path_1[1], 'wb')
  file_1.write(data)
  file_1.close()
  file_2 = open(file_path_2[1], 'wb')
  file_2.write(data)
  file_2.close()
  file_3 = open(file_path_3[1], 'wb')
  file_3.write(data)
  file_3.close()


  #  Build server repository
  build_server_repository(server_repository_dir, target_files)

  #  Make sure root metadata file is included in the client's
  #  metadata/current directory.
  root_file_path = os.path.join(server_repository_dir, 'metadata', 'root.txt')
  shutil.copy(root_file_path, current_directory)

  return repository_dir, client_repository_dir, server_repository_dir







#  Supply the main repository directory that includes all other repositories.
def remove_all_repositories(repository_directory):
  #  Check if 'repository_directory' is an existing directory.
  if os.path.isdir(repository_directory):
    shutil.rmtree(repository_directory)
  else:
    print '\nInvalid repository directory.'





if __name__ == '__main__':
  repo_list = client_repository_directory()
  remove_repository(repo_list[0])
