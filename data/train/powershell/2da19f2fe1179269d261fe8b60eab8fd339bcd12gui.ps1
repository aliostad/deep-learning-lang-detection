<#
    This script implements a GUI for setup-proj.ps1.

    WARNING:
        Don't run this script inside an IDE (e.g. Windows PowerShell ISE) because it hides the parent window.
        Your IDE will be hidden and NOT RESTORED (I haven't found a way yet).
        You have to kill its process in order to restart it.

    @license MIT, see LICENSE file.
#>

. ".\setup-proj.ps1";

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing");

$gui = @{};

<#
    Hides the PowerShell console window.
    Thanks to http://blogs.msdn.com/b/powershell/archive/2008/06/03/show-powershell-hide-powershell.aspx
#>
function showPS($show=$True) {
    $script:showWindowAsync = Add-Type –memberDefinition @” 
[DllImport("user32.dll")] 
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow); 
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru

    if ($show) {
        $null = $showWindowAsync::ShowWindowAsync((Get-Process –id $pid).MainWindowHandle, 5);
    }
    else {
        $null = $showWindowAsync::ShowWindowAsync((Get-Process –id $pid).MainWindowHandle, 0);
    }
}

<#
    Initializes the GUI.
    Creates all components and the associated event handlers.
#>
function initGui() {
    showPS -Show $False
    # Init form!
    $form = New-Object System.Windows.Forms.Form;
    $form.Text = "Tsac GUI";
    $form.Size = New-Object System.Drawing.Size(300, 500);
    $form.StartPosition = "CenterScreen";
    $form.KeyPreview = $True;
    $form.Add_Shown({
        $form.Activate();
    });

    $gui.form = $form;

    # Add "Project file:" label
    $lbProjFile = New-Object System.Windows.Forms.Label;
    $lbProjFile.Text = "Project file:";
    $lbProjFile.Location = New-Object System.Drawing.Point(10, 10);
    $form.Controls.Add($lbProjFile);

    # Add browse button for project file
    $btnSelFile = New-Object System.Windows.Forms.Button;
    $btnSelFile.Text = "Click";
    $btnSelFile.Location = New-Object System.Drawing.Point(150, 5);

    $btnSelFile.Size = New-Object System.Drawing.Size(100, $btnSelFile.Size.Height);
    $form.Controls.Add($btnSelFile);

    $btnSelFile.Add_Click({
        $FD = New-Object System.Windows.Forms.OpenFileDialog;
        $FD.Filter = "Project files (*.jsproj)|*.jsproj|All files (*.*)|*.*";
        if ($FD.ShowDialog() -eq ([System.Windows.Forms.DialogResult]::OK)) {
            $gui.projFileName = $FD.FileName;
            $btnSelFile.Text = [IO.Path]::GetFileName($FD.FileName);

            $clbJsFiles.Items.Clear();
            $data = loadProject($gui.projFileName);
            $data.jsFiles | % {
                $clbJsFiles.Items.Add($_.GetAttribute("Include"), $True);
            };
        }
    });

    # Add "First time" checkbox
    $cbFirstUse = New-Object System.Windows.Forms.CheckBox;
    $cbFirstUse.Location = New-Object System.Drawing.Point(10, 30);
    $cbFirstUse.Size = New-Object System.Drawing.Size(15, $cbFirstUse.Size.Height);
    $form.Controls.Add($cbFirstUse);

    $gui.firstTimeUsage = $False;

    $cbFirstUse.Add_Click({
        $gui.firstTimeUsage = ($cbFirstUse.Checked);
    });

    # Add label for "First time" checkbox
    $lblFirstUse = New-Object System.Windows.Forms.Label;
    $lblFirstUse.Text = "Is this the first time you convert the project file?";
    $lblFirstUse.AutoSize = $True;
    $lblFirstUse.Location = New-Object System.Drawing.Point(35, 35);
    $form.Controls.Add($lblFirstUse);
    
    # Add label for CheckedListBox showing all JS files below
    $lbCheckFiles = New-Object System.Windows.Forms.Label;
    $lbCheckFiles.Text = "Select the JS files you want to convert to TS files:";
    $lbCheckFiles.AutoSize = $True;
    $lbCheckFiles.Location = New-Object System.Drawing.Point(5, 70);
    $form.Controls.Add($lbCheckFiles);

    # CheckedListBox showing all JS files to convert to TS files
    $clbJsFiles = New-Object System.Windows.Forms.CheckedListBox;
    $clbJsFiles.Location = New-Object System.Drawing.Point(5, 90);
    $clbJsFiles.Size = New-Object System.Drawing.Size(($form.Size.Width - 25), 200);
    $form.Controls.Add($clbJsFiles);

    $clbJsFiles.Add_SelectedValueChanged({
        $projData.activeJsFiles.Clear();
        $clbJsFiles.Items | % {$i=0} {
            if ($clbJsFiles.GetItemChecked($i) -eq $True) {
                $projData.activeJsFiles.Add($i);
            }
            $i++;
        }
    });

    # Warning message
    $lblWarning = New-Object System.Windows.Forms.Label;
    $lblWarning.AutoSize = $True;
    $lblWarning.Text = @"
WARNING:

Backup all your project data before using this piece of
software!
This tool will change your project file.

See the attached README file for
more information.
"@;
    $lblWarning.Location = New-Object System.Drawing.Point(5, 300);
    $lblWarning.ForeColor = [System.Drawing.Color]::Red;
    $form.Controls.Add($lblWarning);

    # Convert button
    $btnConvert = New-Object System.Windows.Forms.Button;
    $btnConvert.Text = "Convert!";
    $btnConvert.Location = New-Object System.Drawing.Point((($form.Size.Width-$btnConvert.Size.Width)/2), (($form.Size.Height - $btnConvert.Size.Height) - 50));
    $form.Controls.Add($btnConvert);

    $btnConvert.Add_Click({
        convProject -firstUse ($gui.firstTimeUsage) -wrapCmd ($gui.wrapCmd);
        saveProject($gui.projFileName);

        [System.Windows.Forms.MessageBox]::Show("Convertion successful.`nVerify that all components of your project are still working!") 
    });

    $form.ShowDialog() | Out-Null;
}

# Let's start!
initGui;