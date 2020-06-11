#TODOs:
#is there a time zone conversion issue? looks like the JSON is providing incorrect times. html output is good.

$numberOfDaysAgo = 1;
$watchLabel="watch";
$smtpServer="localhost"
$from="support@localhost.com"
$subject="Watched Cases Report"	
$BASEURL = "http://localhost/bootstrap/api/histories/case"		
$authToken = "877C932F-355C-4571-84C1-BB33CBEBBB9E";
$CRLF = "`r`n";

$DebugPreference = "Stop" 						#powershell will show the message and then halt.
$DebugPreference = "Inquire" 					#powershell will prompt the user.
$DebugPreference = "SilentlyContinue" #powershell will not show the message. 
#$DebugPreference = "Continue" 				#powershell will show the debug message.
			
#source other scripts
. .\DovetailCommonFunctions.ps1
. .\HtmlHelpers.ps1
. .\WatchedCasesCss.ps1
   
$ClarifyApplication = create-clarify-application; 
$ClarifySession = create-clarify-session $ClarifyApplication; 

$timeAgo = (get-date).AddDays($numberOfDaysAgo * -1);

function GetWatchers(){
	#get the list of distinct users
	$dataSet = new-object FChoice.Foundation.Clarify.ClarifyDataSet($ClarifySession);
	$usersGeneric = $dataSet.CreateGeneric("labeled_case_alst");
	$usersGeneric.AppendFilter("label", "Equals", $watchLabel);
	$usersGeneric.AppendFilter("entry_time", "After", $timeAgo);
	$usersGeneric.DataFields.Add("label_owner_name")  > $null;
	$usersGeneric.IsDistinct = $True;	
	$usersGeneric.Query();
	$usersGeneric.Rows;
}

function GetWatchedCases(){
	foreach( $row in $input){
		log-debug("getting watched cases for " + $row["label_owner_name"]);
		
		$dataSet = new-object FChoice.Foundation.Clarify.ClarifyDataSet($ClarifySession)
		$watchedCasesGeneric = $dataSet.CreateGeneric("labeled_case_alst")
		$watchedCasesGeneric.AppendFilter("label", "Equals", $watchLabel);
		$watchedCasesGeneric.AppendFilter("entry_time", "After", $timeAgo);
		$watchedCasesGeneric.AppendFilter("label_owner_name", "Equals", $row["label_owner_name"]);
		$watchedCasesGeneric.DataFields.Add("parent_id")  > $null;
		$watchedCasesGeneric.IsDistinct = $True;
		$watchedCasesGeneric.Query();

		$caseIdArray = @();
		foreach( $case in $watchedCasesGeneric.Rows){
			$caseIdArray+=$case["parent_id"];  
		} 
		$caseIds = $caseIdArray -join ',';

		$cases = New-Object System.Object;							
		add-member -in $cases noteproperty watcher $row["label_owner_name"];
		add-member -in $cases noteproperty caseIds $caseIds;
			
		$cases;
	} 
} 

function GetCaseHistories(){
	$acceptHeader = "application/json";
	#$acceptHeader = "text/html";

	foreach( $i in $input){		
		$webClient = new-object "System.Net.WebClient"
		$webClient.Headers.Add("Accept", $acceptHeader);

		log-debug("getting case histories for " + $i.watcher + " since " + $timeAgo);
				
		#$URL=$BASEURL+'?Ids=' + $i.caseIds + '&Since=TODAY-' + $numberOfDaysAgo + '&authToken=' + $authToken;
		$URL=$BASEURL+'?Ids=' + $i.caseIds + '&Since=' + $timeAgo + '&authToken=' + $authToken;

		log-debug("getting URL: " + $URL);
				    
		try {
				$response = $webclient.DownloadString($URL);
				$response = $response | add-member noteproperty watcher $i.watcher -passThru;				
				$response;
		}
		catch [Net.WebException] {
				$e = $_.Exception
				$response = $e.Response;
				$requestStream = $response.GetResponseStream()
				$readStream = new-object System.IO.StreamReader $requestStream
				new-variable db
				$db = $readStream.ReadToEnd()
				$readStream.Close()
				$response.Close()
				$db;		
				$httpStatusCode = [int]$response.StatusCode
				log-error("HTTP Status:" + $httpStatusCode);
				log-error($db);
				#exit;
		}		
	}
}

