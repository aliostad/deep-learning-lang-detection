# Shut down unneeded processes
#PrepareDemoEnvironment

# First clean the target directory
#Get-ChildItem C:\development\demo\WebApi -recurse | Remove-Item -Recurse -Force

# Copy Snippets
$ScriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent

copy-item $ScriptDir\snippets\WebApi-CSSnippets -Destination "$env:userprofile\Documents\Visual Studio 2012\Code Snippets\Visual C#\My Code Snippets" -Recurse -Force
copy-item $ScriptDir\snippets\WebApi-HtmlSnippets -Destination "$env:userprofile\Documents\Visual Studio 2012\Code Snippets\Visual Web Developer\My HTML Snippets" -Recurse -Force
copy-item $ScriptDir\snippets\WebApi-JSSnippets -Destination "$env:userprofile\Documents\Visual Studio 2012\Code Snippets\Visual Web Developer\My JScript Snippets" -Recurse -Force

#copy-item $ScriptDir\src\Begin\WebApiDemo -Destination C:\development\demo\WebApi\WebApiDemo -Recurse -Force

#Start-Process -FilePath C:\development\demo\WebApi\WebApiDemo\WebApiDemo.sln
#Start-Process -FilePath "$ScriptDir\docs\WebAPI.pptx"