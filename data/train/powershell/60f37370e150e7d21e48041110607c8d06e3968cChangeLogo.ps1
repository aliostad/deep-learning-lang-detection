function ChangeLogo{
    # Load Dependencies
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    # Check if path is set
    CheckSettings
    # Build Label
    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10,20)
    $objLabel.Size = New-Object System.Drawing.Size(280,20)
    $objLabel.Text = "Enter the new logo path"

    $panel1.Controls.add($objLabel)

    # Build Textbox
    $global:logoTextBox = New-Object System.Windows.Forms.TextBox
    $global:logoTextBox.Location = New-Object System.Drawing.Size(10,40)
    $global:logoTextBox.Size = New-Object System.Drawing.Size(260,20)
    $global:logoTextBox.Text = Get-Content .\settings.txt
    $panel1.Controls.add($logoTextBox)
    # Build OkButton
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(300,40)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.BackColor = "Gray"
    $OKButton.ForeColor = "White"
    $OKButton.Text = "Change"
    $OKButton.Add_Click({
        # Check if Path is Valid
        if(test-path $global:logoTextBox.Text){
           ChangeImg $global:logoTextBox.Text
        } else {
            # If path is not valid show error
            showError
        }
    })

    $panel1.Controls.add($OKButton)

}

function ChangeImg($imgPath){
    # Load dependencies
    Add-Type -Path dependencies\HtmlAgilityPack.dll
    $doc = New-Object HtmlAgilityPack.HtmlDocument
    $path = Get-Content .\settings.txt
    $files = Get-ChildItem $path -Filter *.html -Recurse
    #All files
    $items = @()
    $result = $files | %{
    $name = $_.Fullname.Replace($path, "").Replace("\", "/")
    $sections = $name.Split("/")
    $length = $sections.Count
    $name = $sections[($length-1)]
    if($length -gt 2){
      $section = $sections[($length-2)]
    }else{
      $section = "/"
    }
    # Get Img-Tag with class "logo"
    $htmldoc = $doc.Load($_.FullName)
    $img = $doc.DocumentNode.SelectSingleNode("//img[@src and @class='logo']")
        if($img -eq $NULL){
            # Workaround: Command "Not Equal" not working
        }else{
            # Replace src value
            $img.SetAttributeValue("src",$imgPath)
            $doc.Save($_.FullName)
        }
    }
    showPopup "Logo changed successfully"
}
