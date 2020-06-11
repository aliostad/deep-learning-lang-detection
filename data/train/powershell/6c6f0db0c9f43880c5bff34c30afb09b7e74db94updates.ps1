param(
    [string] $environment = $(throw "environment required"),
	[string] $config = $(throw "config is required")
)

## app settings
Config "configuration/appSettings/add[@key='NetTcpWcfBackEndAddress']/@value" $NetTcpWcfBackEndAddress
Config "configuration/appSettings/add[@key='HttpWcfBackEndAddress']/@value" $HttpWcfBackEndAddress
Config "configuration/appSettings/add[@key='HttpWcfFrontEndAddress']/@value" $HttpWcfFrontEndAddress
Config "configuration/appSettings/add[@key='UseRealAuthenticationService']/@value" $UseRealAuthenticationService
Config "configuration/appSettings/add[@key='CmsMenuFileName']/@value" $CmsMenuFileName
Config "configuration/appSettings/add[@key='CmsMenuFolderPath']/@value" $CmsMenuFolderPath
Config "configuration/appSettings/add[@key='CertificateFriendlyName']/@value" $CertificateFriendlyName
Config "configuration/appSettings/add[@key='ServiceIdentityDns']/@value" $ServiceIdentityDns
Config "configuration/appSettings/add[@key='IsSessionMode']/@value" $IsSessionMode

## services
Config "/configuration/system.serviceModel/services/service[@name='Phoenix.WcfFrontEnd.Services.InvestmentServiceV1']/endpoint[@name='Phoenix.WcfFrontEnd.Services.InvestmentServiceV1']/@address"  "$HttpWcfFrontEndAddress/services/InvestmentServiceV1.svc"
Config "/configuration/system.serviceModel/services/service[@name='Phoenix.WcfFrontEnd.Services.ExternalPlatformInterfaceV420']/endpoint[@name='Phoenix.WcfFrontEnd.Services.ExternalPlatformInterfaceV420']/@address"  "$HttpWcfFrontEndAddress/services/ExternalPlatformInterfaceV420.svc"


## client
Config "/configuration/system.serviceModel/client/endpoint[@name='WSHttpBinding_IQuotationService']/@address"  $ColQuotationService
Config "/configuration/system.serviceModel/client/endpoint[@name='WSHttpBinding_IUserAuthenticationServiceWcf']/@address"  $ColAuthenticationService
Config "/configuration/system.serviceModel/client/endpoint[@name='WSHttpBinding_ICOLService']/@address"  $COLService
Config "/configuration/system.serviceModel/client/endpoint[@name='WSHttpBinding_IAccountManagementService']/@address"  $AdministrationService
Config "/configuration/system.serviceModel/client/endpoint[@name='WSHttpBinding_IQuoteFacadeService']/@address"  $QuoteFacadeServiceAddress

## bindings
Config "/configuration/system.serviceModel/bindings/wsHttpBinding/binding[@name='InvestmentServiceWSHttpBinding']/security/@mode"  $WcfSecurityMode

## behaviours
if ($environment -ne "integration") {
	Replace "/configuration/system.serviceModel/behaviors/serviceBehaviors/behavior/serviceCredentials/serviceCertificate"  $ServiceCertificate
}

