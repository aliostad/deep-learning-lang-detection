#
# Prepare a Windows 8 development machine for AngularJS development:
#
# run: http://boxstarter.org/package/nr/url?http://myurl/box/angular.txt
#

$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
Resolve-Path $scriptPath\functions\*.ps1 | % { . $_.ProviderPath }

Install-ChocolateyPackages
Install-VisualStudio
Install-RubyGems
Install-PythonPackages
Install-NodePackages
Install-PoshMonokai
Install-SublimeTextPackages
Set-EnvironmentVariables

Write-Host "Please install manually:

Visual Studio 2013 plugins:
- NCrunch
- ReSharper
- Web Essentials 2013
- Code Contracts

ReSharper plugins:
- NuGet Support for ReSharper
- xUnit.net Test Support
- AngularJS
- CleanCode
- TestCop

" -BackgroundColor Black -ForegroundColor Magenta

# in project after running 'yo angular':
# bower install angular-bootstrap --save
# bower install underscore
# npm install karma-jasmine --save-dev
# npm install karma-chrome-launcher --save-dev

# Later, also see this for remote ubuntu testing:
# https://github.com/exratione/protractor-selenium-server-vagrant

# for e2e testing:
# http://engineering.wingify.com/posts/e2e-testing-with-webdriverjs-jasmine/
