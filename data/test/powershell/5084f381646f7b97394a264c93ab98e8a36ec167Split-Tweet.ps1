[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $Recipient,

    [Parameter(Mandatory=$true, Position=1)]
    [string]
    $Message
)

if (-not $Recipient.StartsWith('@')) {
    $Recipient = '@' + $Recipient
}

$messageLimit = 140 - $Recipient.Length - 9

$words = $Message -split ' '
$lines = New-Object System.Collections.Generic.List[string]
$currentLine = ''

foreach ($word in $words) {
    if (($currentLine.Length + $word.Length + 1) -gt $messageLimit) {
        $lines.Add($currentLine)
        $currentLine = ''
    }

    $currentLine += " $word"
}

$lines.Add($currentLine)

for ($i = 0; $i -lt $lines.Count; ++$i) {
    "$Recipient ($($i + 1)/$($lines.Count))$($lines[$i])"
}

