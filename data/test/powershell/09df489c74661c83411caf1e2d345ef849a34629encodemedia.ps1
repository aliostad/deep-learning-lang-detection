$NAS = "\\omninas\Disk\Plex Media\TV\"
$files = Get-ChildItem $NAS -File -Recurse | Sort-Object FullName


foreach ($file in $files)
{
    If ($File.Extension -eq ".srt")
    {
        Continue
    }

    Write-Host "Processing $file"

    #Reset vars
    $run_offhours = 0
    $h264 = 0
    $aac = 0
    $mp4 = 0

    $FilePath = $file.FullName
    $ffprobe = "P:\Program Files (x86)\Plex\ffmpeg\bin\ffprobe.exe"
    $ffprobeparams = " -v quiet -print_format xml -show_format -show_streams ""$FilePath"""
    #$result = & "$env:cust_tls_store\Tools\WDK\x64\devcon.exe" enable $strHwid 2>&1 | Out-String
    #$result = & $ffprobe $ffprobeparams 2>&1 | Out-String
    $filexml = & "$ffprobe" -v quiet -print_format xml -show_format -show_streams "$FilePath" | Out-String

    $filedata = [XML]$filexml

    foreach ($stream in $filedata.ffprobe.streams.stream)
    {
        if ($stream.codec_type -eq "video" -and $stream.codec_name -eq "h264")
        {
            Write-Host "Already in current video format."
            $h264 = 1
        }

        if ($stream.codec_type -eq "audio" -and $stream.codec_name -eq "aac")
        {
            Write-Host "Already in current audio format."
            $aac = 1
        }

        If ($File.Extension -eq ".mp4")
        {
            Write-Host "Already in current container."
            $mp4 = 1
        }

    }

    if ($h264 -eq 1)
    {
        if ($aac -eq 0)
        {
            $run_offhours = 1
        }
        elseif ($mp4 -eq 0)
        {
            $run_offhours = 1
        }
        else
        {
            Write-Host "Correct container, audio, and video. Do not process."
        }
    }
    else
    {
        $run_offhours = 2
    }


    If ($run_offhours -eq 1)
    {
        Write-Host "Running conversion script."
        $python = "P:\Python\27\python.exe"
        $manualpy = "P:\Program Files (x86)\Plex\MP4 Automator\manual.py"

        $result = & "$python" "$manualpy" -a -i "$FilePath"
        #Write-Host $result
    }

} 

