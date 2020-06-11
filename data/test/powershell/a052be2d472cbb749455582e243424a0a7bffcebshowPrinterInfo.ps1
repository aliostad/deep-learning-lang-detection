# show printer information

get-wmiobject -class Win32_Printer | 
convertto-html Name,Default,Network,PortName,DriverName,ServerName,ShareName -head "<title>All printers available on $env:computername</title>`n<style type=`"text/css`">`nbody { padding: 8px; line-height: 1.33 }`ntable { border-style: ridge }`ntd, th { padding: 10px; border-style: dotted; border-width: 1px }`nth { font-weight: bolder; text-align: center }`n</style>" | 
out-file -FilePath "showprnh.html" -Encoding "ASCII"

invoke-item "showprnh.html"