$global:SqlServerConnectionString     = "Data Source=localhost;Initial Catalog=Phoenix;Integrated Security=SSPI;";
$global:QuoteFacadeSqlConnectionString  = "Data Source=localhost;Initial Catalog=Quote;Integrated Security=SSPI;"; 
$global:HttpWcfFrontEndAddress = "http://stagingservices.mckelt.com.au";
$global:HttpWcfBackEndAddress = "http://localhost/services/phoenixquoteservice.svc";
$global:NetTcpWcfBackEndAddress = "net.tcp://app2.staging.au.mckelt.net:808/services/";
$global:ColQuotationService = "http://app.staging.au.mckelt.net:48484/COL_1_6/QuotationService/QuotationService.svc";
$global:ColAuthenticationService = "http://app.ffff.au.mckelt.net:48484/COL_1_6/UserAuthentication/UserAuthenticationServiceWcf.svc";
$global:WcfSecurityMode = "Message";
$global:UseRealAuthenticationService = "true";
$global:COLService = "http://staging.app.registrySystem.au.mckelt.net:8732/mckelt.registrySystemSvc/COLService/"
$global:UserPrincipleName = "user@au.mckelt.net"
$global:CmsMenuFolderPath = "C:\Websites\AdviserOnline\"
$global:CmsMenuFileName = "index.xml"
$global:StsServer = "localhost"
$global:EnableCache = "<property name=""cache.use_second_level_cache"">true</property>"
$global:CertificateFriendlyName = "*.staging.au.mckelt.net"
$global:ServiceIdentityDns = "*.staging.au.mckelt.net"
$global:ServiceCertificate  = "<serviceCertificate findValue='*.mckelt.com.au' storeLocation='LocalMachine' storeName='My' x509FindType='FindBySubjectName' />";
$global:IsSessionMode = "true"
$global:onlineUserStsEndpointAddress = "https://Box2.au.mckelt.net/AuthenticationSite/Services/OnlineUserSts.svc/mixed/username"
$global:apiUserStsEndpointAddress = "https://Box2.au.mckelt.net/AuthenticationSite/Services/ApiUserSts.svc/mixed/username"
$global:AdministrationService = "https://Box2.au.mckelt.net/administrationsite/Services/AccountManagementService.svc"
$global:QuoteFacadeServiceAddress = "https://Box.au.mckelt.net:2525/Services/QuoteFacadeService.svc"
