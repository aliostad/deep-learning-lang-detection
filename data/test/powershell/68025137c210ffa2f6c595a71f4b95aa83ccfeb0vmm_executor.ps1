#
$Dir = Split-Path $script:MyInvocation.MyCommand.Path
. ([System.IO.Path]::Combine($Dir, "manage_credentials.ps1"))
. ([System.IO.Path]::Combine($Dir, "manage_trusted_hosts.ps1"))

# execute script block for VMM
function execute($block, $vmm_server_address, $proxy_server_address)
{
  $proxy_credential = $null
  if ($proxy_server_address -ne $null )
  {
    $proxy_credential = Get-Creds $proxy_server_address "Credentials for proxy server: $proxy_server_address"
  }
  $vmm_credential = Get-Creds $vmm_server_address "Credentials for VMM server: $vmm_server_address"
  
  #
  $init_vmm_block = {
    try {
      ipmo 'C:\Program Files\Microsoft System Center 2012 R2\Virtual Machine Manager\bin\psModules\virtualmachinemanager'
    } catch
    {
      write-error 'You need to install Virtual Machine Manager R2 client first.'
      throw $_.Exception
    }
    #
    $proxy_credential = $using:proxy_credential # make those available within $block as well
    $vmm_server = Get-VMMServer -ComputerName $using:vmm_server_address -Credential $using:vmm_credential
  }
  # prepend init block to execution block
  $block_to_run = [ScriptBlock]::Create($init_vmm_block.ToString() + $block.ToString())
  #
  if ( $proxy_server_address -eq $null )
  {
    $res = $(Start-Job $block_to_run | Wait-Job | Receive-Job)
  } else
  {
    Add-To-Trusted $proxy_server_address
    $so = New-PSSessionOption -IdleTimeout 240000 
    $res = invoke-command -ComputerName $proxy_server_address -Credential $proxy_credential -ScriptBlock $block_to_run -SessionOption $so
    Remove-From-Trusted $proxy_server_address
  }
  return $res
}
