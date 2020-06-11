Function Invoke-SitePreDeploy {
    [cmdletbinding()]
    Param(        
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$siteName        
    )
    Begin {
        
        <#
            Helper function to show usage of cmdlet.
        #>
        Function Show-Usage {
        
            Show-InfoMessage "Usage: Invove-SitePreDeploy -siteName [siteName]"  
            Show-InfoMessage "siteName: lyric for Lyric Opera of Chicago"
            Show-InfoMessage "siteName: voices for Chicago Voices"
            Show-InfoMessage "siteName: mohawkgroup Mohawk Commercial Website (Redesign)"
            Show-InfoMessage "siteName: karastan for Karastan Website"
        }
    }
    Process {
        
        $currentDir = (Get-Item -Path ".\" -Verbose).FullName
        $workingDirRoot = if(![string]::IsNullOrEmpty($env:BTPROJPATH)) { $env:BTPROJPATH } else { "C:\BlueTube\Projects\" }
        $workingDir = ""

        switch($siteName) {

            "lyric" {                     

                $workingDir = $workingDirRoot + "lyric-opera-of-chicago\inetpub\LyricOpera.Website"                
                break                    
            }

            "voices" {                     

                $workingDir = $workingDirRoot + "lyric-opera-of-chicago-voices\inetpub\LyricOpera.ChicagoVoices.Website"                
                break                    
            }

            "mohawkgroup" {
                
                $workingDir = $workingDirRoot + "mohawk-group-website\inetpub\Mohawk.Commercial.Website"                
                break
            }
            
            "karastan" {                     

                $workingDir = $workingDirRoot + "mohawk-karastan-website\inetpub\Mohawk.Karastan.Website"                
                break                    
            }            
                        
            default {

                Show-InfoMessage "Invalid Site Name"
                Show-Usage
                return
            }
        }

        cd $workingDir

        . $workingDir\PreDeploy.ps1

        cd $currentDir
    }
}