$source = "C:\Clients\Globus\GlobusWebsite\GlobusWebsite";
$destination = "C:\Sitecore\Globus\Website";
$env = "local";

write-output("//////////////////////////////////////////////////////////////////////////////////////");

Copy-Item -Path $source\web.config -Destination $destination -Force;

# copy website dll files
foreach ($dll in Get-ChildItem -Path $source\bin -Recurse)
{
	if ($dll -match "(.*)\.dll$")
    {
        write-output("--------------------------");
        write-output($dll.FullName);
        Copy-Item -Path $source\bin\$dll -Destination $destination\bin\$dll -Force;
    }
}

Copy-Item -Path $source\bin\GlobusWebsite.dll -Destination $destination\bin\GlobusWebsite.dll -Force

# copy layout files (aspx)
foreach ($aspx in Get-ChildItem -Path $source\layouts -Recurse)
{
    if ($aspx -match "(.*)\.aspx$")
    {
        write-output("--------------------------");
        write-output($aspx.FullName);
        Copy-Item -Path $source\layouts\$aspx -Destination $destination\layouts\$aspx -Force;
    }
}

# copy sublayout files (ascx)
if (!(Test-Path $destination\sublayouts))
{
    write-output "Create Sublayout directory";
    New-Item -ItemType directory -Path $destination\sublayouts;
}
foreach ($ascx in Get-ChildItem -Path $source\sublayouts -Recurse)
{
    if ($ascx -match "(.*)\.ascx$")
    {
        write-output($ascx.FullName);
        Copy-Item -Path $source\sublayouts\$ascx -Destination $destination\sublayouts\$ascx -Force;
    }
}
# copy sublayout files (xsl)
if (!(Test-Path $destination\xsl))
{
    write-output "Create Sublayout directory";
    New-Item -ItemType directory -Path $destination\xsl;
}

Robocopy $source\xsl $destination\xsl *.xslt -MIR;

if (!(Test-Path $destination\Webservices))
{
    write-output "Create Sublayout directory";
    New-Item -ItemType directory -Path $destination\Webservices;
}
Robocopy $source\Webservices $destination\Webservices *.asmx -MIR;

# copy data files (xsl)
if (!(Test-Path $destination\XmlData))
{
    write-output "Create XmlData directory";
    New-Item -ItemType directory -Path $destination\XmlData;
}

Robocopy $source\XmlData $destination\XmlData *.xml -MIR;

# copy content files (css images etc)
if (!(Test-Path $destination\Content))
{
    write-output "Create Content directory";
    New-Item -ItemType directory -Path $destination\Content;
}

Robocopy $source\Content $destination\Content -MIR;

