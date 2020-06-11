<#
|==============================================================================>|
  AlchemyCmd-AP by Apoorv Verma [AP] on 10/2/2013
|==============================================================================>|
  DECRIPTION:
  ----------
    AlchemyCmd-AP is a command line tool that connects to Alchemy API, which 
    supports a variety of options for tuning natural language 
    processing operations.
|==============================================================================>|
  FEATURES:
  --------
      $) Very Dynamic and Detailed Parameter Handling [Better that linux counterpart :p]
      $) Automated Features [Error Handling, Key Handling, Data Extraction]
      $) Verbose Help Menu [Additional Features Documented too!]
|==============================================================================>|
#>
param(
[ValidateSet('concept','entity','keyword','category','language',"cquery")][Alias("M")][String]$mode,
[ValidateSet('text','HTML','web','url','file')][Alias("S","type","source-type")][String]$srctype,
[Alias("F","U","T","text","file","url","path","source-file","source-url")][String]$Source,
[Alias("H","?")][Switch]$Help,
[Alias("APU","api-print-url")][Switch]$PrintUrl,
[Alias("NT")][Switch]$NoThrow,
# ----------------------------------LEGACY [Doesnt-Do-Anything]--------------|
[Alias("Verbose","V","R","read-from")][Switch]$Legacy,
# ----------------------------------LEGACY [Doesnt-Do-Anything]--------END---|
[Alias("Show-Request-Only")][Switch]$RQO,
[Alias("Show-Query")][Switch]$SQ,
[ValidateSet('XML','CSV','RawXML')][Alias("O","output-mode")][String]$output = "XML",
[Alias("K","KeyFile","key-location")][String]$Key,
[ValidateSet('cleaned','raw','xpath','cquery','cleaned_or_raw')][Alias("AT","api-source-text")][String]$AST,
[Alias("AC","api-cquery")][String]$cquery,
[Alias("AX","api-xpath")][String]$xpath,
[Alias("AM","api-max-retrieve")][String]$AMR
)
$ErrorActionPreferenceO = $ErrorActionPreference
$ErrorActionPreference  = "SilentlyContinue"
. (Resolve-path "Modules.ps1",".\Modules.ps1","$(split-path $PSCommandPath)\Modules.ps1")[0] 2>&1>$null
$ErrorActionPreference  = $ErrorActionPreferenceO
function Thrower ($Data) {
    if (!$NoThrow) {Throw $Data}
    exit
}
function HelpMenu {
write-Host -f yellow @"

AlchemyCmd-AP v1.0
By Apoorv Verma [AP]

"@
@"
Synopsis:
  Command line tool by AP that connects to Alchemy API, which supports a 
variety of options for tuning natural language processing operations.

Required:
  -M, -mode TYPE              Select the NLP operation type:
                                  concept  (concept tagging)
                                   entity  (named entity extraction)
                                  keyword  (keyword extraction)
                                  cateory  (text categorization)
                                 language  (language detection)
                                   cquery  (constraint query)
  -S, -source-type TYPE       Select the source content type:
                                      web  (process a WWW resource)
                                     html  (process a local HTML file)
                                     text  (process a local text file)
  -F, -source-file PATH\URL   Process a (text or HTML file) or (URL)
  -U                          Same as -F

Miscellaneous:
  -H, -help                   Print command usage
  -K, -key-location PATH      Specify a custom API key location
  -O, -output-mode MODE       Output formatting mode:
                                   simple  (simple comma-delimited output)
                                      xml  (raw XML output

HTML Targeting Options (for -source-type = 'html' or 'web'):
  -AT, -api-source-text MODE  Set a HTML page targetting mode:
                                  cleaned  (use HTML content cleaning)
                                      raw  (process entire HTML content)
                                    xpath  (use an XPath query)
                                   cquery  (use a HTML constraint query)
                           cleaned_or_raw  (use HTML content cleaning,
                                            falling back to 'raw' mode)
  -AC, -api-cquery QUERY      Set a constraint query
                                   (see http://www.alchemyapi.com/api/scrape/)
  -AX, -api-xpath XPATH       Set an XPath expression

Other API Options:
  -AM, -api-max-retrieve VAL  Specify the max # of results to retrieve
  -APU, -api-print-url        Enable printing of URLs in simple responses
  -SQ, -Show-Query            Shows the Query Used to get Result
  -RQO, -Show-Request-Only    Shows only the queried data

"@ | % {$_.split("`n")} | % {if ($_ -match "^[^ ].*:") {$Col = "Yellow"} else {$Col = "DarkCyan"};write-host -f $Col $_}
}
if ($Help) {HelpMenu;exit}
"mode","srctype","source" | % {if ([String]::IsNullOrEmpty((Get-Variable $_).Value)) {Write-Host -f Red "[-] $($_.ToUpper()) is undefined, QUIT!";Thrower "Incomplete Parameters"}}
if ([String]::IsNullOrEmpty($Key)) {
    try {$Key = GET-APIKey "AlchemyAPI" -NoThrow} catch {}
    if (([String]::IsNullOrEmpty($Key)) -and (Test-path -type leaf "$PWD\AlchemyAPI-AP.Key.txt")) {
        $Key = ([String[]](gc "$PWD\AlchemyAPI-AP.Key.txt" | ? {$_ -imatch "alchemyAPI"}))[0]
    }
    if ([String]::IsNullOrEmpty($Key)) {
        Write-Host -f Red "[-] API KEY cannot be null, please point to file\give the key\Store it in AlchemyAPI-AP.Key.txt"
        Thrower "API KEY BLANK"
        exit
    }
}
if ($srctype -eq "file") {
    if (test-path $Source -type leaf) {$Source = gc $Source} else {write-host -f red "[-] Source File Does not exist!";Thrower "SourceFile_non-existant";exit}
}
if ($Source.length -le 4) {Write-Host -f Red "[-] Too little Text to analyze!";Thrower "Insufficient Data!";exit}
try {$DLLPath = (gcm "AlchemyAPI.dll","$PWD\AlchemyAPI.dll","$(Split-Path $PSCommandPath)\AlchemyAPI.dll" -ErrorAction Ignore).path} catch {if ($DLLPath -eq $null) {"AlchemyAPI.dll file is missing from Path!";exit}}
[void][Reflection.Assembly]::LoadFile("$DLLPath")
$API = New-Object AlchemyAPI.AlchemyAPI
try {$API.SetAPIKey("$KEY")} catch {Write-Host -f Red "[-] Invalid API-Key was specified!";Thrower "Invalid API-KEY";exit}
$srctype = $srctype.replace("web","url")
$srctype = $srctype.replace("file","text")
$PullMethod = ($API | gm).name | ? {$_ -like "$srctype*$($mode.substring(0,$mode.Length-1))*"}
if ($PullMethod -eq $null) {Write-Host -f Red "[-] Method Undefinable with given Mode, and SrcType!";Thrower "PullMethod Not Found";exit}
$Payload = $Source
if ($SQ) {Write-Host -f Yellow "API.$PullMethod($Payload)"}
try {
    $Response = ([XML]$API.$PullMethod($Payload)).Results
} catch {
    Write-Host -f Red "[-] Sorry, but Request created an Error, please modify request [$(("$_".split(":")[1..5] -join(":")).trim())]..."
    Thrower "AP-GETError-Request"
    exit
}
if ($RQO) {
    $Filter = switch ($mode) {
        "concept"  {"${Mode}s.$Mode"}
        "entity"   {"Entities.$Mode"}
        "keyword"  {"${Mode}s.$Mode"}
        "category" {"$Mode"         }
        "language" {"$Mode"         }
        "cquery"   {                }
    }
}
$Baki = $Response | gm -MemberType Properties | % {$_.name} | ? {$_ -ne "usage"} | ? {if (!$PrintURL) {$_ -ne "url"} else {$true}}
if ($Filter -ne $null) {
    $Filter = $Filter.split(".")
    if ($Filter.count -eq 1) {
        $Response = ($Response.$($Filter[0])) 
    } else {
        $Response = ($Response.$($Filter[0]).$($Filter[1])) 
    }
} else {
    $Response = $Response | select $Baki
}
if ($Output -eq "CSV") {$Response = $Response | ConvertTo-Csv}
return $Response