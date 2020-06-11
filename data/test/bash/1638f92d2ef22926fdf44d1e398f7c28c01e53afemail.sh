#/bin/sh

#register email
#PROCESS_NUM=`ps -ef | grep "index.php interval regt_noti" | grep -v "grep" | wc -l`
#while [ $PROCESS_NUM -lt  6 ] 
#do
#	PROCESS_NUM=`expr $PROCESS_NUM + 1`
#    /usr/bin/nohup /usr/bin/php -f /var/vanuatuvisa.cn/www/www/index.php interval regt_noti > /dev/null 2>&1 &
#done

#apply email
#PROCESS_NUM=`ps -ef | grep "index.php interval pass_noti" | grep -v "grep" | wc -l`
#while [ $PROCESS_NUM -lt  6 ] 
#do
#	PROCESS_NUM=`expr $PROCESS_NUM + 1`
#    /usr/bin/nohup /usr/bin/php -f /var/vanuatuvisa.cn/www/www/index.php interval pass_noti > /dev/null 2>&1 &
#done

#visa email
#PROCESS_NUM=`ps -ef | grep "index.php interval visa_noti" | grep -v "grep" | wc -l`
#while [ $PROCESS_NUM -lt  6 ] 
#do
#	PROCESS_NUM=`expr $PROCESS_NUM + 1`
#    /usr/bin/nohup /usr/bin/php -f /var/vanuatuvisa.cn/www/www/index.php interval visa_noti > /dev/null 2>&1 &
#done

#auto visa 
PROCESS_NUM=`ps -ef | grep "index.php interval auto_visa" | grep -v "grep" | wc -l`
while [ $PROCESS_NUM -lt  6 ] 
do
	PROCESS_NUM=`expr $PROCESS_NUM + 1`
    /usr/bin/nohup /usr/bin/php -f /var/vanuatuvisa.cn/www/www/index.php interval auto_visa > /dev/null 2>&1 &
done

exit