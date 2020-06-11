if([System.Diagnostics.EventLog]::Exists('PxWebAPI'))
   {
        Remove-EventLog -logname PxWebAPI 
   }

if([System.Diagnostics.EventLog]::Exists('Px_WebAPI'))
   {
        Remove-EventLog -logname Px_WebAPI 
   }
   

if(![System.Diagnostics.EventLog]::SourceExists('PxWebAPI'))
   {
        [System.Diagnostics.EventLog]::CreateEventSource('PxWebAPI','Application')
   }
