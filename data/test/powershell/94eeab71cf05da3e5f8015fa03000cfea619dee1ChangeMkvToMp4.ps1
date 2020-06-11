# ChangeMkvToMp4.ps1
param
(
    [String] $url,
    [String] $file
)

PS ~> ffmpeg.exe -i "X:\Filmer\Battle of Los Angeles\cbgb-battlelosangeles720.mkv" -c copy "X:\Filmer\Battle of Los Ange
les\cbgb-battlelosangeles720.mp4"

# Hämta stream info via http://pirateplay.se/api/get_streams.xml?url=EscapedURL
$ppapi = "http://pirateplay.se/api/get_streams.xml?url="+[system.uri]::EscapeDataString($url)
$xml = [xml](New-Object net.webclient).DownloadString($ppapi)
# Hämta stream med ffmpgeg till filnamn
$ffmpeg = "ffmpeg -i """+$xml.streams.stream[0].InnerText+""" -c:v copy -strict experimental """+$file+""""
Invoke-Expression $ffmpeg


###
#ffmpeg -i "URL|FILE" -c:v copy -strict experimental "FILE"
###
