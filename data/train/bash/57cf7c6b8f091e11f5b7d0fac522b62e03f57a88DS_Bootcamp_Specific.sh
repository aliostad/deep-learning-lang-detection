# With the Apple addition of one package that contains BootCamp4 for all Lion supported machines this is deprecated

#!/bin/sh
#Script to install Windows specific version by machine model to address BootCamp 3 vs 4

#Known models that support BootCamp 4 and should not be listed in the "if" condition are:
	#iMac12,1 (21.5" mid2011)
	#iMac12,2 (27" mid2011)
	#MacBookAir4,1 (11" mid2011)
	#MacBookAir4,2 (13" mid2011)
	#MacBookPro8,1 (13" late2011)
	#MacBookPro8,2 (15" late2011)
	#MacBookPro8,2 (17" late2011)
	#Macmini5,1 (2.3 GHz mid2011) 
	#Macmini5,2 (2.5/2.7GHz GHz mid2011) 
	#Macmini5,3 (server mid2011) 
	#MacPro5,1 (mid	2010)
	
if
[ "$DS_MODEL_IDENTIFIER" == "iMac6,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "iMac7,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "iMac8,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "iMac9,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "iMac10,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "iMac11,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "iMac11,2" ] ||
[ "$DS_MODEL_IDENTIFIER" == "iMac11,3" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookAir1,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookAir2,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookAir3,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookAir3,2" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro4,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro5,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro5,2" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro5,3" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro5,5" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro6,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro6,2" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBookPro7,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBook5,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBook5,2" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBook6,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacBook7,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "Macmini2,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "Macmini3,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "Macmini4,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacPro1,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacPro2,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacPro3,1" ] ||
[ "$DS_MODEL_IDENTIFIER" == "MacPro4,1" ]; then
  if [ "`echo $DS_CURRENT_WORKFLOW_TITLE | grep x86`" != "" ]; then
	echo "RuntimeSelectWorkflow: Z Win7 32bit Bootcamp3 (script selected)"
  else
	echo "RuntimeSelectWorkflow: Z Win7 64bit Bootcamp3 (script selected)"
  fi
else
  if [ "`echo $DS_CURRENT_WORKFLOW_TITLE | grep x86`" != "" ]; then
  	echo "RuntimeSelectWorkflow: Z Win7 32bit Bootcamp4 (script selected)"
  else
	echo "RuntimeSelectWorkflow: Z Win7 64bit Bootcamp4 (script selected)"
  fi
fi
exit 0