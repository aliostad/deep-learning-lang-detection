#!/bin/bash
echo Bitweaver SamplePackage package creator
echo
# Validate Input
if [ $# == 0 ]
then
	echo "Usage: mkpackage [options] packagename
Options:
	-cvs	Get sample package from CVS if needed
	-wget	Get sample package from the web if needed (via wget) (DEFAULT)
	-dev    If getting the sample package from CVS get with current CVS defaults
	-anon	If getting the sample package from CVS get from anon CVS (DEFAULT)"
	exit
fi

package=""
CVS_A=1
args=`echo "$@" | perl -ne "print lc"`
for p in $args
do
	if [ $p == "-cvs" ]
	then
		CVS=1
	elif [ $p == "-wget" ]
	then
		CVS=
	elif [ $p == "-dev" ]
	then
		CVS_A=
	elif [ $p == "-anon" ]
	then
		CVS_A=1
	else
		package=`echo $p`
	fi
done

# check a package was specified
if [ "$package" == "" ]
then
	echo "Please enter a package name to create"
	exit
fi

# Make the correct case copies of the package name
lcase=`echo "$package" | perl -ne "print lc"`
ucase=`echo "$package" | perl -ne "print uc"`
ccase=`echo "$lcase" | perl -n -e "print ucfirst"`

# Check that the package doesn't already exist
if [ -d $lcase ]
then
	echo "A package called $ccase already exists. Folder $lcase exists"
	exit
fi

# has the sample package already be decompressed
if [[ ( ! -d sample ) && ( ! -d _bit_sample ) ]]
then
	# state how the sample package will be fetched
	if [ $CVS ]
	then
		echo "Sample Package will be fetched by CVS"
	else
		echo "Sample Package will be fetched by wget"
	fi

	# get the sample package from cvs
	if [ $CVS ]
	then
		# use the correct CVS command depending on whether we should use anon CVS
		if [ $CVS_A ]
		then
			cvs -d:pserver:anonymous@bitweaver.cvs.sf.net:/cvsroot/bitweaver co sample
		else
			cvs co sample
		fi
		# The CVS version has a few too many directories so tidy up
		echo CVS cleaning
		rm -rf sample/CVS
		mv sample/sample/* sample/
		rm -rf sample/sample/
	else
		# has the sample package already been downloaded
		if [ ! -f bitweaver_bit_sample_package.tar.gz ]
		then
			wget http://www.bitweaver.org/builds/packages/HEAD/bitweaver_bit_sample_package.tar.gz
		fi
		# if we have the compressed sample package, decompress it
		if [ -f bitweaver_bit_sample_package.tar.gz ]
		then
			tar -zxvf bitweaver_bit_sample_package.tar.gz
		fi
	fi
fi

#is the sample package called the module name
if [[ ( -d _bit_sample ) && ( ! -d sample ) ]]
then
	#call the package sample instead
	mv _bit_sample sample
fi

# if we have the sample package
if [ -d sample ]
then
	# From http://www.bitweaver.org/wiki/SamplePackage
	echo Rename Sample
	mv sample $lcase; cd $lcase
	echo Case sensitive Search and Replace all occureneces of 'sample' with your package name
	find . -name "*" -type f -exec perl -i -wpe "s/sample/$lcase/g" {} \;
	find . -name "*" -type f -exec perl -i -wpe "s/SAMPLE/$ucase/g" {} \;
	find . -name "*" -type f -exec perl -i -wpe "s/Sample/$ccase/g" {} \;
	echo Rename all the files containing 'sample' with your package name
	find . -name "*sample*" -exec rename sample $lcase {} \;
	find . -name "*Sample*" -exec rename Sample $ccase {} \;
	cd ..

	echo
	echo A basic outline of your package $ccase has been created
	echo
else
	echo directory sample not found
	echo please review any errors
	echo please download and decompress the sample package
fi

