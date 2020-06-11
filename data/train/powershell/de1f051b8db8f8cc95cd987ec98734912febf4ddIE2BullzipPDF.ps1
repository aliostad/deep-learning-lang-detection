##################################################################################
#
#  Script name: IE2BullzipPDF.ps1 
#  Author:      Trevor Hoffman
#  Homepage:    N/A
#
#  Based off of a script from Steve Illichevsky's work on GitHub (stillru/PersonalPakage/Scripts/Powershell/Bullzip-print.ps1)
##################################################################################

param([string]$In, [string]$Out, [int]$PageDelay, [int]$PrintDelay)

function GetHelp() {

$HelpText = @"

IE2BullzipPDF
=============

Windows Powershell script that Prints a webpage to a PDF.

Author:       Trevor Hoffman

Contributors: Based off of a script from Steve Illichevsky's work on GitHub (stillru/PersonalPakage/Scripts/Powershell/Bullzip-print.ps1)

DESCRIPTION:

NAME: IE2BullzipPDF.ps1 

Print a webpage as a PDF.

PARAMETERS: 

-In          Input file

-Out         Output PDF file (Must be an ABSOLUTE path...RELATIVE paths do not work)

-PageDelay   Integer denoting how many seconds to wait for IE to load webpage (use larger page delays for websites that use Javascript more heavily...even then, the page might not print exactly as seen in the browser)

-PrintDelay  Integer denoting how many seconds to wait for IE to send the page to the PDF printer

-help        Show this help file

SYNTAX:

IE2BullzipPDF.ps1 -In www.google.com  -Out C:\file.pdf

Convert webpage to pdf

IE2BullzipPDF.ps1 -help

Displays the help topic for the script

Additional Information:

This script requires Internet Explorer and Bullzip to be installed on computer


"@
$HelpText
}

function PrintPDF ([string]$In, [string]$Out, [int]$PageDelay, [int]$PrintDelay) {

    [void][System.Reflection.Assembly]::LoadWithPartialName("Bullzip.PdfWriter");

    # webpage to print
    $webpage = $In
    
    # set page delay
    if (-NOT $PageDelay) {
        $PageDelay = 1
    }
    
    # set print delay
    if (-NOT $PrintDelay) {
        $PrintDelay = 1
    }

    # Setup Bullzip printer
    $settings = new-object Bullzip.PdfWriter.PdfSettings;
    $settings.PrinterName = "Bullzip PDF Printer";
    $settings.SetValue("Output", $Out);
    $settings.SetValue("ShowPDF", "yes");
    $settings.SetValue("ShowSettings", "never");
    $settings.SetValue("ShowSaveAS", "never");
    $settings.SetValue("ShowProgress", "no");
    $settings.SetValue("ShowProgressFinished", "no");
    $settings.SetValue("ConfirmOverwrite", "no");
    $settings.WriteSettings([Bullzip.PdfWriter.PdfSettingsFileType]::RuneOnce);
    
    # Get current default printer
    $defaultprinter = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Default = TRUE"
    
    # Set Bullzip PDF Printer as the default printer
    $printer = Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Name='Bullzip PDF Printer'"
    $printer.SetDefaultPrinter()

    # Load webpage and print it to PDF
    $ie=new-object -com internetexplorer.application
    $ie.navigate($webpage)        
    start-sleep -seconds $PageDelay    
    $ie.execWB(6,2) 
    start-sleep -seconds $PrintDelay    
    $ie.quit()
    
    # Set default printer back to original
    $defaultprinter.SetDefaultPrinter() 
}

if ($help) {
	GetHelp
} elseif ($In -AND $Out) {
	PrintPDF -In $In -Out $Out -PageDelay $PageDelay -PrintDelay $PrintDelay
} else {
    GetHelp  
}
