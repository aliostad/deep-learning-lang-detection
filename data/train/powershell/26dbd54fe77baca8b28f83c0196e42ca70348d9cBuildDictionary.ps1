[IO.Directory]::SetCurrentDirectory((pwd).Path)

$xslt = new-object System.Xml.Xsl.XslCompiledTransform
$setting = new-object System.Xml.Xsl.XsltSettings
$setting.EnableScript = $true

# reader
$reader = [system.xml.XmlReader]::Create("wiki2oed.xsl")

# XmlWriterSetting
$writer_setting = new-object System.Xml.XmlWriterSettings
$writer_setting.Indent = $true

$writer = [System.Xml.XmlWriter]::Create("WikipediaDictionary.dctx", $writer_setting)
$resolver = new-object System.Xml.XmlUrlResolver

# load xsl file
$xslt.Load($reader, $setting, $resolver)

# transform from wiki data to OED format.
$xslt.Transform("jawiki-latest-abstract.xml", $writer)

$reader.Close()
$writer.Close()
