try
{
	if($env:IsGithubRelease)
	{
		#Create Folder Structure
		New-Item -Force -ItemType directory -Path build\lib\net35
		New-Item -Force -ItemType directory -Path build\lib\net45


		#Copy Files into folders
		Copy-Item -Force "Appenders\CloudWatchAppender\bin\Release\AWSAppender.CloudWatch.dll" "build\lib\net45"
		Copy-Item -Force "Appenders\CloudWatchAppender\bin\Release\AWSAppender.CloudWatch.pdb" "build\lib\net45"
		Copy-Item -Force "Appenders\CloudWatchLogsAppender\bin\Release\AWSAppender.CloudWatchLogs.dll" "build\lib\net45"
		Copy-Item -Force "Appenders\CloudWatchLogsAppender\bin\Release\AWSAppender.CloudWatchLogs.pdb" "build\lib\net45"
		Copy-Item -Force "AWSAppender.Core\bin\Release\AWSAppender.Core.dll" "build\lib\net45"
		Copy-Item -Force "AWSAppender.Core\bin\Release\AWSAppender.Core.pdb" "build\lib\net45"

		Copy-Item -Force "Appenders\CloudWatchAppender3.5\bin\Release\AWSAppender.CloudWatch.dll" "build\lib\net35"
		Copy-Item -Force "Appenders\CloudWatchAppender3.5\bin\Release\AWSAppender.CloudWatch.pdb" "build\lib\net35"
		Copy-Item -Force "Appenders\CloudWatchLogsAppender3.5\bin\Release\AWSAppender.CloudWatchLogs.dll" "build\lib\net35"
		Copy-Item -Force "Appenders\CloudWatchLogsAppender3.5\bin\Release\AWSAppender.CloudWatchLogs.pdb" "build\lib\net35"
		Copy-Item -Force "AWSAppender.Core3.5\bin\Release\AWSAppender.Core.dll" "build\lib\net35"
		Copy-Item -Force "AWSAppender.Core3.5\bin\Release\AWSAppender.Core.pdb" "build\lib\net35"


		$nuspecPath = (Get-ChildItem -Filter CloudWatchAppender.nuspec -Recurse ).FullName

		nuget pack $nuspecPath

		Remove-Item -Recurse -Path build\lib\net35\*
		Remove-Item -Recurse -Path build\lib\net45\*


		#Copy Files into folders
		Copy-Item -Force "AWSAppender.Core\bin\Release\AWSAppender.Core.dll" "build\lib\net45"
		Copy-Item -Force "AWSAppender.Core\bin\Release\AWSAppender.Core.pdb" "build\lib\net45"

		Copy-Item -Force "AWSAppender.Core3.5\bin\Release\AWSAppender.Core.dll" "build\lib\net35"
		Copy-Item -Force "AWSAppender.Core3.5\bin\Release\AWSAppender.Core.pdb" "build\lib\net35"


		$nuspecPath = (Get-ChildItem -Filter AWSAppender.Core.nuspec -Recurse ).FullName

		nuget pack $nuspecPath

		Remove-Item -Recurse -Path build\lib\net35\*
		Remove-Item -Recurse -Path build\lib\net45\*


		#Copy Files into folders
		Copy-Item -Force "Appenders\CloudWatchAppender\bin\Release\AWSAppender.CloudWatch.dll" "build\lib\net45"
		Copy-Item -Force "Appenders\CloudWatchAppender\bin\Release\AWSAppender.CloudWatch.pdb" "build\lib\net45"

		Copy-Item -Force "Appenders\CloudWatchAppender3.5\bin\Release\AWSAppender.CloudWatch.dll" "build\lib\net35"
		Copy-Item -Force "Appenders\CloudWatchAppender3.5\bin\Release\AWSAppender.CloudWatch.pdb" "build\lib\net35"


		$nuspecPath = (Get-ChildItem -Filter AWSAppender.CloudWatch.nuspec -Recurse ).FullName

		nuget pack $nuspecPath

		Remove-Item -Recurse -Path build\lib\net35\*
		Remove-Item -Recurse -Path build\lib\net45\*


		#Copy Files into folders
		Copy-Item -Force "Appenders\CloudWatchLogsAppender\bin\Release\AWSAppender.CloudWatchLogs.dll" "build\lib\net45"
		Copy-Item -Force "Appenders\CloudWatchLogsAppender\bin\Release\AWSAppender.CloudWatchLogs.pdb" "build\lib\net45"

		Copy-Item -Force "Appenders\CloudWatchLogsAppender3.5\bin\Release\AWSAppender.CloudWatchLogs.dll" "build\lib\net35"
		Copy-Item -Force "Appenders\CloudWatchLogsAppender3.5\bin\Release\AWSAppender.CloudWatchLogs.pdb" "build\lib\net35"


		$nuspecPath = (Get-ChildItem -Filter AWSAppender.CloudWatchLogs.nuspec -Recurse ).FullName

		nuget pack $nuspecPath

		Remove-Item -Recurse -Path build\lib\net35\*
		Remove-Item -Recurse -Path build\lib\net45\*

		#Copy Files into folders
		Copy-Item -Force "Appenders\SQSAppender\bin\Release\AWSAppender.SQS.dll" "build\lib\net45"
		Copy-Item -Force "Appenders\SQSAppender\bin\Release\AWSAppender.SQS.pdb" "build\lib\net45"

		Copy-Item -Force "Appenders\SQSAppender3.5\bin\Release\AWSAppender.SQS.dll" "build\lib\net35"
		Copy-Item -Force "Appenders\SQSAppender3.5\bin\Release\AWSAppender.SQS.pdb" "build\lib\net35"


		$nuspecPath = (Get-ChildItem -Filter AWSAppender.SQS.nuspec -Recurse ).FullName

		nuget pack $nuspecPath

		Remove-Item -Recurse -Path build\lib\net35\*
		Remove-Item -Recurse -Path build\lib\net45\*



		#Copy Files into folders
		Copy-Item -Force "Appenders\SNSAppender\bin\Release\AWSAppender.SNS.dll" "build\lib\net45"
		Copy-Item -Force "Appenders\SNSAppender\bin\Release\AWSAppender.SNS.pdb" "build\lib\net45"

		Copy-Item -Force "Appenders\SNSAppender3.5\bin\Release\AWSAppender.SNS.dll" "build\lib\net35"
		Copy-Item -Force "Appenders\SNSAppender3.5\bin\Release\AWSAppender.SNS.pdb" "build\lib\net35"


		$nuspecPath = (Get-ChildItem -Filter AWSAppender.SNS.nuspec -Recurse ).FullName

		nuget pack $nuspecPath

		Remove-Item -Recurse -Path build\lib\net35\*
		Remove-Item -Recurse -Path build\lib\net45\*

	}
}
catch 
{
	Write-Host $_.Exception.GetType().FullName, $_.Exception.Message
}
