<#
CSharpAndPowerShell Modules, tries to help Microsoft Windows admins to write automated scripts easier.
Copyright (C) 2015  Cristopher Robles Ríos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

Function Show-MessageBox
{
	<#
    .SYNOPSIS
    Muestra una ventana de información o de opciones.
    
    .DESCRIPTION
	Muestra una ventana de mensaje o de opciones. Esta funcion se puede cargar a una variable y validad contra la etiqueta del botón.
	
    .EXAMPLE
	Show-MessageBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia"
	Show-MessageBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia" -Buttons YesNoCancel
    Show-MessageBox -Title "Titulo de Ventana" -Message "Mensaje a mostrar o advertencia" -Type Error -Buttons RetryCancel
	
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
 
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param (
		[Parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true, HelpMessage = "Cuerpo de la ventana.")]
		[string]$Message,
		[Parameter(ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true, HelpMessage = "Titulo de la ventana.")]
		[string]$Title,
		[Parameter(ValueFromPipeline = $true, Position = 2, ValueFromPipelineByPropertyName = $true, HelpMessage = "Tipo de botones a mostrar.")]
		[ValidateSet("OK", "OKCancel", "AbortRetryIgnore", "YesNoCancel", "YesNo", "RetryCancel")]
		[String]$Buttons = "OK",
        [Parameter(ValueFromPipeline = $true, Position = 3, ValueFromPipelineByPropertyName = $true, HelpMessage = "Tipo de ventana a mostrar.")]
		[ValidateSet("Asterisk", "Exclamation", "None", "Question", "Stop", "Error", "Information", "Warning")]
		[String]$Type = "None"
	)
	
	Begin
	{
		[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null 
	}
	
	Process
	{
        [Windows.Forms.MessageBox]::Show($Message, $Title, [Windows.Forms.MessageBoxButtons]::$Buttons, [System.Windows.Forms.MessageBoxIcon]::$Type,`
        [System.Windows.Forms.MessageBoxDefaultButton]::Button1, [System.Windows.Forms.MessageBoxOptions]::DefaultDesktopOnly)
	}
}