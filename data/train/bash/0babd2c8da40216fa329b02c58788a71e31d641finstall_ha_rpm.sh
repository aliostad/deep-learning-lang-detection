YUM_REPO_DIR=/etc/yum.repos.d

# Add necessary repositories 
cat > $YUM_REPO_DIR/epel.repo << EPEL_REPO_EOF
[epel]
name=Extra Packages for Enterprise Linux 6 - \$basearch
#baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch
failovermethod=priority
enabled=0
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
EPEL_REPO_EOF

cat > $YUM_REPO_DIR/sl.repo << SL_REPO_EOF
[scientific-linux]
name=Scientific Linux
baseurl=http://ftp.scientificlinux.org/linux/scientific/6/x86_64/os/
enabled=0
gpgcheck=0
SL_REPO_EOF

# Install heartbeat
yum install --enablerepo=epel,scientific-linux heartbeat

