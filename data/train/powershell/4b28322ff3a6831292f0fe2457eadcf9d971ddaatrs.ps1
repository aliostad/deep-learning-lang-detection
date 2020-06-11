
function showHelp {
    "Usage: trs {[SL]=[TL]} TEXT
    
    TEXT: Source text
      SL: Source language (The language of the source text)
      TL: Target language (The language to translate the source text into)
          Language codes as listed here:
        * http://developers.google.com/translate/v2/using_rest#language-params
          Ignore the code where you want the system to identify it for you.
          Prefix the code with an ampersat @ to show the result phonetically."
}

if ($args.length -lt 2) {
    showHelp
    exit
}
    
$RS = $ORS = "\r\n"
$FS = $OFS = "\n"

$sl = "en"
$tl = "pt"

if ($args[0] -match ".*-.*"){
    $sl, $tl = $args[0].split("-")
    $h = $args[1..$args.length]
}
else{
    $h =$args[0..$args.length]
}

$text = ($h -join " ") -replace " ", "%20"

#write-host $text            
$url = "http://translate.google.com/translate_a/t?client=t&ie=UTF-8&oe=UTF-8&sl=" + $sl + "&tl=" + $tl + "&text=" + $text
            
try{
    $resp = (Invoke-WebRequest -URI $url).content
    $pattern = '"([^\[^\]^"]*)"'
    $words = ([regex]::matches($resp, $pattern) | %{$_.value})
    $words[0] -replace '"', "" | write-host
}
catch{
  #[system.exception]
  #"I am error"
}