if ($environment -eq "staging" -or $environment -eq "uat") {
	if (($config.Contains("AdviserSite")) -or ($config.Contains("InvestorSite")))
	{
		if ($environment -eq "uat") {
			Add "configuration/appSettings" "<add key=""AdvisorSiteType"" value=""xxxxx"" />"
			Add "configuration/system.web" "<machineKey	validationKey=""E03711E15EA57C3A958199DD773AEC58FEEB366FDEF2E5A1C9E4B6303333839F67917B8088706FCCFFC36E1AB753C35CD83B958BA3D8545CAD37731C345380A7"" decryptionKey=""94CE87558CF654C624CFF4831C6CB65C701C50B97F4EC42DF481088EC74A30F4"" validation=""SHA1"" decryption=""AES"" />"
			Add "configuration/system.web" "<httpCookies httpOnlyCookies=""true"" requireSSL=""false"" lockItem=""true"" />"
			Add "configuration/system.web" "<sessionState cookieless = ""false""
			   regenerateExpiredSessionId = ""true""
			   mode = ""Custom""
			   customProvider = ""NCacheSessionProvider""
			   timeout = ""10"">
			  <providers>
				<add name = ""NCacheSessionProvider""
					   type = ""Alachisoft.NCache.Web.SessionState.NSessionStoreProvider""
					   sessionAppId = ""PhoenixSession""
					   cacheName = ""SessionCache""
					   enableSessionLocking = ""false""
					   sessionLockingRetry = ""-1""
					   writeExceptionsToEventLog = ""false""
					   enableLogs = ""false""
					   enableDetailLogs = ""false""
					   exceptionsEnabled = ""false""/>
			  </providers>
			</sessionState>"			
		} else {
			Config "configuration/system.web/httpCookies/@requireSSL" "true"
		}
	}
	
	if ($config.Contains("OneVue"))
	{
		Remove "configuration/system.serviceModel/bindings/wsHttpBinding/binding/security/message"
#		Config "configuration/system.serviceModel/client/endpoint[@name='WSHttpBinding_ICOLService']/identity/userPrincipalName/@value" "host/uat01.app.onevue.au.xxxxx.net"
	}
	
	if ($config.Contains("WcfBackEnd"))
	{
		Config "configuration/xxxxxStsClientSettings/@onlineUserStsEndpointAddress" $onlineUserStsEndpointAddress
		Config "configuration/xxxxxStsClientSettings/@apiUserStsEndpointAddress" $apiUserStsEndpointAddress
	}
}

if ($environment -eq "staging") {	
	Config "microsoft.identityModel/service/audienceUris" "<add value=""https://aolstaging.xxxxx.com.au/"" />"
	Remove "microsoft.identityModel/service/issuerNameRegistry/trustedIssuers/add"
	Add "microsoft.identityModel/service/issuerNameRegistry/trustedIssuers" "<add thumbprint=""A334896CC8076626EB49FC147A19AE054153F8A9"" name=""CN=*.staging.au.xxxxx.net, OU=xxxxx, O=xxxxx, L=SYDNEY, S=NSW, C=AU"" />"
	Add "microsoft.identityModel/service/issuerNameRegistry/trustedIssuers" "<add thumbprint=""25462c34f8e77f8de3df213e1e75a6f37c7dcacd"" name=""CN = ADFS Signing - wer.federation.rrrrr.com.au"" />"
	Config "microsoft.identityModel/service/federatedAuthentication/wsFederation/@realm" "https://aolstaging.xxxxx.com.au/"
	
	if (($config.Contains("AdviserSite")) -or ($config.Contains("InvestorSite")))
	{
		Config "microsoft.identityModel/service/federatedAuthentication/wsFederation/@requireHttps" "true"
		Config "microsoft.identityModel/service/federatedAuthentication/cookieHandler/@requireSsl" "true"
	}
	Config "microsoft.identityModel/service/serviceCertificate/certificateReference/@findValue" $CertificateFriendlyName
	Config "configuration/system.web/compilation/@debug" "false"
	
	Config "configuration/system.serviceModel/client/endpoint[@name='WSHttpBinding_ICOLService']/identity/userPrincipalName/@value" "qqqqq@au.rrrrr.net"
}
if ($config.Contains("WcfBackEnd") -or $config.Contains("Phoenix.MessageHandler"))
{
	if ($environment -eq "production1") {	
		Config "configuration/system.net/mailSettings/smtp" '<smtp><network host="xxx.au.rrrrr.net" port="25" defaultCredentials="false"/></smtp>'
	}
}
