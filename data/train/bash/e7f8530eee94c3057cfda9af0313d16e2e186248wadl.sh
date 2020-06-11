
# **************** Change Variables Here ************  
startdirectory="/Users/Neha/Desktop/SampleWadl" 
Basepath="" 
#Example http://<org>-prod.apigee.net/
Sample_Resource1=""
#Example: products
Sample_Resource2=""
#Example catalogues
Sample_Resource3=""	
#Example prices
Sample=""
# Name of your application like EnterpriseStickers
apikey_basic=""
apikey_partner=""
apikey_premium=""
param11=""
#Query Param Name for your 1st resource
param11_default=""
#Query Param Default Value for your 1st resource
param12=""
param12_default=""
param21=""
param21_default=""
param22=""
param22_default=""
param31=""
param31_default=""
param32=""
param32_default=""
# **********************************************************  
  
echo "*******************************************"  
echo "*Replacing all the parameters in WADL file*"  
echo "*******************************************"  
  
        
  sed -i.bu 's/basepath/'$Basepath'/' Sample-wadl.xml
  
  sed -i.bu 's/Sample_Resource1/'$Sample_Resource1'/' Sample-wadl.xml
  
  sed -i.bu 's/Sample_Resource2/'$Sample_Resource2'/' Sample-wadl.xml
  
  sed -i.bu 's/Sample_Resource3/'$Sample_Resource3'/' Sample-wadl.xml
  
  sed -i.bu 's/Sample/'$Sample'/' Sample-wadl.xml
  
  
  sed -i.bu 's/apikey_basic/'$apikey_basic'/g' Sample-wadl.xml
  
  sed -i.bu 's/apikey_partner/'$apikey_partner'/g' Sample-wadl.xml
    
  sed -i.bu 's/apikey_premium/'$apikey_premium'/g' Sample-wadl.xml
  
  
  sed -i.bu 's/param11/'$param11'/' Sample-wadl.xml
  
  sed -i.bu 's/param12/'$param12'/' Sample-wadl.xml
  
  sed -i.bu 's/param21/'$param21'/' Sample-wadl.xml
  
  sed -i.bu 's/param22/'$param22'/' Sample-wadl.xml
  
  sed -i.bu1 's/param31/'$param31'/' Sample-wadl.xml
  
  sed -i.bu1 's/param32/'$param32'/' Sample-wadl.xml
  
  
  sed -i.bu1 's/param11_default/'$param11_default'/' Sample-wadl.xml
  
  sed -i.bu1 's/param12_default/'$param12_default'/' Sample-wadl.xml
  
  sed -i.bu1 's/param21_default/'$param21_default'/' Sample-wadl.xml
  
  sed -i.bu1 's/param22_default/'$param22_default'/' Sample-wadl.xml
  
  sed -i.bu1 's/param31_default/'$param31_default'/' Sample-wadl.xml
  
  sed -i.bu1 's/param32_default/'$param32_default'/' Sample-wadl.xml
  
  
echo " *** Yay! All Done! *** "  