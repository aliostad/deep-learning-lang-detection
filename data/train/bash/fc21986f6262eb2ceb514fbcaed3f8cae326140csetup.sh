function setupRemoteRepo() {
  REMOTE_REPO_NAME=$1
  rm -rf ${REMOTE_REPO_NAME}
  mkdir ${REMOTE_REPO_NAME}
  pushd ${REMOTE_REPO_NAME}
  git init --bare
  popd
}

function cloneRemoteRepos() {
  LOCAL_FOLDER_NAME=$1
  rm -rf ${LOCAL_FOLDER_NAME}
  mkdir ${LOCAL_FOLDER_NAME}
  pushd ${LOCAL_FOLDER_NAME}
  git init
  for remote_repo in "${@:2}"
  do
    git remote add `basename ${remote_repo}` file://${REMOTE_REPO_1}
  done
  popd
}

setupRemoteRepo remote1
REMOTE_REPO_1=`pwd`/remote1

setupRemoteRepo remote2
REMOTE_REPO_2=`pwd`/remote2

setupRemoteRepo remote3
REMOTE_REPO_3=`pwd`/remote3

cloneRemoteRepos client1 ${REMOTE_REPO_1} ${REMOTE_REPO_2} ${REMOTE_REPO_3}

cloneRemoteRepos client2 ${REMOTE_REPO_1} ${REMOTE_REPO_2} ${REMOTE_REPO_3}

