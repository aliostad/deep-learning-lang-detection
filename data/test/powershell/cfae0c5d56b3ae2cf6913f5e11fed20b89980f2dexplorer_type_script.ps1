# http://poshcode.org/4083

$nul = "<NULL>"

$type = "Directory","File"



function Show-Error ([string]$mes) {

  [Windows.Forms.MessageBox]::Show($mes,"Error",
    [Windows.Forms.MessageBoxButtons]::OK,
    [Windows.Forms.MessageBoxIcon]::Exclamation
  )

}



function Add-RootsTree {

  [IO.Directory]::GetLogicalDrives() | % {
    $nod = $tvRoots.Nodes.Add($_)
    $nod.Nodes.Add($nul)
  }

}



function Add-Folders {

  $_.Node.Nodes.Clear()

  try {
    foreach ($i in [IO.Directory]::GetDirectories($_.Node.FullPath)) {
      $node = $_.Node.Nodes.Add([IO.Path]::GetFileName($i))
      $node.Tag = $type[0]
      $node.Nodes.Add($nul)
    }
  }
  catch {
    Show-Error $_.Exception.Message
  }
}



function Add-Files {
  try {
    foreach ($i in [IO.Directory]::GetFiles($_.Node.FullPath)) {
      $node = $_.Node.Nodes.Add([IO.Path]::GetFileName($i))
      $node.Tag = $type[1]
    }
  }
  catch {}
}


$tvRoots_AfterSelect = {
  switch ($_.Node.Tag) {
    $type[0] { $sbPnl_2.Text = $type[0]; break }
    $type[1] { $sbPnl_2.Text = $type[1]; break }
  }
}



$tvRoots_BeforeExpand = {
  Add-Folders
  Add-Files
}



function frmMain_Show {
  Add-Type -AssemblyName System.Windows.Forms
  [Windows.Forms.Application]::EnableVisualStyles()
  $ico = [Drawing.Icon]::ExtractAssociatedIcon(($PSHome + '\powershell.exe'))
  $frmMain = New-Object Windows.Forms.Form
  $tvRoots = New-Object Windows.Forms.TreeView
  $sbPanel = New-Object Windows.Forms.StatusBar
  $sbPnl_1 = New-Object Windows.Forms.StatusBarPanel
  $sbPnl_2 = New-Object Windows.Forms.StatusBarPanel
  #
  #tvRoots
  #
  $tvRoots.Dock = "Fill"
  $tvRoots.Add_AfterSelect($tvRoots_AfterSelect)
  $tvRoots.Add_BeforeExpand($tvRoots_BeforeExpand)
  #
  #sbPanel
  #
  $sbPanel.Panels.AddRange(@( $sbPnl_1,$sbPnl_2))
  $sbPanel.ShowPanels = $true
  $sbPanel.SizingGrip = $false
  #
  #sbPnl_1
  #
  $sbPnl_1.AutoSize = "Spring"
  $sbPnl_1.Text = "Follow me at @gregzakharov"
  #
  #sbPnl_2
  #
  $sbPnl_2.Alignment = "Center"
  $sbPnl_2.AutoSize = "Contents"
  $sbPnl_2.Text = "Not clicked item yet"
  #
  #frmMain
  #
  $frmMain.ClientSize = New-Object Drawing.Size (350,350)
  $frmMain.Controls.AddRange(@( $tvRoots,$sbPanel))
  $frmMain.FormBorderStyle = "FixedSingle"
  $frmMain.Icon = $ico
  $frmMain.StartPosition = "CenterScreen"
  $frmMain.Text = "Explorer Style Script"
  $frmMain.Add_Load({ Add-RootsTree })
  [void]$frmMain.ShowDialog( )
}


frmMain_Show

