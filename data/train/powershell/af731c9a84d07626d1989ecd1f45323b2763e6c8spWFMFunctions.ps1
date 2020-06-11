#############################################################
# Workflow Manager Functions
# Rob Garrett

function WFM-DownloadAndInstall {
    # Requires Web Platform Installer (you may have it with windows)
    # http://www.iis.net/learn/install/web-platform-installer/web-platform-installer-v4-command-line-webpicmdexe-rtw-release
    $wfmDownloaded = Test-Path -Path "c:/WorkflowManagerFiles/feeds/latest/webproductlist.xml";
    if (!$wfmDownloaded) {
        webpicmd /offline /Products:WorkflowManagerRefresh /Path:c:\WorkflowManagerFiles
        # Now install.
        webpicmd /Install /Products:WorkflowManagerRefresh /XML:c:/WorkflowManagerFiles/feeds/latest/webproductlist.xml
    }
    # Incase we're running WF commands in this session, load it.
    Import-Module WorkflowManager;
}

function WFM-Configure {
    # Create new SB Farm
    $svcAccountName = $global:spFarmAcctName;
    $svcAccountPwd = $global:spFarmAcctPwd;
    $SBCertificateAutoGenerationKey = ConvertTo-SecureString -AsPlainText  -Force  -String $passphrase;
    $WFCertAutoGenerationKey = ConvertTo-SecureString -AsPlainText  -Force  -String $passphrase;
    $managementCS = 'Data Source=' + $global:dbServer + ';Initial Catalog=' + $global:dbPrefix + '_WFMSB_Management;Integrated Security=True;Encrypt=False';
    $gatewayCS = 'Data Source=' + $global:dbServer + ';Initial Catalog=' + $global:dbPrefix + '_WFMSB_Gateway;Integrated Security=True;Encrypt=False';
    $messageContCS = 'Data Source=' + $global:dbServer + ';Initial Catalog=' + $global:dbPrefix + '_WFMSB_MessageContainer;Integrated Security=True;Encrypt=False';
    Write-Host -ForegroundColor White 'Creating new Service Bus farm...' -NoNewline;
    try {
        $sbFarm = Get-SBFarm -SBFarmDBConnectionString $managementCS;
        Write-Host -ForegroundColor White 'Already Exists';
    }
    catch {
        New-SBFarm -SBFarmDBConnectionString $managementCS -InternalPortRangeStart 9000 -TcpPort 9354 -MessageBrokerPort 9356 -RunAsAccount $svcAccountName `
            -AdminGroup 'BUILTIN\Administrators' -GatewayDBConnectionString $gatewayCS -CertificateAutoGenerationKey $SBCertificateAutoGenerationKey `
            -MessageContainerDBConnectionString $messageContCS;
        Write-Host -ForegroundColor White 'Done';
    }
    # Create new WF Farm
    Write-Host -ForegroundColor white " - Creating new Workflow Farm..." -NoNewline;
    $wfManagementCS = 'Data Source=' + $global:dbServer + ';Initial Catalog=' + $global:dbPrefix + '_WFM_Management;Integrated Security=True;Encrypt=False';
    $wfInstanceCS = 'Data Source=' + $global:dbServer + ';Initial Catalog=' + $global:dbPrefix + '_WFM_InstanceManagement;Integrated Security=True;Encrypt=False';
    $wfResourceCS = 'Data Source=' + $global:dbServer + ';Initial Catalog=' + $global:dbPrefix + '_WFM_ResourceManagement;Integrated Security=True;Encrypt=False';
    try {
        $wfFarm = Get-WFFarm -WFFarmDBConnectionString $wfManagementCS;
        Write-Host -ForegroundColor White 'Already Exists';
    }
    catch {
        New-WFFarm -WFFarmDBConnectionString $wfManagementCS -RunAsAccount $svcAccountName -AdminGroup 'BUILTIN\Administrators' -HttpsPort 12290 -HttpPort 12291 `
            -InstanceDBConnectionString $wfInstanceCS -ResourceDBConnectionString $wfResourceCS -CertificateAutoGenerationKey $WFCertAutoGenerationKey;
        Write-Host -ForegroundColor white 'Done';
    }
    # Add SB Host
    Write-Host -ForegroundColor white ' - Adding Service Bus host...' -NoNewline;
    try {
        $SBRunAsPassword = ConvertTo-SecureString -AsPlainText  -Force  -String $svcAccountPWD;
        Add-SBHost -SBFarmDBConnectionString $managementCS -RunAsPassword $SBRunAsPassword `
            -EnableFirewallRules $true -CertificateAutoGenerationKey $SBCertificateAutoGenerationKey;
        Write-Host -ForegroundColor white 'Done';
    } 
    catch {
        Write-Host -ForegroundColor white 'Already Exists';
    }
    Write-Host -ForegroundColor white ' - Creating Workflow Default Namespace...' -NoNewline;
    $sbNamespace = $global:dbPrefix + '-WorkflowNamespace';
    try {
        $defaultNS = Get-SBNamespace -Name $sbNamespace -ErrorAction SilentlyContinue;
        Write-Host -ForegroundColor white 'Already Exists';
    }
    catch {
        try {
            # Create new SB Namespace
            $currentUser = $env:userdomain + '\' + $env:username;
            New-SBNamespace -Name $sbNamespace -AddressingScheme 'Path' -ManageUsers $svcAccountName,$spAdminAcctName,$currentUser;
            Start-Sleep -s 90
            Write-Host -ForegroundColor white 'Done';
        }
        catch [system.InvalidOperationException] {
            throw;
        }
    }
    # Get SB Client Configuration
    $SBClientConfiguration = Get-SBClientConfiguration -Namespaces $sbNamespace;
    # Add WF Host
    try {
        $WFRunAsPassword = ConvertTo-SecureString -AsPlainText  -Force  -String $svcAccountPWD;
        Write-Host -ForegroundColor White ' - Adding Workflow Host...' -NoNewline;
        Add-WFHost -WFFarmDBConnectionString $wfManagementCS -EnableHttpPort `
        -RunAsPassword $WFRunAsPassword -EnableFirewallRules $true `
        -SBClientConfiguration $SBClientConfiguration -CertificateAutoGenerationKey $WFCertAutoGenerationKey;
        Write-Host -ForegroundColor White 'Done';
    }
    catch {
        Write-Host -ForegroundColor white "Already Exists";
    }
}

