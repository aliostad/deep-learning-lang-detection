#!/bin/bash
clear
 
stty erase '^?'
 
echo "To install Magento, you will need a blank database ready with a user assigned to it."
 
echo
echo -n "Do you have all of your database information? (y/n) "
 
read dbinfo
 
if [ "$dbinfo" = "y" ]; then
    echo

    echo -n "Specify desired Magento version (e.g. 1.7.0.2): "
    read version

    magento_tar=magento-$version.tar.gz
    magento_url=http://www.magentocommerce.com/downloads/assets/$version/$magento_tar

    echo -n "Database Host (usually localhost): "
    read dbhost

    echo -n "Database Name: "
    read dbname

    echo -n "Database User: "
    read dbuser

    echo -n "Database Password: "
    read dbpass

    echo -n "Store URL (e.g http://store.local/, remember trailing slash!): "
    read url

    echo -n "Admin Username: "
    read adminuser

    echo -n "Admin Password: "
    read adminpass

    echo -n "Admin First Name: "
    read adminfname

    echo -n "Admin Last Name: "
    read adminlname

    echo -n "Admin Email Address: "
    read adminemail

    echo -n "Default Locale (e.g. en_US): "
    read locale

    echo -n "Default Timezone (e.g. America/Los_Angeles): "
    read timezone

    echo -n "Default Currency (e.g. USD): "
    read currency

    echo -n "Include Sample Data? (y/n) "
    read sample
   
    if [ "$sample" = "y" ]; then
        echo -n "Specify Sample Data version (e.g. 1.2.0): "
        read sample_version

        sample_tar=magento-sample-data-$sample_version.tar.gz
        sample_dir=magento-sample-data-$sample_version
        sample_sql=$sample_dir/magento_sample_data_for_$sample_version.sql
        sample_url=http://www.magentocommerce.com/downloads/assets/$sample_version/$sample_tar
    fi

    echo
    echo "Now installing Magento..."

    echo
    echo "Downloading packages..."
    echo
       
    wget $magento_url

    if [ "$sample" = "y" ]; then
        wget $sample_url
    fi
       
    echo
    echo "Extracting data..."
    echo
       
    tar -zxvf $magento_tar

    if [ "$sample" = "y" ]; then
        tar -zxvf $sample_tar
    fi
       
    echo
    echo "Moving files..."
    echo
       
    mv magento/* magento/.htaccess .

    if [ "$sample" = "y" ]; then
        mv $sample_dir/media/* ./media/
        mv sample_sql ./data.sql
    fi

    echo
    echo "Setting permissions..."
    echo
       
    chmod o+w var var/.htaccess app/etc
    chmod -R o+w media

    if [ "$sample" = "y" ]; then
        echo
        echo "Importing sample products..."
        echo
       
        mysql -h $dbhost -u $dbuser -p$dbpass $dbname < data.sql
    fi
       
    echo
    echo "Cleaning up files..."
    echo
       
    rm -rf downloader/pearlib/cache/* downloader/pearlib/download/*
    rm -rf magento/
    rm -rf $magento_tar

    if [ "$sample" = "y" ]; then
        rm -rf $sample_dir/
        rm -rf $sample_tar data.sql
    fi

    echo
    echo "Installing Magento..."
    echo
       
    php -f install.php -- --license_agreement_accepted "yes"  --skip_url_validation "yes" --locale "$locale" --timezone "$timezone"  --default_currency "$currency" --db_host "$dbhost" --db_name "$dbname" --db_user "$dbuser" --db_pass "$dbpass" --url "$url" --use_rewrites "yes" --use_secure "no" --secure_base_url "$url" --use_secure_admin "no" --admin_firstname "$adminfname" --admin_lastname "$adminlname" --admin_email "$adminemail" --admin_username "$adminuser" --admin_password "$adminpass"
    echo
    echo "Finished installing Magento"
    echo

    exit
else
    echo
    echo "Please setup a database first. Don't forget to assign a database user!"
   
    exit
fi
