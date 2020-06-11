function Save-DataSource {
<#
.Synopsis
Save a DataSource

.Description
Saves a Intellidimension.Rdf.DataSource instance to a file or to the PowerShell object pipeline as a stream. If multiple DataSource instances are piped to Save-DataSource they will be merged and a single DataSource will be saved

.Link

.Example
$ds | Save-DataSource -File .\RDF.xml

.Parameter dataSource
The DataSource instance to save

.Parameter file
The file to output the DataSource into

.Parameter format
The format of the saved DataSource

.Notes
	History:
		v0.1 - saves a datasource to a stream or file
#>
	[CmdletBinding()]

	param (
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
		[Alias("ds")]
		[Intellidimension.Rdf.DataSource] $dataSource,

		[Parameter(Mandatory = $false, Position = 1)]
		[Alias("f")]
		[ValidateSet("RDFXML", "TURTLE", "NTRIPLES", "NQUADS", "SNAPSHOT")]
		[string] $format = "RDFXML",

		[Parameter(Mandatory = $false, Position = 2)]
		[Alias("p")]
		[IO.FileInfo] $file
	)

	begin {
		$dataSources = @()
	}
	process {
		$dataSources += $ds
	}
	end {
		#set output stream
		if ($file -ne $null) {
			$stream = $file.Create()
		}
		else {
			$stream = New-Object IO.MemoryStream
		}

		#write results to stream
		if ($dataSources.length -eq 1 -and $dataSources[0] -is [Intellidimension.Rdf.InMemoryGraph]) {
			toStream $stream $format $ds
		}
		elseif ($dataSources.length -ge 1) {
			#merge all datasources and write them as a single datasource to the target stream
			$mergedDS = New-Object Intellidimension.Rdf.InMemoryGraph 4
			$dataSources | %{ $mergedDS.Merge($_) }
			toStream $stream $format $mergedDS
		}
	}
}

function toStream {
	param (
		[IO.Stream] $stream,
		[string] $format,
		[Intellidimension.Rdf.DataSource] $dataSource
	)

	$format = $format.ToUpperInvariant()
	Write-Debug "Format: $format"
	if ($format -eq "SNAPSHOT") {
		$dataSource.Save($stream)
	}
	else {
		$streamWriter = New-Object IO.StreamWriter $stream
		$options = New-Object Intellidimension.Rdf.RdfFormatterOptions
		switch ($format) {
			"TURTLE" {
				$rdfFormatter = New-Object Intellidimension.Rdf.TurtleFormatter @($dataSource, $options)
			}
			"NTRIPLES" {
				$rdfFormatter = New-Object Intellidimension.Rdf.NTriplesFormatter @($dataSource, $options)
			}
			"NQUADS" {
				$rdfFormatter = New-Object Intellidimension.Rdf.QuadFormatter @($dataSource, $options)
			}
			"RDFXML" {
				$rdfFormatter = New-Object Intellidimension.Rdf.RdfXmlFormatter @($dataSource, $options)
			}
		}
		$rdfFormatter.Write($streamWriter)
		$streamWriter.Dispose()
	}
}
