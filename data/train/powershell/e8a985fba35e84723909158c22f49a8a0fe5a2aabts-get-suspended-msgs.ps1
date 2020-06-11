#
# declare our parameters: the action to take, and an optional
# path to save messages to
#
param(
   [string] $action=$(throw 'need action'), 
   [string] $path=$(if ($action -eq 'save') { throw 'need path' })
)


#
# get all suspended messaging service instances,
# both resumable and not-resumable
#
function bts-get-messaging-svc-instances()
{
   get-wmiobject MSBTS_ServiceInstance `
      -namespace 'root\MicrosoftBizTalkServer' `
      -filter 'ServiceClass=4 and (ServiceStatus = 4 or ServiceStatus = 16)'
}

#
# save the message associated to the
# specified messaging Service Instance
#
function bts-save-message([string]$msgid)
{
   $msg = get-wmiobject MSBTS_MessageInstance `
      -namespace 'root\MicrosoftBizTalkServer' `
      -filter "ServiceInstanceID = '$msgid'"
   $msg.psbase.invokemethod('SaveToFile', ($path))
   "Message from ServiceInstanceID=$msgid saved."
}


#
# main script
#
switch ( $action )
{
   'list' {
      bts-get-messaging-svc-instances | 
         fl InstanceId, ServiceName, SuspendTime, HostName, 
            ServiceStatus, ErrorId, ErrorDescription
   }
   'save' {
      bts-get-messaging-svc-instances | 
         %{ bts-save-message($_.InstanceID) }
   }
}

