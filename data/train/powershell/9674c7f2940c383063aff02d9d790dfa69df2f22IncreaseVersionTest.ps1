#Load SharePoint CSOM assemblies

$bindir= "C:\Program Files\AvePoint\DocAve6\Agent\bin\2013\"
[System.Reflection.Assembly]::LoadFrom($bindir +"Microsoft.SharePoint.Client.dll")
[System.Reflection.Assembly]::LoadFrom($bindir +"Microsoft.SharePoint.Client.Runtime.dll")

#Assign values to the following arguments


#Enter the URL of the site collection or site where you want to create the files
$siteUrl = "http://win-sbiilnm7163:1000/sites/Test"

#Enter the server relative URL of the folder where you want to create the files 
$parentFolderUrl="/sites/Test/Test"

#Enter the location of the file that you want to use its content to create files
$contentLocation="C:\Users\chengcui\Desktop\111.docx"

#Enter the username and corresponding password to access the SharePoint site collection or site you have entered previously
$userName = "wrapper\chengcui"
$pwd="1qaz2wsxE"

#Enter the number of versions you want to increase for each file
$versionCount = 10

#Enter the number of files you want to create by using the content of the selected file
$fileCount =10

#Assign proper values to all of the arguments above

$siteUrl
$parentFolderUrl

$fileInfo =New-Object System.IO.FileInfo $contentLocation


#Initialize the credentials

$context = New-Object Microsoft.SharePoint.Client.ClientContext $siteUrl
$credentail = New-Object System.Net.NetworkCredential($userName,$pwd)
$context.Credentials = $credentail 


for($j =0; $j -lt $fileCount; $j++)
{

    $fileName=  [System.Guid]::NewGuid().ToString() +"_"+ "FileName"+ $fileInfo.Extension
    $fileUrl = $parentFolderUrl + "/" +$fileName


    #Upload the content of the selected file
    $fileStream=New-Object System.IO.FileStream $contentLocation ,"Open"

    $fileCreateInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation 
    $fileCreateInfo.Url=$fileUrl
    $fileCreateInfo.Overwrite=$true
    $fileCreateInfo.ContentStream = $fileStream

    $parentFolderObject=$context.Web.GetFolderByServerRelativeUrl($parentFolderUrl)

    $fileObject=$parentFolderObject.Files.Add($fileCreateInfo)

    $context.Load($fileObject)
    $context.ExecuteQuery()

    $fileStream.Close()


    for($i =0; $i -lt $versionCount; $i++)
    {

        #Increase versions
        #Check out the created files

        $fileObject.CheckOut()

        #Save content stream to the current version
        $file1=New-Object System.IO.FileStream $contentLocation ,"Open"

        $fileCreateInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation 
        $fileCreateInfo.Url=$fileUrl
        $fileCreateInfo.Overwrite=$true
        $fileCreateInfo.ContentStream = $file1

        $fileObject=$parentFolderObject.Files.Add($fileCreateInfo)


        #update metadata
        $fileObject.ListItemAllFields["FileLeafRef"]=$fileName
        $fileObject.ListItemAllFields["Editor"]=1
        $fileObject.ListItemAllFields["Modified"] = New-Object System.DateTime 2000,1,1,12,0,0,0
        $fileObject.ListItemAllFields.Update()

        #Check in the created file


        $fileObject.CheckIn("","MinorCheckIn")

        #Load file properties and then execute the previous actions

        $context.Load($fileObject)
        $context.Load($fileObject.ListItemAllFields)
        $context.ExecuteQuery()

        #Update the metadata related to the Modified column

        $fileObject.ListItemAllFields["FileLeafRef"]=$fileName
        $fileObject.ListItemAllFields["Editor"]=1
        $fileObject.ListItemAllFields["Modified"] = New-Object System.DateTime 2000,1,1,12,0,0,0

        $values = New-Object 'System.Collections.Generic.List[Microsoft.SharePoint.Client.ListItemFormUpdateValue]'
        $value = New-Object Microsoft.SharePoint.Client.ListItemFormUpdateValue
        $value.FieldName="FileLeafRef"
        $value.FieldValue= $fileName

        $values.Add($value)

        $fileObject.ListItemAllFields.ValidateUpdateListItem($values ,$true,"CheckInCommonTest")

        #Load file properties and then execute the previous actions

        $context.Load($fileObject)
        $context.Load($fileObject.ListItemAllFields)
        $context.ExecuteQuery()

        $file1.Close()

        Write-Output "Create File:" ,$fileName, "Current Version :"  , $fileObject.UIVersionLabel

    }

}






 