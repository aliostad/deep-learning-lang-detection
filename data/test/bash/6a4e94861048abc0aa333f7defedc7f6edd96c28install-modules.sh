#!/bin/bash

wget https://raw.githubusercontent.com/packetfocus/EmpireModules/master/Invoke-MassMimikatz.ps1 -O /tmp/Invoke-MassMimikatz.ps1
wget https://raw.githubusercontent.com/packetfocus/EmpireModules/master/Invoke-MassMimikatz.py -O /tmp/Invoke-MassMimikatz.py
echo "Moving into Empire Directories"
cp  /tmp/Invoke-MassMimikatz.ps1 /tools/Empire/data/module_source/credentials/
cp   /tmp/Invoke-MassMimikatz.py /tools/Empire/lib/modules/credentials/mimikatz/
echo "Cleaning up"
rm /tmp/Invoke-MassMimikatz.ps1
rm /tmp/Invoke-MassMimikatz.py
echo "Finished."
