#!/bin/bash
#
# please notice: all provisioning scripts have to be idempotent
#

# include global configuration
. /srv/deploy/vms/provision/common.sh

set -e 
RECIPE='repo'

echo "# -------------------------------------------------"
echo "# BEGIN Provisioning RECIPE $RECIPE"
echo "# -------------------------------------------------"

echo "Setting up repo vhost..."
if [ ! -f /etc/apache2/sites-available/repo ];then
cat << EOF > /etc/apache2/sites-available/repo
<VirtualHost *:80>
ServerName repo${DEPLOY_ENV_DOMAIN_SUFFIX}
ServerAlias repo

DocumentRoot /data/repo

<Directory /data/repo>
AllowOverride All
Order allow,deny
Allow from all
</Directory>

</VirtualHost>

EOF
fi
a2ensite repo
/etc/init.d/apache2 reload

echo "# -------------------------------------------------"
echo "# END Provisioning RECIPE $RECIPE"
echo "# -------------------------------------------------"