function SendEmail(){	
	foreach( $message in $input){
		$row = get-empl-view-by-login-name $message.watcher;
		$to = $row["e_mail"];

		log-debug("sending email to " + $to);
		
		$smtpmail = [System.Net.Mail.SMTPClient]("$smtpServer")
		$smtpmail.Credentials = New-Object System.Net.NetworkCredential("support@localhost.com", "support");
		$mailMessage = new-object System.Net.Mail.MailMessage($from, $to);
		$mailMessage.Subject = $subject;
		$mailMessage.IsBodyHTML = $True;
		$mailMessage.Body = $message;
		$smtpmail.Send($mailMessage);
		}	
}
    
function ParseJSONIntoHTML(){
	add-type -assembly system.web.extensions
	$jsSerializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer

	foreach( $json in $input){
		log-debug("Parsing JSON Into HTML");
		
		$jsonResult = $jsSerializer.DeserializeObject( $json ) 
		$messageBody = "";
		$messageBody+=css;
	
		$messageBody+= header1("Recent activity on your watched cases")
		#$messageBody+=paragraph("The following activity occured on your watched cases since " + $jsonResult["Since"] );
				
		$items = $jsonResult["HistoryItems"];
		$previousId = "";
		
		foreach ($item in $items){
			if ($previousId -ne $item["Id"]){
				$previousId = $item["Id"];

				$caseRow = get-caseview-by-id $item["Id"]

				$caseIdLink = "<a href=http://localhost/mobile/Cases/Summary/" + $item["Id"] + ">" + (Get-Culture).TextInfo.ToTitleCase($item["Type"]) + " " + $item["Id"] + "</a>"
				$messageBody+=header2($caseIdLink);	
				
				$messageBody+=div "" "summary"
				$messageBody+= paragraph($caseRow["title"]);																										
				$messageBody+=paragraph("From " + $caseRow["first_name"] + " " +  $caseRow["last_name"] + " at " + $caseRow["site_name"])				
				$messageBody+= paragraph("Owned by " +  $caseRow["owner"]);
				
				if ($caseRow["condition"] -eq "Closed"){
					$messageBody+= paragraph("Case is Closed")	
				}else{
					$messageBody+= paragraph("Case is Open with a status of " + $caseRow["status"])					
				}
				$messageBody+=endDiv;											
			}				

			$messageBody+=div "" "history"
						
				$messageBody+=div "" "history-header"													
					$by = " by " + $item["Who"]["Name"];					
					$at = " at " + $item["When"]
					$messageBody+=$item["Title"] + "<span class=who-when>" + $by + $at + "</span>";					
				$messageBody+=endDiv;

				$messageBody+=div "" "history-body"
			
					if ($item["Detail"].length -gt 0){ 
						$messageBody+=$item["Detail"]
					}			
					if ($item["Internal"].length -gt 0){ 
						$messageBody+=div "Internal Notes:" "internal-header"
						$messageBody+=endDiv;
						$messageBody+=div $item["Internal"] "internal"
						$messageBody+=endDiv;
					}
				$messageBody+=endDiv;
			$messageBody+=endDiv;
		}
		
		$messageBody+=footer("Brought to you by Dovetail Software")
		
		$messageBody = $messageBody | add-member noteproperty watcher $json.watcher -passThru;								
		$messageBody;
	}
}

$results = GetWatchers | GetWatchedCases  | GetCaseHistories | ParseJSONIntoHTML | SendEmail;
#$results;
