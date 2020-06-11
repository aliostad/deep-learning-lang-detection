#requires -module BetterCredentials

# REQUIRED:
# Get a key from https://datamarket.azure.com/account/keys 
# Make sure you have a subscription to http://datamarket.azure.com/dataset/bing/search

# FIRST USE:
# Each user needs to pass an ApiKey the first time you import this module
# Replace your key for the AAA key below:
# Import-Module Bing -ArgumentList AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= -Force
# After that you can just Import-Module Bing, or use 
param(
  $ApiKey,

  [System.Management.Automation.PSCredential]
  [System.Management.Automation.Credential()]
  [AllowNull()]
  $Credential = $(if($ApiKey){ BetterCredentials\Get-Credential -User BingApiKey -Password $ApiKey -Store } else { BetterCredentials\Get-Credential -User BingApiKey })
)

Add-Type -Assembly System.Web

$Ofs = " "

$Selectors = @{
  Web = @{
    Format = "{0} {1}"
    Fields = "Title","Url"
  }
  News = @{
    Format = "{0} (from {2}) {1}"
    Fields = "Title","Url","Source"
  }
  Image = @{
    Format = "{0} ({2}x{3}) {1}"
    Fields = "Title","MediaUrl","Width","Height"
  }
  SpellingSuggestions = @{ 
    Format = "{0}"
    Fields = "Value"
  }
  Translate = @{
    Format = "{0}"
    Fields = "Text"
  }  
}

Set-Alias bing Search-Bing
function Search-Bing {
  #.Synopsis
  #   Search Bing Web, News, Images, or SpellingSuggestions
  param(
    # The search terms
    [Parameter(Position=0, Mandatory=$true, ValueFromRemainingArguments=$true, ValueFromPipeline=$true)]
    [String[]]$Query,

    # The type of search
    [ValidateSet("Web","News","Image","SpellingSuggestions")]
    $Noun = "Web",

    # The number of results to fetch
    [ValidateRange(0,5)]
    [int]$Count = 3,

    # The number of results to skip
    [int]$Skip = 0
  )
  $Query = [Web.HttpUtility]::UrlEncode("'$Query'")

  $Search = "https://api.datamarket.azure.com/Bing/Search/${Noun}?Query=${Query}&`$top=$Count&`$skip=$Skip"

  $global:BingResults = Invoke-WebRequest -Credential $Script:Credential -Uri $Search
  $global:BingEntries = ([xml]$BingResults.Content).feed.entry.content.properties

  $Selector = $Selectors.$Noun.Fields -join "' or local-name() = '"
  $Selector =  "*[local-name() = '$Selector']/text()"
  foreach($entry in $BingEntries) {
    $Selectors.$Noun.Format -f $entry.SelectNodes($Selector).Value
  }

}

Set-Alias translate Get-Translation
function Get-Translation {
  #.Synopsis
  #   Translate Text
  param(
    # The text to be translated
    [Parameter(Position=0, Mandatory=$true, ValueFromRemainingArguments=$true, ValueFromPipeline=$true)]
    [String[]]$Query,

    # The target language (defaults to english (en))
    [Parameter(Mandatory=$false)]
    [String[]]$To = "en",

    # The source language (optional)
    [Parameter(Mandatory=$false)]
    $From
  )
  $Query = [Web.HttpUtility]::UrlEncode("'$Query'")

  if($From){ $From = "&From='$From'" }

  foreach($Lang in $To) {
    $Search = "https://api.datamarket.azure.com/Bing/MicrosoftTranslator/v1/Translate?To='${Lang}'${From}&Text=${Query}"
    Write-Verbose "Uri: $Search"

    $global:Results = Invoke-WebRequest -Credential $Script:Credential -Uri $Search
    $global:Entries = ([xml]$Results.Content).feed.entry.content.properties

    $Selector =  "*[local-name() = '$($Selectors.Translate.Fields)']/text()"
    Write-Verbose "Found $($Entries.Count) Entries: Select $Selector"
    foreach($entry in $Entries) {
      Write-Verbose $entry.OuterXml
      $Selectors.Translate.Format -f $entry.SelectNodes($Selector).Value
    }
  }

}

Invoke-WebRequest -Cred $Script:Credential -Uri "https://api.datamarket.azure.com/Bing/MicrosoftTranslator/v1/Translate?To='es'&Text='This+is+a+test+of+the+emergency +broadcast+system.'"
Export-ModuleMember -Function *-* -Alias *