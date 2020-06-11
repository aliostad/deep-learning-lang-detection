<#
Test-Network script for sending multiple parallel data types

The iPerf utility can send parallel streams of the same protocol
(UDP/TCP) to the same socket.  This script allows running multiple
iPerf processes to simulate concurrent network activity.
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]$ServerIP,
    [Parameter(Mandatory=$False)]
    [string]$Path="c:\windows\system32\iperf.exe",
    [Parameter(Mandatory=$True)]
    [ValidateSet("Low","Medium","High")]
    [string]$Load,
    [Parameter(Mandatory=$False)]
    [string]$Time="60"
)

if(! (Test-Path $Path))
{
    "ERROR: iPerf binary not found in $Path"
    "Please specify location with -Path parameter"
    Exit
}


# Global Jobs list - this should be a singleton but that is not easily
# achieved in PowerShell
$Global:jobs = @()

# The following functions are written in script-block format because
# they are being used with Start-Job

# Simulate a UDP voice call $quality denotes codec bandwidth: Normally
# 32, 64, or 128 Kbps
$voice_call = { param($quality, $quantity, $duration, $ip, $iperf_path) `
                & $iperf_path `
                -p 5201 `
                -c $ip `
                -P $quantity `
                -t $duration `
                -u -b $quality
               }

# Simulate a TCP file transfer
$file_transfer = { param($duration, $ip, $iperf_path) `
                   & $iperf_path `
                   -p 5202 `
                   -c $ip `
                   -t $duration
                  }

# Simulate a UDP video stream.  Exactly the same as voice_call, but normally
# the bitrate is much higher (500 kbps - 6 Mbps)
# NOTE: Since we are not testing multicast functionality we can use a unicast
# stream here
$video_stream = { param($bitrate, $quantity, $duration, $ip, $iperf_path) `
                  & $iperf_path `
                  -p 5203 `
                  -c $ip `
                  -u -b $bitrate `
                  -P $quantity `
                  -t $duration
                  }

function add_job($job_name, $job_type)
{
    if ($job_name.State -eq "Failed")
    {
        "Job Failed"
        $job_name | Receive-Job
    }
    else
    {
        $job_name | Add-Member -NotePropertyName "Type" -NotePropertyValue $job_type
        $Global:jobs += $job_name
    }
}

# Normal Usage test
# 1 64K phone call
# 1 TCP file transfer
# 1 3M video stream
function test_low($time="60")
{
    "`nPerforming Low Load Test`n"
    add_job $(Start-Job -ScriptBlock $voice_call -ArgumentList "64K","1", $time, $ServerIP, $Path) "Voice-Test"
    add_job $(Start-Job -ScriptBlock $file_transfer -ArgumentList $time, $ServerIP, $Path) "File Test"
    add_job $(Start-Job -ScriptBlock $video_stream -ArgumentList "3M","1",$time, $ServerIP, $Path) "Video Test"
}

# Medium Usage Test
# 3 64K phone calls
# 1 TCP file transfer
# 2 3M video streams
function test_medium($time="60")
{
    "`nPerforming Medium Load Test`n"
    add_job $(Start-Job -ScriptBlock $voice_call -ArgumentList "64K","3", $time, $ServerIP, $Path) "Voice-Test"
    add_job $(Start-Job -ScriptBlock $file_transfer -ArgumentList $time, $ServerIP, $Path) "File Test"
    add_job $(Start-Job -ScriptBlock $video_stream -ArgumentList "3M","2",$time, $ServerIP, $Path) "Video Test"
}

# High Usage Test
# 6 64K phone calls
# 1 TCP file transfer
# 4 3M video streams
function test_high($time="60")
{
    "`nPerforming High Load Test`n"
    add_job $(Start-Job -ScriptBlock $voice_call -ArgumentList "64K","6", $time, $ServerIP, $Path) "Voice-Test"
    add_job $(Start-Job -ScriptBlock $file_transfer -ArgumentList $time, $ServerIP, $Path) "File Test"
    add_job $(Start-Job -ScriptBlock $video_stream -ArgumentList "3M","4",$time, $ServerIP, $Path) "Video Test"
}

function run($test_load, $test_time)
{
    if ($test_load -eq "Low")
        {
            test_low $test_time
        }
    elseif ($test_load -eq "Medium")
        {
            test_medium $test_time
        }
    elseif ($test_load -eq "High")
        {
            test_high $test_time
        }
    
    foreach ($result in $Global:jobs)
    {
        $output = $result | Wait-Job | Receive-Job
        "`n"+ $result.Type
        $output
    }
}

run $Load $Time
