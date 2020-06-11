# usage: ./PxWebCustomEventLog  -computerName VSPXDEV02

Param(
  [string]$computerName
)


 if([System.Diagnostics.EventLog]::Exists('PxWebAPI'))
   {
        Remove-EventLog -computername $computerName -logname PxWebAPI -source PxWebAPI
   }

 if([System.Diagnostics.EventLog]::Exists('Px_WebAPI'))
   {
        Remove-EventLog -computername $computerName -logname Px_WebAPI -source PxWebAPI
   }
   

 if(![System.Diagnostics.EventLog]::SourceExists('PxWebAPI'))
   {
         [System.Diagnostics.EventLog]::CreateEventSource('PxWebAPI','Application')
   }