$common = "..\..\Common"
Import-Module "$Common\helperReport.psm1" -Force
Set-ReportFile -Folder "." -File ".\Output.htm" -OverWrite $true   #Set a report file

#Working with Table
Add-TableStart -Width 700 -CellPadding 3
Set-TableColumnWidth 200, 200, 300
Add-TableStartRow
Add-TableCells -data "Name", "Address", "WebSite" -isHeader $true
Add-TableEndRow
Add-TableStartRow
Add-TableCells -data "Rahul" -isGreen $true -align "left"
Add-TableCells -data "Soni" -isRed $true -align "left"
Add-TableCells -data "www.dotnetscraps.com" -isGreen $true -align "center"
Add-TableEndRow
Add-TableEnd

#Working with heading & text
Add-HeadingText1 -Message "Hello World - 1"
Add-HeadingText2 -Message "Hello World - 2"
Add-HeadingText3 -Message "Hello World - 3"
Add-HeadingText4 -Message "Hello World - 4"
Add-HeadingText5 -Message "Hello World - 5"
Add-HeadingText6 -Message "Hello World - 6"
Add-Text -Message "Hello World" -align "center"

#Working with line breaks
Add-Text -Message "Before Line break"
Add-LineBreak -Count 3
Add-Text -Message "After line break"

#Working with time stamp
Add-TimeStamp -Format 1
Add-TimeStamp -Format 4
Add-TimeStamp -Format 6

#Working with list
Add-ListStart -Style 3 -IsInline $true
Add-ListItem -Message "Item 1"
Add-ListItem -Message "Item 2" -IsBold $true -Color Blue
Add-ListItem -Message "Item 3" -IsBold $true -Color Red
Add-ListItem -Message "Item 4" -Color Green
Add-ListItem -Message "Item 5"
Add-ListEnd 

Add-ListStart -Style 5 -IsInline $true
Add-ListItem -Message "Item 1", "Item 2", "Item 3" -IsBold $true
Add-ListItem -Message "Item 1"
Add-ListItem -Message "Item 2" -IsBold $true -Color Blue
Add-ListItem -Message "Item 3" -IsBold $true -Color Red
Add-ListItem -Message "Item 4", "Item 5"
Add-ListItem -Message "Item 6" -Color Blue -IsBold $true -FontSize 20px
Add-ListEnd 

#Working with Scrollable area with smaller content
Add-ScrollableAreaStart -Margin "10px auto auto auto"
Add-Text "Hello Again!"
Add-ScrollableAreaEnd

Add-LineBreak -Count 2

#Working with Scrollable area with larger content
Add-ScrollableAreaStart -BorderColor White -BorderWidth 1 -Margin "auto" -Padding 2 -Width 600

    #Add a table with larger width than the box
    Add-TableStart -Width 700 -CellPadding 3
    Set-TableColumnWidth 200, 200, 300
    Add-TableStartRow
    Add-TableCells -data "Name", "Address", "WebSite" -isHeader $true
    Add-TableEndRow
    Add-TableStartRow
    Add-TableCells -data "Rahul" -isGreen $true -align "left"
    Add-TableCells -data "Soni" -isRed $true -align "left"
    Add-TableCells -data "www.dotnetscraps.com" -isGreen $true -align "center"
    Add-TableEndRow
    Add-TableEnd

Add-ScrollableAreaEnd

Add-LineBreak -Count 2
#Viewing the table in browser
Get-Table -OpenInBrowser $true -InsertCSS "$common\style.css"