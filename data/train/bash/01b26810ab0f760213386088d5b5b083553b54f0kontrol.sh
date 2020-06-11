#/usr/bin/!
# Sistem Load Degeri load="" arasindaki degeri astiginda program calisip servislerinize reset atacak
load="60"


######### Resetlenecek servisler baslar #########
loadkomutu=`uptime | awk -F "load average: " '{ print $2 }' | cut -d, -f1 | cut -d. -f1`
mailload=`uptime | awk -F "load average: " '{ print $2 }' | cut -d, -f1`

if [ "$loadkomutu" -ge "$load" ]
then
######### Resetlenecek servisler baslar #########
pkill -9 httpd
######### Resetlenecek servisler biter #########

zaman=`date +"%d.%m.%Y - %T"`
echo "Servisler en son su tarihte yeniden baslatildi : $zaman" >> /var/log/kontrol.load

TMP_PREFIX='/tmp/gidenmail'
TMP_FILE="mktemp $TMP_PREFIX.XXXXXXXX"
mailicerigi=`$TMP_FILE`

echo "Tarih : $zaman" > $mailicerigi
echo "Sistem Load Yuksek: $mailload" >> $mailicerigi

cat "$mailicerigi" |  mail -s "$zaman UYARI: Yuksek Load $mailload" $1

else
echo "Sorun yok"
/etc/init.d/httpd start
fi