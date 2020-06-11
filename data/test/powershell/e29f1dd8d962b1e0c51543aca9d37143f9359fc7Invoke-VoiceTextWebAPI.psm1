function Invoke-VoiceTextWebAPI {
    Param(
    [Parameter(Mandatory=$true, HelpMessage="set [YourAPIKey]:")][string]$APIKey,
    [Parameter(Mandatory=$true, HelpMessage="input text to voice.")][string]$Text,
    [Parameter(Mandatory=$true, HelpMessage="set output fullpath. default is .\tmp.wev")][string]$OutFile,
    [Parameter(HelpMessage="set speaker hikari or takeru or show or haruka. default is hikari.")][string]$Speaker = "hikari",
    [Parameter(HelpMessage="set emotion happiness or anger or sadness. default is happiness.")][string]$Emotion = "happiness",
    [Parameter(HelpMessage="set emotion level 1 or 2. default is 1.")][string]$EmotionLevel = "1",
    [Parameter(HelpMessage="set pitch 50 - 200. default is 100.")][string]$Pitch = "100",
    [Parameter(HelpMessage="set speed 50 - 400. default is 100.")][string]$Speed = "100",
    [Parameter(HelpMessage="set volume 50 - 200. default is 100.")][string]$Volume = "100"
    )

    $uri = "https://api.voicetext.jp/v1/tts"
    $wc = New-Object System.Net.WebClient

    $apiKeyByte = [System.Text.Encoding]::UTF8.GetBytes($APIKey)
    $base64 = [System.Convert]::ToBase64String($apiKeyByte)
    $wc.Headers.Add("Authorization: Basic " + $base64)

    $postdata = New-Object System.Collections.Specialized.NameValueCollection
    $postdata.Add("text",$Text)
    $postdata.Add("speaker",$Speaker)
    $postdata.Add("emotion",$Emotion)
    $postdata.Add("emotion_level",$EmotionLevel)
    $postdata.Add("pitch",$Pitch)
    $postdata.Add("speed",$Speed)
    $postdata.Add("volume",$Volume)

    $res = $wc.UploadValues($uri,"POST",$postdata)
    [System.IO.File]::WriteAllBytes($OutFile,$res)
}