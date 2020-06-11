function Get-ChildItemColor {
<#
.Synopsis
  Returns childitems with colors by type.
.Description
  This function wraps Get-ChildItem and tries to output the results
  color-coded by type:
  Directories - Cyan
  Compressed - Red
  Executables - Green
  Text Files - Gray
  Image Files - Magenta
  Others - Gray
.ReturnValue
  All objects returned by Get-ChildItem are passed down the pipeline
  unmodified.
.Notes
  NAME:      Get-ChildItemColor
  AUTHOR:    Tojo2000 <tojo2000@tojo2000.com>
#>
  $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
      -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)
 
  $fore = $Host.UI.RawUI.ForegroundColor
  $compressed = New-Object System.Text.RegularExpressions.Regex(
      '\.(zip|tar|gz|rar|7z|tgz|bz2)', $regex_opts)
  $executable = New-Object System.Text.RegularExpressions.Regex(
      '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg|sh)', $regex_opts)
  $text_files = New-Object System.Text.RegularExpressions.Regex(
      '\.(txt|cfg|conf|ini|csv|log)', $regex_opts)
  $image_files = New-Object System.Text.RegularExpressions.Regex(
      '\.(bmp|jpg|png|gif|jpeg)', $regex_opts)
 
  Invoke-Expression ("Get-ChildItem $args") |
    %{
      if ($_.GetType().Name -eq 'DirectoryInfo') { $Host.UI.RawUI.ForegroundColor = 'Cyan' }
      elseif ($compressed.IsMatch($_.Name)) { $Host.UI.RawUI.ForegroundColor = 'Red' }
      elseif ($executable.IsMatch($_.Name)) { $Host.UI.RawUI.ForegroundColor = 'Green' }
      elseif ($text_files.IsMatch($_.Name)) { $Host.UI.RawUI.ForegroundColor = 'Gray' }
      elseif ($image_files.IsMatch($_.Name)) { $Host.UI.RawUI.ForegroundColor = 'Magenta' }
      else { $Host.UI.RawUI.ForegroundColor = 'Gray' }
      echo $_
      $Host.UI.RawUI.ForegroundColor = $fore
    }
}

function Show-Color( [System.ConsoleColor] $color ) {
    $fore = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $color
    echo ($color).toString()
    $Host.UI.RawUI.ForegroundColor = $fore
}

function Show-AllColor {
    Show-Color('Black')
    Show-Color('DarkBlue')
    Show-Color('DarkGreen')
    Show-Color('DarkCyan')
    Show-Color('DarkRed')
    Show-Color('DarkMagenta')
    Show-Color('DarkYellow')
    Show-Color('Gray')
    Show-Color('DarkGray')
    Show-Color('Blue')
    Show-Color('Green')
    Show-Color('Cyan')
    Show-Color('Red')
    Show-Color('Magenta')
    Show-Color('Yellow')
    Show-Color('White')
}