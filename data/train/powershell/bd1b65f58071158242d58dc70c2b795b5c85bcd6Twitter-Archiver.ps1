#Twitter Archiving Script
#
#   Created by City of Bellingham, WA (http://www.cob.org)
#   Version .1 (beta)
#	Last modified 10/6/2010 by Josh Nylander
#	
#	This script is designed to harvest all twitter entries a public
#	account.  This is done by downloading the "feed" of the last 20
#	entries on a regular scheduled basis in Twitter's XML format
#	and saved to the archive path by date/time.
#	No de-duplication or conversion	is performed.
#
#	This code is based on the api found at http://dev.twitter.com/doc/get/statuses/user_timeline
#	at the revision date listed above.
#
#	Output is the list of files saved.
#
#	Modify the script input values below
# 
#Script inputs
[String] $archivepath = 'c:\temp';			#path to save the file to
[String] $screen_name = 'TODO';				#screen_name to retrieve
[String] $count = '5';						#number of entries to retrieve each time

#-------------------------------------------------------------------------
Function Get-XMLviaHTTPGet ([String] $url, [String] $saveas, [Switch] $saveOnly=$false)
{

	#Note, lack of any error handling, that is a TODO
	$wc = new-object System.Net.WebClient;

	#Run query and load resulting XML
	[System.Xml.XmlDocument] $doc = new-object System.Xml.XmlDocument;
	$resultText = $wc.DownloadString($url);
	$doc.LoadXML($resultText);
	
	#Save if path specified
	if ($saveas -ne $null) {
		$doc.Save($saveas);
		if ($saveOnly -eq $false) {
			return $doc;
		}
	}else {
		return $doc;
	}
}

[String] $url = "http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=$screen_name&count=$count";
[String] $fileName = $archivepath + '\' + $screen_name + '-' + (Get-Date -Format yyyyMMddHHmm) + '.xml';
Get-XMLviaHTTPGet $url $fileName -saveOnly;
Write-Output $fileName;