function SP-ConfigureWFMPrompt {
    # Configure WFM for SharePoint with prompt.
    $wfmCert = Read-Host "What is the location of the WFM exported certificate?";
    $webAppUrl = Read-Host "What is the URL for the web app?";
    $wfmHostUrl = "http://" + $env:COMPUTERNAME + ":12291";
    if ($wfmCert -eq $null -or $wfmCert -eq '') {
        SP-ConfigureWFM -webAppUrl $webAppUrl -wfmHostUrl $wfmHostUrl;
    } 
    else {
        SP-ConfigureWFM -webAppUrl $webAppUrl -wfmCert $wfmCert -wfmHostUrl $wfmHostUrl;
    }
}

function SP-ConfigureWFM($webAppUrl, $wfmCert, $wfmHostUrl) {
    if ($wfmCert -ne $null -and $wfmCert -ne '') {
    # Add WFM certificate to the trusted certs location in SP.
        $trustCert = Get-PfxCertificate $wfmCert;
        $trustedRoot = Get-SPTrustedRootAuthority "Workflow Manager Farm" -ErrorAction SilentlyContinue;
        if (!$trustedRoot) {
            New-SPTrustedRootAuthority -Name "Workflow Manager Farm" -Certificate $trustCert;
        }
    }
    # Register WFM with the app.
    Write-Host -ForegroundColor White " - Registering WFM with SharePoint app $webAppUrl..." -NoNewline;
    $proxy = Get-SPWorkflowServiceApplicationProxy;
    if ($proxy) { $proxy.Delete(); }
    Register-SPWorkflowService -SPSite $webAppUrl -WorkflowHostUri $wfmHostUrl -AllowOAuthHttp -Force;
    Write-Host -ForegroundColor White "Done";
}
