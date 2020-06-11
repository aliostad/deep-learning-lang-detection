##############################################################################
## SCRIPT:	PublishActivity.ps1
##
## PURPOSE:	This PowerShell script publishes a message to Socialcast
##
## Call this script like: 
##		PublishActivity.ps1 objectType objid activityEntryObjid
##
##############################################################################

param( [string] $objectType, [int] $objid, [int] $actEntryObjid) 

#source other scripts
. .\DovetailCommonFunctions.ps1

#constants
$URLBase = "http://server/dovetail/"  
$caseURLBase = $URLBase + "Cases/Summary/"  
$solutionURLBase = $URLBase + "Solutions/Show/"  
$tags = "#dovetailCRM";

$socialcastLoginName = "mySocialcastLoginName";
$socialcastPassword = "mySocialcastPassword";
$socialcastURL = "https://mySocialcastDomain.socialcast.com/api/"
$messagesURL = $socialcastURL + "messages.xml"

#validate input parameters
if ($objid -eq "" -or $actEntryObjid -eq "" -or $objectType -eq "") 
{
   write-host "Missing Required parameters."
   write-host "Usage:"
   write-host
   write-host "PublishActivity.ps1 objectType objid activityEntryObjid"
   write-host
   exit
}
   
$ClarifyApplication = create-clarify-application; 
$ClarifySession = create-clarify-session $ClarifyApplication; 

if ($objectType -eq "Case")
{
	$case = get-caseview-by-objid $objid;
	$actEntry = get-row-for-table-by-objid "case_alst" $actEntryObjid;
	
	$activity = $actEntry["act_name"];
	if ($activity -eq "Create" ){ $activity = "Created " + $objectType;}
	
	$title = $activity+ " for " + $case["first_name"] + " " + $case["last_name"] + " at " + $case["site_name"]
	$message = "Case Title: " + $case["title"]
	$url = $caseURLBase + $case["id_number"]  
}

if ($objectType -eq "Solution" -or $objectType -eq "probdesc" )
{
	$solution = get-row-for-table-by-objid "qry_finale_view" $objid;
	$actEntry = get-row-for-table-by-objid "fnl_alst" $actEntryObjid;
	
	$activity = $actEntry["act_name"];
	if ($activity -eq "Create" )
	{ 
		$title = "New Solution: " + $solution["title"];
		$message = "";
	}
	else
	{
		$title = "Solution Activity: " + $activity;
		$message =  "Title: " + $solution["title"]
	}
	
	$url = $solutionURLBase + $solution["id_number"]  
}

$messageXML = "<message>";
$messageXML+= "<title><![CDATA[" + $title + "]]></title>";  
$messageXML+= "<body><![CDATA[";
$messageXML+= $message;
$messageXML+= " " + $tags;
$messageXML+= "]]></body>";  
$messageXML+= "<url><![CDATA[" + $url + "]]></url>";  
$messageXML+= "</message>";

$webClient = new-object "System.Net.WebClient"
$webClient.Credentials = new-object System.Net.NetworkCredential($socialcastLoginName,$socialcastPassword )
$webClient.Headers.Add("Content-Type", "application/xml");
$response = $webClient.UploadString($messagesURL,$messageXML);

if ($webClient.ResponseHeaders["Status"] -eq 201)
{
	#Success!
}
