# ----- Copy Dynamics module to DSC server for distribution
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\Dynamics365' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Copy-item 'F:\github\SQLExtras' -Destination '\\sl-DSC.stratuslivedemo.com\c$\Program Files\WindowsPowerShell\Modules' -Recurse -Force

# ----- Copy to the share location on DSC
Copy-item 'F:\OneDrive - StratusLIVE, LLC\Scripts\Modules\Dynamics365' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force
Copy-item 'F:\github\SQLExtras' -Destination '\\sl-dsc.stratuslivedemo.com\c$\PSModules' -Recurse -Force