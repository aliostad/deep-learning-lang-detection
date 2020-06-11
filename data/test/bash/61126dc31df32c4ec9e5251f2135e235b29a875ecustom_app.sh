
apkBaseName=$1
tempSmaliDir=$2

if [ "$apkBaseName" = "Phone" ];then
	echo ">>> in custom_app $apkBaseName"
	find $tempSmaliDir -name "*.xml" | xargs sed -i 's/%%//g'
	find $tempSmaliDir -name "*.xml" | xargs sed -i 's/ %[ )\%]/ /g'
	find $tempSmaliDir -name "*.xml" | xargs sed -i 's/\(%[0-9]\$[ds]\)%/\1/g'
	find $tempSmaliDir -name "*\.smali" | xargs sed -i 's#invoke-interface\(.*Lcom/android/internal/telephony/IccCard;->\)#invoke-virtual\1#g'

        sed -i '/PhoneApp;->phoneMgr/r Phone/smali/com/android/phone/PhoneApp.part' $tempSmaliDir/smali/com/android/phone/PhoneApp.smali

elif [ "$apkBaseName" = "Settings" ];then
        echo ">>> in custom_app $apkBaseName"
	#find $tempSmaliDir/ -name "*.smali" | xargs sed -i 's#/proc/version#/etc/version#g'  
	find $tempSmaliDir -name "*\.smali" | xargs sed -i 's#invoke-interface\(.*Lcom/android/internal/telephony/IccCard;->\)#invoke-virtual\1#g'

fi

