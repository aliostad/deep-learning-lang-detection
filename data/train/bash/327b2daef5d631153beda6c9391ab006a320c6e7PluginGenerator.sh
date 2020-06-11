echo "enter the name of plugin:"
read plugin_name
while [  -d $plugin_name ]                            # check if the same plugin folder exist 
	do
		{
		echo " plugin exist, enter some other name:"
		read plugin_name
		}
	done

mkdir $plugin_name                                     # make a folder for your plugin
path=$(pwd)                                            # path is a variable which will store your current path
cp -r sample/* $path/$plugin_name/                     # copy the sample folder in your plugin folder
cd $plugin_name
sed -i "s/sample/$plugin_name/g" $path/$plugin_name/*  # replaces word sample with your plugin name in whole folder
mv sample.cpp $plugin_name.cpp                         # rename file sample.cpp to pluginname.cpp
mv sample.h $plugin_name.h                             # rename file sample.h to pluginname.h
mv sample.json $plugin_name.json                       # rename file sample.json to pluginname.json
mv sample.vcxproj $plugin_name.vcxproj                 # rename file sample.vcxproj to pluginname.vcxproj 
mv sample.pro $plugin_name.pro                         # rename file sample.pro to pluginname.pro
exit
