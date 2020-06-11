#!/bin/sh
#top level script
#invoke repos sync scripts
#invoke lxr indexing script
#
HERE=`pwd`
echo '######################################################################################'
date
echo '######################################################################################'
#sync repos
cd /lxr/lxr_scripts
#pull git repos (those not tracked by XS build system)
./gitpull.sh ./gitrepos.csv
#invoke XS build system to sync build components
./CTXSbuild-clone.sh ./xenserver-targets.csv
#invoke lxr
cd /lxr/lxr-2.0.2
time ./genxref --url=http://lxr.xs.citrite.net --tree=XenServer --allversions --reindexall
#Index kernel-dom0 repos
cd /lxr/lxr_scripts
./CTXSbuild-clone.sh ./kernel-dom0-targets.csv
#invoke lxr
cd /lxr/lxr-2.0.2
time ./genxref --url=http://lxr.xs.citrite.net --tree=kernel-dom0 --allversions --reindexall
#index Xen repos
cd /lxr/lxr-2.0.2
time ./genxref --url=http://lxr.xs.citrite.net --tree=Xen --allversions --reindexall
cd $HERE
exit 0

