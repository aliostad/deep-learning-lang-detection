curl "http://www.sharp.cn/pci/get_data?var_type=purifier&newpage=1" | ruby -rjson -ne "JSON[\$_]['data'].each {|d| puts d['model']}" | xargs -I MODEL echo "http://www.sharp.cn/pci/MODEL" > urls.txt
curl "http://www.sharp.cn/pci/get_data?var_type=purifier&newpage=2" | ruby -rjson -ne "JSON[\$_]['data'].each {|d| puts d['model']}" | xargs -I MODEL echo "http://www.sharp.cn/pci/MODEL" >> urls.txt
curl "http://www.sharp.cn/pci/get_data?var_type=purifier&newpage=3" | ruby -rjson -ne "JSON[\$_]['data'].each {|d| puts d['model']}" | xargs -I MODEL echo "http://www.sharp.cn/pci/MODEL" >> urls.txt
curl "http://www.sharp.cn/pci/get_data?var_type=purifier&newpage=4" | ruby -rjson -ne "JSON[\$_]['data'].each {|d| puts d['model']}" | xargs -I MODEL echo "http://www.sharp.cn/pci/MODEL" >> urls.txt
curl "http://www.sharp.cn/pci/get_data?var_type=purifier&newpage=5" | ruby -rjson -ne "JSON[\$_]['data'].each {|d| puts d['model']}" | xargs -I MODEL echo "http://www.sharp.cn/pci/MODEL" >> urls.txt
