#MiniPush (MP): Main Path PS Application Lives In
    param([string] $title)

#MP #1: Entry Script Page vars...
    $MiniPushHomeDir = "D:\Depot\Git\MiniPusher" #NOTE: Change This based on where you seat it
    $AppConfigPath = $MiniPushHomeDir + "\common\app.config"
    $ProjectSettingConfigPath = $MiniPushHomeDir + "\common\projectvalues.xml"
    $FunctionsPath = $MiniPushHomeDir + "\infrastructure"
    
#MP #2: Load Functions for MP
    #Empty from Scope JIC
    $MPFunctions = Get-Item function:MP.*
    If ( $MPFunctions)
    {
       $MPFunctions | Remove-Item
    }
    #Load into Scope
    if (Test-Path $FunctionsPath)
    {
        foreach ($i in Get-ChildItem $FunctionsPath -filter "*.ps1" -recurse)
        {   
            . $i.FullName 
        }
    }
    else
    {
        Throw "Functions dir not found. Please location the \infrastructure dir and seat it correctly."
    }
    $MPFunctions = Get-Item function:MP.*


#MP #3: Set some basic app vars and call the Config file loaders for setting app universal wide items 
   if ([String]::IsNullOrEmpty($title))
    {
        Throw "The $title parameter is required!"
    }
    else
    {
        if(!$global:appSettings)
        {
            $global:appSettings = @{}
        }
    }
   MP.AppSetting-Set -title "projecttitle" -value $title
   MP.AppSetting-Set -title "apppath" -value $MiniPushHomeDir

#MP #3.A Config Load Application Wide
  try
    {
        MP.Load-Config -path $AppConfigPath #Loads the application variables
    }
  catch
    { 
        Throw "Mini-Pusher could not load the application config!"
    } 
#MP #3.B Load by Project Title
  try
    {
        MP.Load-AppConfig -path $ProjectSettingConfigPath -projectTitle $title #Loads project based variables
    }
  catch
    { 
        Throw "Mini-Pusher could not load the prject level configurations!"
    }
    
#MP #3.C Gets the webproject version (I am updating assembly version/release number with a Team City config)
   try
    {
       $ProjectWebConfig = MP.AppSetting-Get -title "websiteassembly"
       $versionNumber = (Get-Command $ProjectWebConfig).FileVersionInfo.FileVersion
       MP.AppSetting-Set -title "currentversion" -value $versionNumber    
    }
   catch
    { 
        Throw "Mini-Pusher could not get and/or set the current version number to use."
    } 

#MP #4: Copy the static content local for hanlding
   try
    {
        MP.Handle-ScriptModel  #copy files to clobber locally 
    }
   catch
    { 
        Throw "Mini-Pusher could not find/copy static directory files local to clobber."
    } 
#MP #5: Handle the Minification of items
   try
    {
         MP.Handle-MinifyEngine  #minify and rename to match assembly version
    }
   catch
    { 
        Throw "Mini-Pusher encountered an error using Ajax Min."
    } 
#MP #6: Push to S3
   try
    {
        MP.Handle-AWSPush #sends the files up  
    }
   catch
    { 
        Throw "Mini-Pusher encountered an error attempting to push to Amazon."
    } 

#MPO Final: Any Clean-UP?
  MP.Clean-ProjectFolder
  MP.Quit  #Not sure if this is even needed? 
