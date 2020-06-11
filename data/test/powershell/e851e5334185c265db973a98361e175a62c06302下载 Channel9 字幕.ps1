Add-Type -AssemblyName "System.Web"


$url= New-Object "System.Uri" "http://channel9.msdn.com/Series/Dev-ASP-MVC4-WebApps"

#en >> English
$lang="en"

$overwrite = $false


 

$client=New-Object  -TypeName  "System.net.WebClient"
$client.Encoding = [System.Text.Encoding]::UTF8 




Write-Host "get string $url .."
$html=$client.DownloadString($url)



$allmatches =$html| Select-String    -pattern '<a href="(?<link>[^"]*)" class="title">(?<name>[^<>]*)</a>' -AllMatches   | select-object matches

$Matches=$allmatches.Matches 

$dir = get-location
$progress = 0 
$pagepercent = 0 
$entries= $Matches.Count 


Write-Host save file to  $dir

foreach($m in $Matches)
{

	

	$name= [System.Web.HttpUtility]::HtmlDecode($m.Groups['name'].Value) 

	[System.Uri]$link=$null
	
	$r=[System.Uri]::TryCreate($url , [System.Web.HttpUtility]::HtmlDecode($m.Groups['link'].Value) + "/captions?f=webvtt&l=$lang",[ref]$link)
		

	$name=$name.Substring($name.LastIndexOf(":")+1).Trim()
	
	foreach($item in [System.IO.Path]::GetInvalidFileNameChars())
	{
		$name=$name.Replace($item ,"_")
	}
	
	foreach($item in [System.IO.Path]::GetInvalidPathChars())
	{
		$name=$name.Replace($item ,"_")
	}
	
	

	$saveFileName= join-path  $dir ($name + ".$lang.vtt")



 	if ((-not $overwrite) -and (Test-Path -path $saveFileName))     
    {        
        write-progress -activity "$saveFileName already downloaded" -status "$pagepercent% ($progress / $entries) complete" -percentcomplete $pagepercent    
    }    
    else     
    {        
        write-progress -activity "Downloading $saveFileName" -status "$pagepercent% ($progress / $entries) complete" -percentcomplete $pagepercent       
        &{#TRY
			Write-Host "Downloading ""$name"""
            $client.DownloadFile($link, $saveFileName)
        }
        trap  [Exception]{
            write-host
            write-host ("Unable to download " + $saveFileName  )
			write-host "Maybe not exist in specified language, check the link:"  $link
            continue; 
        }
    }  
	
    $pagepercent = [Math]::floor((++$progress)/$entries*100) 
	
			

}


Write-Host "Done."