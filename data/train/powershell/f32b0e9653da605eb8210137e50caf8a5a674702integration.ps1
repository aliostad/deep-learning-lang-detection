$global:SqlServerConnectionString     = "Data Source=xxxxx;Database=xxxxx_Integration; User Id=xxxxxuser; Password=xxxxx;"
$global:QuoteFacadeSqlConnectionString     = "Data Source=fffffff;Database=rrrrrr_Integration; User Id=xxxxxuser; Password=xxxxx;"
$global:ExcelDataSeedFile     = "c:\Test_Scenario_Data.xlsx";
$global:HttpWcfFrontEndAddress = "http://localhost:7171/services/InvestmentServiceV1.svc";
$global:HttpWcfBackEndAddress = "http://localhost:8181/services/";
$global:NetTcpWcfBackEndAddress = "net.tcp://localhost:808/services/xxxxxQuoteService";
$global:ColQuotationService = "http://mckelt.uuuuuu.net:48452/COL_1_6/QuotationService/QuotationService.svc";
$global:ColAuthenticationService = "http://mckelt.uuuuuu.net:48452/COL_1_6/UserAuthentication/UserAuthenticationServiceWcf.svc";
$global:WcfSecurityMode = "Message"
$global:UseRealAuthenticationService = "true"
$global:COLService = "http://uat01.app.mySvc.au.uuuuuu.net:8732/uuuuuu.mySvcSvc/COLService/"
$global:CmsMenuFolderPath = "\\xxxxx\Contect\"
$global:CmsMenuFileName = "index.xml"
$global:StsServer = "xxxxx"
$global:EnableCache = "<property name=""cache.use_second_level_cache"">false</property>"
$global:CertificateFriendlyName = "*.au.uuuuuu.net"
$global:ServiceIdentityDns = "*.au.uuuuuu.net"
$global:ServiceCertificate  = "<serviceCertificate findValue='*.au.uuuuuu.net' storeLocation='LocalMachine' storeName='My' x509FindType='FindBySubjectName' />";
$global:IsSessionMode = "true"
$global:onlineUserStsEndpointAddress = "https://xxxxx.au.uuuuuu.net/AuthenticationSite/Services/OnlineUserSts.svc/mixed/username"
$global:apiUserStsEndpointAddress = "https://xxxxx.au.uuuuuu.net/AuthenticationSite/Services/ApiUserSts.svc/mixed/username"
$global:AdministrationService = "https://xxxxx.au.uuuuuu.net/administrationsite/Services/AccountManagementService.svc"
$global:QuoteFacadeServiceAddress = "https://yyyyy.au.uuuuuu.net:2121/services/QuoteFacadeService.svc"

