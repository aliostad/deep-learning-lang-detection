#!/usr/bin/env bash

# downloads sample data for magento 1.1.2+. can be run twice,
# just delete the directory with the sample data in if you
# want to re-download

parentdir="$(dirname $(readlink -f $0))"

if [ ! -d "$parentdir/sample-data/magento-sample-data-1.9.1.0" ]; then
	echo "Downloading sample data for 1.9.1.0"
	curl -s https://raw.githubusercontent.com/Vinai/compressed-magento-sample-data/1.9.1.0/compressed-magento-sample-data-1.9.1.0.tgz | tar -xz -C $parentdir/sample-data
fi
if [ ! -d "$parentdir/sample-data/magento-sample-data-1.9.0.0" ]; then
	echo "Downloading sample data for 1.9.0.0"
	curl -s https://raw.githubusercontent.com/Vinai/compressed-magento-sample-data/1.9.0.0/compressed-magento-sample-data-1.9.0.0.tgz | tar -xz -C $parentdir/sample-data
fi
if [ ! -d "$parentdir/sample-data/magento-sample-data-1.6.1.0" ]; then
	echo "Downloading sample data for 1.6.1.0"
	curl -s http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz | tar -xz -C $parentdir/sample-data
fi
if [ ! -d "$parentdir/sample-data/magento-sample-data-1.1.2" ]; then
	echo "Downloading sample data for 1.1.2"
	curl -s http://www.magentocommerce.com/downloads/assets/1.1.2/magento-sample-data-1.1.2.tar.gz | tar -xz -C $parentdir/sample-data
fi
