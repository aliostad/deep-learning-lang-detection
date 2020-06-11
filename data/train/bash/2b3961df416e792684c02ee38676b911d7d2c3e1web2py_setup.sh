#!/bin/bash
cd /home/www-data/web2py
/sbin/setuser www-data /usr/bin/python -c "from gluon.main import save_password; save_password('$PW',443)"
/sbin/setuser www-data /usr/bin/python -c "from gluon.main import save_password; save_password('$PW',80)"
#echo "web2py admin password set to $PW"
cat << "EOF"

 __          __  _    ___              
 \ \        / / | |  |__ \             
  \ \  /\  / /__| |__   ) |_ __  _   _ 
   \ \/  \/ / _ \ '_ \ / /| '_ \| | | |
    \  /\  /  __/ |_) / /_| |_) | |_| |
     \/  \/ \___|_.__/____| .__/ \__, |
                          | |     __/ |
                          |_|    |___/ 

EOF
