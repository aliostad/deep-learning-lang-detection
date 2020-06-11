[T4Scaffolding.Scaffolder()][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

Add-Template $coreProjectName "Model\MessageStatus" "MessageStatus" -Force:$Force $TemplateFolders

Add-Domain "Model\Attachment" "Attachment" -Force:$Force $TemplateFolders
Add-Domain "Model\Folder" "Folder" -Force:$Force $TemplateFolders
Add-Domain "Model\Message" "Message" -Force:$Force $TemplateFolders
Add-Domain "Model\MessageReceiver" "MessageReceiver" -Force:$Force $TemplateFolders