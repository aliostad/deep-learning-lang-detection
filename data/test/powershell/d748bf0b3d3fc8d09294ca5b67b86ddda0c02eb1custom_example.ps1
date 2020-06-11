# Example of loading custom properties
# Usage: Create or copy file to '[baseDir]\scripts\custom.ps1' and add or edit properties as required

function LoadCustomProperties {
    $script:configuration = "Debug"
    $script:versionMajor = 1
    $script:versionMinor = 2
    $script:versionBuild = 3
    $script:defaultWebsitePort = 8381
    $script:FtpHost = "ftp.example.com"
}

# Contents of private.ps1, which is not committed to version control:
# Usage: Create or copy file to '[baseDir]\scripts\private.ps1' and add or edit properties as required

function LoadPrivateProperties {
    $script:FtpUser = "ExampleFtpUser"
    $script:FtpPassword = "ExampleFtpPassword"
}