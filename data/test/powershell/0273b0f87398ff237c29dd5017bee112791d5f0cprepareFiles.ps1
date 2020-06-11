# Copy custom files to prepare for patching

rename-item e:\oracle\registry.xml registry.xml.bkp
rename-item e:\oracle\utils\bsu\bsu.cmd bsu.cmd.bkp

copy-item -Path e:\patches\cve-2015-4852\registry.xml    -Destination e:\oracle\registry.xml
copy-item -Path e:\patches\cve-2015-4852\bsu.cmd         -Destination e:\oracle\utils\bsu\bsu.cmd
copy-item -Path e:\patches\cve-2015-4852\jdk-1.7.0_79    -Destination e:\java\ -recurse

(get-content e:\oracle\registry.xml) | foreach-object {$_ -replace "hrweb-d1", $env:computername} | set-content e:\oracle\registry.xml
