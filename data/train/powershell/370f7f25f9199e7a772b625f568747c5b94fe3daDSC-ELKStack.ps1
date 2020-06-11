Configuration ELK
{
 param([string[]]$NodeName=“localhost“, [pscredential]$Credentials)

$elkroot = "$env:SystemDrive\elkroot"
[string]$LogStashConfig = @'
input {
  beats {
   port => 5044
   type => "log"
  }
}

output {
  elasticsearch {
    hosts => "localhost:9200"
    manage_template => false
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}
'@ 
    Node $NodeName
    {
        Script LogStashDownload
        {
            GetScript = {
                $Result = (Test-Path -Path "$env:Temp\logstash-2.3.1.zip")
                @{GetScript = $GetScript; 
                    SetScript = $SetScript; 
                    TestScript = $TestScript; 
                    Result = $Result }
            }
            SetScript =  "(new-object System.Net.WebClient).Downloadfile(`"https://download.elastic.co/logstash/logstash/logstash-2.3.1.zip`", `"$env:Temp\logstash-2.3.1.zip`")"
            TestScript = "return (Test-Path -Path `"$env:Temp\logstash-2.3.1.zip`")"
        }

        Package Java8u92
        {
            Arguments = "/qn"
            Ensure ="Present"
            Path  = "$($env:Windir)\Temp\jdk-8u92-windows-x64.exe"
            Name = "Java SE Development Kit 8 Update 92 (64-bit)"
            ProductId = "64A3A4F4-B792-11D6-A78A-00B0D0180920"
            #DependsOn = "[Script]Java8u92Download"
        }

        Script NSSMDownload
        {
            GetScript = {
                $Result = (Test-Path -Path "$env:Temp\nssm-2.24.zip")
                @{GetScript = $GetScript; 
                    SetScript = $SetScript; 
                    TestScript = $TestScript; 
                    Result = $Result }
            }
            SetScript =  "(new-object System.Net.WebClient).Downloadfile(`"https://nssm.cc/release/nssm-2.24.zip`", `"$env:Temp\nssm-2.24.zip`")"
            TestScript = "return (Test-Path -Path `"$env:Temp\nssm-2.24.zip`")"
        }

        Script ElasticSearchDownload
        {
            GetScript = {
                $Result = (Test-Path -Path "$env:Temp\elasticsearch-2.3.1.zip")
                @{GetScript = $GetScript; 
                    SetScript = $SetScript; 
                    TestScript = $TestScript; 
                    Result = $Result }
            }
            SetScript =  "(new-object System.Net.WebClient).Downloadfile(`"https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/zip/elasticsearch/2.3.1/elasticsearch-2.3.1.zip`", `"$env:Temp\elasticsearch-2.3.1.zip`")"
            TestScript = "return (Test-Path -Path `"$env:Temp\elasticsearch-2.3.1.zip`")"
        }

        Script KibanaDownload
        {
            GetScript = {
                $Result = (Test-Path -Path "$env:Temp\kibana-4.5.0-windows.zip")
                @{GetScript = $GetScript; 
                    SetScript = $SetScript; 
                    TestScript = $TestScript; 
                    Result = $Result }
            }
            SetScript =  "(new-object System.Net.WebClient).Downloadfile(`"https://download.elastic.co/kibana/kibana/kibana-4.5.0-windows.zip`", `"$env:Temp\kibana-4.5.0-windows.zip`")"
            TestScript = "return (Test-Path -Path `"$env:Temp\kibana-4.5.0-windows.zip`")"
        }
        
        File ElkFolder
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "$elkroot"
        }

        Archive UnzipNSSM
        {
            Destination = "$elkroot\nssm"
            Path = "$Env:TEMP\nssm-2.24.zip"
            Ensure = "Present"
            Force = $true
            DependsOn = "[Script]NSSMDownload"
        }

        Archive UnzipElasticSearch
        {
            Destination = "$elkroot\elasticsearch"
            Path = "$Env:TEMP\elasticsearch-2.3.1.zip"
            Ensure = "Present"
            Force = $true
            DependsOn = "[Script]ElasticSearchDownload"
        }

        Archive UnzipLogStash
        {
            Destination = "$elkroot\logstash"
            Path = "$Env:TEMP\logstash-2.3.1.zip"
            Ensure = "Present" 
            DependsOn = "[Script]LogStashDownload"
        }

        File LogStashConfig
        {
            DestinationPath = "$elkroot\logstash\bin"
            Ensure = "Present"
            Force = $true
            Type = "File"
            DependsOn = "[Archive]UnzipLogStash"
            Contents = $LogStashConfig
        }

        Environment JavaHome
        {
            Name = "JAVA_HOME"
            Ensure = "Present"
            Path = $false
            DependsOn = "[Package]Java8u92"
            Value = "$env:ProgramFiles\Java\jdk1.8.0_92"
        }

        Environment JavaBin
        {
            Name = "JAVA_BIN"
            Ensure = "Present"
            Path = $false
            DependsOn = "[Package]Java8u92"
            Value = "$env:ProgramFiles\Java\jdk1.8.0_92\bin"
        }

        Script InstallElasticSearch
        {
            GetScript = {
                $Result = (if((Get-Service | Where {$_.Name -eq "elasticsearch-service-x64"}) -eq $null){return $tue}else{return $false})
                @{GetScript = $GetScript; 
                    SetScript = $SetScript; 
                    TestScript = $TestScript; 
                    Result = $Result }
            }
            SetScript =  {$env:JAVA_HOME = "$env:ProgramFiles\Java\jdk1.8.0_92"; "$elkroot\elasticsearch\elasticsearch-2.3.1\bin";Invoke-Expression -Command "cmd /c service.bat install"}
            TestScript = {if((Get-Service | Where {$_.Name -eq "elasticsearch-service-x64"}) -eq $null){return $tue}else{return $false}}
            DependsOn = "[Environment]JavaHome"
        }

        #Service ElasticSearchService
        #{
        #    Name = "elasticsearch-service-x64"
        #    #[ BuiltInAccount = [string] { LocalService | LocalSystem | NetworkService }  ]
        #    #[ Credential = [PSCredential] ]
        #    DependsOn = "[Script]InstallElasticSearch"
        #    StartupType = "Automatic"
        #    State = "Running"
        #}

        #Script InstallLogStash
        #{
        #    GetScript = {
        #        $Result = (if((Get-Service | Where {$_.Name -eq "elasticsearch-service-x64"}) -ne $null){$tue}else{$false})
        #        @{GetScript = $GetScript; 
        #            SetScript = $SetScript; 
        #            TestScript = $TestScript; 
        #            Result = $Result }
        #    }
        #    SetScript =  "cd $elkroot\logstash\;"
        #    TestScript = "return (if((Get-Service | Where {$_.Name -eq `"Logstash`"}) -ne $null){$tue}else{$false})"
        #    DependsOn = '[Service]ElasticSearchService','[Archive]UnzipLogStash'
        #}

        #Service LogStashService
        #{
        #    Name = "Logstash"
            #[ BuiltInAccount = [string] { LocalService | LocalSystem | NetworkService }  ]
            #[ Credential = [PSCredential] ]
        #    DependsOn = "[Script]InstallLogStash"
        #    StartupType = "Automatic"
        #    State = "Running"
        #}

        WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Server"
        }

        #Archive UnzipKibana
        #{
        #    Destination = "$elkroot\kibana"
        #    Path = "$Env:TEMP\kibana-4.5.0-windows.zip"
        #    Ensure = "Present"
        #    Force = $true
        #    DependsOn = "[Script]KibanaDownload"
        #}
        
   } 
}

ELK
Start-DscConfiguration ELK -ComputerName localhost -wait -Force -Verbose -Debug
