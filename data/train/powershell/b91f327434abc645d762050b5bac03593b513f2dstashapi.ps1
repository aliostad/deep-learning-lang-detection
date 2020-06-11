# Stash attributes
$stashUrl = 'http://stash'
$stashSshUrl = 'ssh://git@stash:7999'
$stashProject = 'SER'

# Local setup attributes
$projectRootDirectoryPath = 'c:\repos\stash\ser'
$useSshProtocol = $true

# Get credentials
$userName = read-host "Gimme your stash user name, default is $($env:UserName)"
$userName = if ($userName -ne '') { $userName } else { $env:UserName }
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((read-host 'Gimme your stash password' -assecurestring)));
$credentials = "$userName`:$password"

# Get stash projects information
$stashProjectsUrl = "$stashUrl/rest/api/1.0/projects"
$projects = convertfrom-json (curl -u $credentials $stashProjectsUrl)
# Echo info - lots of data here
#$projects.Values
# Echo names
#$projects.Values | select name

# Get stash repos information
$stashReposUrl = "$stashUrl/rest/api/1.0/projects/$stashProject/repos"
$repos = convertfrom-json (curl -u $credentials $stashReposUrl)
# Echo info - lots of data here
#$repos.Values
# Echo names
#$repos.Values | select name

# Clone if not already cloned
pushd
cd $projectRootDirectoryPath
foreach ($repoName in ($repos.Values).name)
{
	$repoName = $repoName.ToLower()
	$repoDirectoryPath = join-path $projectRootDirectoryPath $repoName
	if (! (test-path $repoDirectoryPath))
	{
		if ($useSshProtocol)
		{
			$stashRepoUrl = "$stashSshUrl/$stashProject/$repoName.git".ToLower()
			git clone $stashRepoUrl
		}
		else
		{
			write-host 'Have not taken care of http protocol'
		}
	}
}
popd


<#
Pretty version of http://stash/rest/api/1.0/projects/
Have removed all but the first repo - too much noise
{  
    "size":4,
    "limit":25,
    "isLastPage":true,
    "values":[  
        {  
            "key":"API",
            "id":104,
            "name":"ApiTeam",
            "public":false,
            "type":"NORMAL",
            "link":{  
                "url":"/projects/API",
                "rel":"self"
            },
            "links":{  
                "self":[  
                    {  
                        "href":"http://stash/projects/API"
                    }
                ]
            }
        },
		// More projects .... Removed
    ],
    "start":0
}


Pretty version of http://stash/rest/api/1.0/projects/ser/repos
Have removed all but the first repo - too much noise
{
    "size":17,
    "limit":25,
    "isLastPage":true,
    "values":[
        {
            "slug":"travelrepublic.adverts.service",
            "id":324,
            "name":"TravelRepublic.Adverts.Service",
            "scmId":"git",
            "state":"AVAILABLE",
            "statusMessage":"Available",
            "forkable":true,
            "project":{
                "key":"SER",
                "id":121,
                "name":"Services",
                "description":"Travel Republic Services",
                "public":false,
                "type":"NORMAL",
                "link":{
                    "url":"/projects/SER",
                    "rel":"self"
                },
                "links":{
                    "self":[
                        {
                            "href":"http://stash/projects/SER"
                        }
                    ]
                }
            },
            "public":false,
            "link":{
                "url":"/projects/SER/repos/travelrepublic.adverts.service/browse",
                "rel":"self"
            },
            "cloneUrl":"http://pmcgrath@stash/scm/ser/travelrepublic.adverts.service.git",
            "links":{
                "clone":[
                    {
                        "href":"http://pmcgrath@stash/scm/ser/travelrepublic.adverts.service.git",
                        "name":"http"
                    },
                    {
                        "href":"ssh://git@stash:7999/ser/travelrepublic.adverts.service.git",
                        "name":"ssh"
                    }
                ],
                "self":[
                    {
                        "href":"http://stash/projects/SER/repos/travelrepublic.adverts.service/browse"
                    }
                ]
            }
        },
		// More repos .... Removed
	]
    "start":0
}
#>