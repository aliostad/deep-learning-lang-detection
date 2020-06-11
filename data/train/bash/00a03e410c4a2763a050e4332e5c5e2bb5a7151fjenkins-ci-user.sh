
sudo mkdir -p /var/jenkins
sudo /usr/sbin/dseditgroup -o create -r 'Jenkins CI Group' -i $1 _jenkins
sudo dscl . -append /Groups/_jenkins passwd "*"
sudo dscl . -create /Users/_jenkins
sudo dscl . -append /Users/_jenkins RecordName jenkins
sudo dscl . -append /Users/_jenkins RealName "Jenkins CI Server"
sudo dscl . -append /Users/_jenkins uid $2
sudo dscl . -append /Users/_jenkins gid $1
sudo dscl . -append /Users/_jenkins shell /bin/bash
sudo dscl . -append /Users/_jenkins home /var/jenkins
sudo dscl . -append /Users/_jenkins passwd "*"
sudo dscl . -append /Groups/_jenkins GroupMembership jenkins
sudo chown - R jenkins /var/jenkins