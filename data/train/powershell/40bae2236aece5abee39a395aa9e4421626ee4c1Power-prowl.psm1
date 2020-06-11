#######################################################################################################################
# File:             Power-Prowl.psm1                                                                                  #
# Author:           George                                                                                            #
# Publisher:        test                                                                                              #
# Copyright:        © 2013 test. All rights reserved.                                                                 #
# Usage:            To load this module in your Script Editor:                                                        #
#                   1. Open the Script Editor.                                                                        #
#                   2. Select "PowerShell Libraries" from the File menu.                                              #
#                   3. Check the Power-Prowl module.                                                                  #
#                   4. Click on OK to close the "PowerShell Libraries" dialog.                                        #
#                   Alternatively you can load the module from the embedded console by invoking this:                 #
#                       Import-Module -Name System.Object[]                                                           #
#                   Please provide feedback on the PowerGUI Forums.                                                   #
#######################################################################################################################

function Send-Prowl($apikey, $priority, $application, $event, $description, $url) {
	Invoke-WebRequest "https://api.prowlapp.com/publicapi/add?apikey=$apikey&priority=$priority&application=$application&event=$event&description=$description&url=$url"
}

