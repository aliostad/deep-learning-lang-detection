#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source "${SCALR_REPOCONFIG_CONF}"

if [ "${DEFAULT_REPO_ROOT}" != "${LOCAL_REPO_ROOT}" ]; then
  echo "You changed the LOCAL_REPO_ROOT (from ${DEFAULT_REPO_ROOT} to ${LOCAL_REPO_ROOT})"
  echo "If Selinux is enabled, this might create issues"
  echo "Consider disabling Selinux, or ensure your policies allow Nginx to serve files from ${LOCAL_REPO_ROOT}"
fi

echo "Use the following in /etc/scalr-server/scalr-server.rb"
echo "WARNING: if app[:configuration] exists, you should update that key instead of replacing it!"

cat << 'EOF'

# REPO CONFIG BEGINS

repo_host = '<Set this to the hostname or IP of the repo server>'

app[:configuration] = {
  :scalr => {
    :scalarizr_update => {
      :mode => 'client',
      :default_repo => 'stable',
      :repos => {
        :stable => {
          :deb_repo_url => "http://#{repo_host}/stable/apt /",
          :rpm_repo_url => "http://#{repo_host}/stable/rpm/rhel/$releasever/$basearch",
          :win_repo_url => "http://#{repo_host}/stable/win",
        },
        :latest => {
          :deb_repo_url => "http://#{repo_host}/beta/apt /",
          :rpm_repo_url => "http://#{repo_host}/beta/rpm/rhel/$releasever/$basearch",
          :win_repo_url => "http://#{repo_host}/beta/win",
        },
      },
    },
  }
}

# REPO CONFIG ENDS

EOF

echo "Done!"
