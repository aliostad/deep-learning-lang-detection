#YouTube Video Comments Archiving Script
#
#   Created by City of Bellingham, WA (http://www.cob.org)
#   Version .1 (beta)
#	Last modified 10/6/2010 by Josh Nylander
#	
#	This script is designed to harvest all comment feeds for public
#	videos by a given author.  The feeds are downloaded in their
#	native ATOM XML format and saved to the archive path by videoid
#	and date/time.  No de-duplication or conversion	is performed.
#
#	Note, the parameter for Get-YouTubeListVideoIDs can be modified to use any of the query options
#	per the http://code.google.com/apis/youtube/2.0/reference.html#Query_parameter_definitions
#
#	Output is the list of files saved.
#
#	Modify the script input values below
# 
#Script inputs
[String] $archivepath = 'c:\temp';		#Path to save XML files to
[String] $author = 'TODO';				#Author to retrieve video comments from

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
	if ($savepath -ne $null) {
		$doc.Save($saveas);
		if ($saveOnly -eq $false) {
			return $doc;
		}
	}else {
		return $doc;
	}
}

Function Get-YouTubeListVideoIDs([String] $urlquery) {
	[String] $url = "http://gdata.youtube.com/feeds/api/videos?$urlquery&v=2";
	[System.Xml.XmlDocument] $doc = Get-XMLviaHTTPGet($url);
    [System.Xml.XmlNodeList] $nodeList;
	$nodeList = $doc.GetElementsByTagName("videoid", "http://gdata.youtube.com/schemas/2007");
    foreach ($videoid in $nodeList){
    	$videoid.InnerText;
    }
}

Function Get-YouTubeVideoComments() {
	process {
		if ($_ -ne $null) {
			Get-XMLviaHTTPGet ("http://gdata.youtube.com/feeds/api/videos/$_/comments?v=2");
		}
	}
}

Function Save-YouTubeFeed([String] $savepath)
{
	process {
		if ($_ -ne $null) {
			#get ID from feed and then parse below
			[System.Xml.XmlNodeList] $nodeList = $null;
			$nodeList = $_.GetElementsByTagName("id", "http://www.w3.org/2005/Atom");
			[String] $idtext = '';
			foreach ($id in $nodeList){
				$idtext = $id.InnerText;
			}
			#sample: <id>tag:youtube.com,2008:video:nA5AAxW7gAk:comments</id>
			$idarray = $idtext.split(":");
			#get feed type from xml
			[String] $feedtype = $idarray[4];
			#get videoid from xml
			[String] $videoid = $idarray[3];;
			#save each feed to path filename of $savepath\$feedtype-$videoid-$serialdatetime.xml
			$fileName = $savepath + '\' + $feedtype + '-' + $videoid + '-' + (Get-Date -Format yyyyMMddHHmm) + '.xml';
			#save XML
			$_.Save($fileName);
			#return filename
			$fileName;
		}		
	}
}
Get-YouTubeListVideoIDs("author=$author") | Get-YouTubeVideoComments | Save-YouTubeFeed("$archivepath") | Write-Host;
