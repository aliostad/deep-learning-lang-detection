#!/bin/bash
os_template=$2  # имя образа ОС для гостевой системы
vm_id=$1        # идентификатор гостевой системы
vzctl create ${vm_id} --ostemplate ${os_template} --config vps.basic    # создание гостевой системы на основе образа
vzctl set ${vm_id} --onboot yes --save  # запускать гостевую при старте системы
vzctl set ${vm_id} --hostname $3.trs.io --save # установить hostname гостевой
vzctl set ${vm_id} --ipadd 192.168.100.${vm_id} --save   # установить IP-адрес
vzctl set ${vm_id} --nameserver 8.8.8.8 --save      # установить DNS-адрес
vzctl set ${vm_id} --cpulimit 1000 --save        # установка процессорного времени
vzctl set ${vm_id} --diskspace 1800000:2000000 --save # дисковая квота
#vzctl set ${vm_id} --quotatime 600 --save
vzctl set ${vm_id} --privvmpages 512M:1024M --save
vzctl set ${vm_id} --vmguarpages 512M:1024M --save
#vzctl start ${vm_id}    # запуск гостевой системы
