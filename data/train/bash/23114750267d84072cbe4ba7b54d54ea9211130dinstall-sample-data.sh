#!/usr/bin/env bash

# HOW TO USE - run download-sample-data.sh first, then run this
# from within the directory of a magento install

# a rigid demo data install script for magento, rigid because
# directories need to be named as per the magento version, but
# without dots.

error () {
	echo $1
	exit 1
}

# check for n98
if [ ! $(which n98-magerun) ]; then
	error "You need n98-magerun in your path"
fi

# check this looks like a magento directory
if [ ! -f "app/Mage.php" ]; then
   error "Can't find app/Mage.php"
fi

# get version from directory, check it is a Magento release
version=$(basename `pwd`)
versions=" 10 1019700 1019870 10198701 10198702 10198704 10198706 110 111 112 113 114 115 116 117 118 120 1201 1202 1203 121 1211 1212 130 131 1311 132 1321 1322 1323 1324 1330 1400 1401 1410 1411 1420 1501 1510 1600 1610 1620 1700 1701 1702 1800 1810 1900 1901 1910 "
if [[ ! "$versions" =~ " $version " ]]; then
    error "Can't recognise version, Magento directory must be a version without dots, i.e. for 1.9.1.0 it should be 1910"
fi

# determine what sample data to install
if [ "$version" -ge "1910" ]; then
	sampleDataDir="magento-sample-data-1.9.1.0"
	sqlFile="magento_sample_data_for_1.9.1.0.sql"
elif [ "$version" -ge "1900" ]; then
	sampleDataDir="magento-sample-data-1.9.0.0"
	sqlFile="magento_sample_data_for_1.9.0.0.sql"
elif [ "$version" -ge "1610" ]; then
	sampleDataDir="magento-sample-data-1.6.1.0"
	sqlFile="magento_sample_data_for_1.6.1.0.sql"
else
	sampleDataDir="magento-sample-data-1.1.2"
	sqlFile="magento_sample_data_for_1.1.2.sql"
fi

# check the sample data exists for this version, exit if not
sampleDataExists=true
if [ ! -d "/vagrant/magento-setup/sample-data/$sampleDataDir/media" ]; then
	echo "ERROR - /vagrant/magento-setup/sample-data/$sampleDataDir/media/ does not exist, run download-sample-data.sh"
	sampleDataExists=false
fi
if [ ! -f "/vagrant/magento-setup/sample-data/$sampleDataDir/$sqlFile" ]; then
	echo "ERROR - /vagrant/magento-setup/sample-data/$sampleDataDir/$sqlFile does not exist, run download-sample-data.sh"
	sampleDataExists=false
fi
if [ "$sampleDataExists" = false ]; then
	error "Exiting due to missing sample data"
fi

# install the sample data, then perform Magento install via n98
cp -R /vagrant/magento-setup/sample-data/$sampleDataDir/media .
if [ "$version" -ge "1900" ]; then
	cp -R /vagrant/magento-setup/sample-data/$sampleDataDir/skin .
fi
mysqladmin -uroot -f drop $version &> /dev/null
mysqladmin -uroot create $version &> /dev/null
cat /vagrant/magento-setup/sample-data/$sampleDataDir/$sqlFile | mysql -uroot $version &> /dev/null
rm app/etc/local.xml &> /dev/null
rm -rf var/cache/*
n98-magerun install --dbHost="localhost" --dbUser="root" --dbPass="" --dbName="$version" --useDefaultConfigParams=yes --installationFolder="." --baseUrl="http://magentoversions.dev/$version/" --noDownload
