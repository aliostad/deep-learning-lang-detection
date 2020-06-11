set-executionpolicy RemoteSigned
$solution_path = 'E:\VSProjects\Palantir\'
get-childitem $solution_path -recurse -exclude ".hg", ".bin" -include "*.csproj" | foreach {
    
    $doc = New-Object System.Xml.XmlDocument
    $doc.Load($_.FullName)
    $manager = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
    $manager.AddNamespace("tns", "http://schemas.microsoft.com/developer/msbuild/2003");
    $namespaceNode = $doc.SelectSingleNode("//tns:RootNamespace", $manager)
    $assemblyNode = $doc.SelectSingleNode("//tns:AssemblyName", $manager)
    #$namespaceNode = $doc.SelectSingleNode("/tns:Project/tns:PropertyGroup/RootNamespace", $manager)

    if ($assemblyNode -and (
         $assemblyNode.InnerText -eq "CreateZip" -or
         $assemblyNode.InnerText -eq "ReadZip" -or
         $assemblyNode.InnerText -eq "ZipDir" -or
         $assemblyNode.InnerText -eq "ZipTreeView" -or
         $assemblyNode.InnerText -eq "Ionic.Examples.Smartphone.Zip" -or
         $assemblyNode.InnerText -eq "CF-Unzipper" -or
         $assemblyNode.InnerText -eq "RouteDebug" -or
         $assemblyNode.InnerText -eq "Brettle.Web.NeatUpload" -or
         $assemblyNode.InnerText -eq "Mark.Tidy" -or
         $assemblyNode.InnerText -eq "TracerX" -or
         $assemblyNode.InnerText -eq "TracerX-Logger" -or
         $assemblyNode.InnerText -eq "TracerX-Viewer" -or
         $assemblyNode.InnerText -eq "ManageWindowsCounters" -or
         $assemblyNode.InnerText -eq "TrafficMon" -or
         $assemblyNode.InnerText -eq "WCFExtras" -or
         $assemblyNode.InnerText -eq "Run_load_tests" -or
         $assemblyNode.InnerText.StartsWith("dotless.") -or
         $assemblyNode.InnerText.StartsWith("antlr.") -or
         $assemblyNode.InnerText.StartsWith("Antlr") -or
         $assemblyNode.InnerText.StartsWith("StringTemplate") -or
         $assemblyNode.InnerText.Contains("console") -or
         $assemblyNode.InnerText.Contains("JsLibrariesCombiner") -or
         $assemblyNode.InnerText -eq "LoadTestPlugin"
    
        ))
    {
        return
    }

    if ($namespaceNode -and $namespaceNode.InnerText -and !$namespaceNode.InnerText.StartsWith("Ix."))
    {
        write $_.Name
        #$namespaceNode.InnerText = "Ix.Palantir." + $namespaceNode.InnerText
    }
    
    if ($assemblyNode -and $assemblyNode.InnerText -and !$assemblyNode.InnerText.StartsWith("Ix."))
    {
        write $_.Name
        #$assemblyNode.InnerText = "Ix.Palantir." + $assemblyNode.InnerText
    }
    
    $doc.Save($_.FullName)
}