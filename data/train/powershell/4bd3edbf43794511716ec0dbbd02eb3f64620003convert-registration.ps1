function ConvertFrom-XLSx {
  param ([parameter(             Mandatory=$true,
                         ValueFromPipeline=$true, 
           ValueFromPipelineByPropertyName=$true)]
         [string]$path , 
         [string]$savePath,
         [switch]$PassThru
        )

  begin { $objExcel = New-Object -ComObject Excel.Application }
Process { if ((test-path $path) -and ( $path -match ".xl\w*$")) 
          {
              $path = (resolve-path -Path $path).path 
              if ($savePath -eq "")
              {
                $savePath = $path -replace ".xl\w*$",".csv"
              }
              $objworkbook=$objExcel.Workbooks.Open( $path)
              $objworkbook.SaveAs($savePath,6) # 6 is the code for .CSV 
              $objworkbook.Close($false) 
           
              if ($PassThru) {Import-Csv -Path $savePath } 
          }
          else {Write-Host "$path : not found"} 
        } 
   end  { $objExcel.Quit() }
}


function repro()
{ 
  $ErrorActionPreference = "Stop"

  write-host -foreground green "Scanning for files in [$(get-location)]"

  # make sure to force it into an array in case there's only one
  $candidates = @(dir -filter *.xlsx)
  write-host -foreground green "Found [$($candidates.count)] XLSX files"
  if ($candidates.count -gt 1) { throw "too many XLSX files, need only one"}
  if ($candidates.count -lt 1) { throw "couldn't find any XLSX files here"}

  # now we know there's only one
  $candidate = $candidates
  write-host -foreground green "Converting files [$candidate]"
  #$outcsv = "registrationOut.csv"
  # convert and canonicalize
  $candidate = (resolve-path $candidate).path

  $outCsv = [system.io.path]::ChangeExtension($candidate, "csv")

  if (test-path $outcsv) { remove-item $outcsv }

  # convert to CSV
  ConvertFrom-XLSx -path $candidate -savepath $outCsv

  $lines = gc $outCsv
  write-host -foreground green "Read in $($lines.count) lines"  
  # remove the first, bogusest, line and convert to records
  $lines = $lines | select -skip 1
  
  # we have to save it to a file so that we can split across the line breaks
  $lines > $outCsv
  $records = import-csv $outCsv
  write-host -foreground green "Converted to $($records.count) records"

  # strip out all the wrong records, which have no name?
  $filtered = $records | ? { !(bogus-record $_)}
  write-host -foreground green "Filtered down to $($filtered.count) records"

  $filtered | % { write-record $_ } > records.txt

  &notepad records.txt
}

function bogus-record($rec)
{
  # note $records[3] is bogus
  return ($rec.('Participant: Name') -eq "" -or
          $rec.('Participant: Name') -eq "Participant: Name")
}

# rewrite the properties:
function write-record($rec)
{
  write-output "Name: $($rec.('Primary P/G: Name'))"
  write-output "Address: $($rec.('Primary P/G: Address'))"
  write-output "Phone: $($rec.('Primary P/G: Cell phone number'))"
  write-output "Email Address: $($rec.('Primary P/G: Email address'))"
  write-output "Child's name/DOB: $($rec.('Participant: Name')) $($rec.('Participant: Date of birth'))"
  write-output "Class: $($rec.('Session name'))"
  write-output ""
  # todo: class, date of registration   
}

repro