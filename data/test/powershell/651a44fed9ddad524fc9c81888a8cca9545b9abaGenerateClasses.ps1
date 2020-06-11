$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

cd $dir

# Powershell doesn't automatically set the .NET cwd >:(
[Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath

$dll = ls ..\..\packages\XmlSchemaClassGenerator*\lib\*\XmlSchemaClassGenerator.dll | Sort-Object LastModificationTime -Descending | Select-Object -First 1
[System.Reflection.Assembly]::LoadFrom($dll.FullName) | Out-Null
$generator = New-Object XmlSchemaClassGenerator.Generator
$generator.OutputFolder = '..\generated'
$namespaceMapping = New-Object XmlSchemaClassGenerator.NamespaceProvider
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/common/1.0")), "IS24RestApi.Common")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/alterationdate/1.0")), "IS24RestApi.Offer.AlterationDate")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/attachmentsorder/1.0")), "IS24RestApi.AttachmentsOrder")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("ttp://rest.immobilienscout24.de/schema/offer/productbookingoverview/1.0")), "IS24RestApi.Offer.ProductBookingOverview")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/listelement/1.0")), "IS24RestApi.Offer.ListElement")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/premiumplacement/1.0")), "IS24RestApi.Offer.PremiumPlacement")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/user/1.0")), "IS24RestApi.Offer.User")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/productrecommondation/1.0")), "IS24RestApi.Offer.ProductRecommendation")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/toplisting/1.0")), "IS24RestApi.Offer.TopListing")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/realestate/counts/1.0")), "IS24RestApi.Realestate.Counts")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/realestates/1.0")), "IS24RestApi.Offer.RealEstates")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/realestateproject/1.0")), "IS24RestApi.Offer.RealEstateProject")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/realestatestock/1.0")), "IS24RestApi.Offer.RealEstateStock")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/realtor/1.0")), "IS24RestApi.Offer.Realtor")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/realtorbadges/1.0")), "IS24RestApi.Offer.RealtorBadges")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/showcaseplacement/1.0")), "IS24RestApi.Offer.ShowcasePlacement")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/topplacement/1.0")), "IS24RestApi.Offer.TopPlacement")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/videoupload/1.0")), "IS24RestApi.VideoUpload")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/offer/zipandlocationtoregion/1.0")), "IS24RestApi.Offer.ZipAndLocationToRegion")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/platform/gis/1.0")), "IS24RestApi.Platform.Gis")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/user/1.0")), "IS24RestApi.User")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/search/common/1.0")), "IS24RestApi.Search.Common")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/search/expose/1.0")), "IS24RestApi.Search.Expose")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/search/region/1.0")), "IS24RestApi.Search.Region")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/search/savedSearch/1.0")), "IS24RestApi.Search.SavedSearch")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/search/resultlist/1.0")), "IS24RestApi.Search.ResultList")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/search/searcher/1.0")), "IS24RestApi.Search.Searcher")
$namespaceMapping.Add((New-Object XmlSchemaClassGenerator.NamespaceKey("http://rest.immobilienscout24.de/schema/search/shortlist/1.0")), "IS24RestApi.Search.ShortList")
$generator.NamespaceProvider = $namespaceMapping
$generator.GenerateNullables = $true
$generator.GenerateInterfaces = $true
$generator.DataAnnotationMode = [XmlSchemaClassGenerator.DataAnnotationMode]::Partial
$generator.IntegerDataType = [System.Type]::GetType("System.Int32")

[System.String[]]$files = ls */*.xsd | %{ $_.FullName }

echo "Generating classes from:"
echo $files
echo ""
echo "Generating files:"

$generator.Log = [System.Action[System.String]]{ param($s) [System.Console]::Out.WriteLine($s); }

$generator.Generate($files)
