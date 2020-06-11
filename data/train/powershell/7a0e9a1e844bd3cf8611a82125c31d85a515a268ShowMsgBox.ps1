#requires -Version 2
<#
    .SYNOPSIS
        Shows a graphical message box, with various prompt types available.

    .DESCRIPTION
        Emulates the Visual Basic MsgBox function.  It takes four parameters, of which only the prompt is mandatory

    .INPUTS
        The parameters are:-

        Prompt (mandatory):
        Text string that you wish to display

        Title (optional):
        The title that appears on the message box

        Icon (optional).  Available options are:
        Information, Question, Critical, Exclamation (not case sensitive)

        BoxType (optional). Available options are:
        OKOnly, OkCancel, AbortRetryIgnore, YesNoCancel, YesNo, RetryCancel (not case sensitive)

        DefaultButton (optional). Available options are:
        1, 2, 3

    .OUTPUTS
        Microsoft.VisualBasic.MsgBoxResult

    .EXAMPLE
        C:\PS> Show-MsgBox Hello
        Shows a popup message with the text "Hello", and the default box, icon and defaultbutton settings.

    .EXAMPLE
        C:\PS> Show-MsgBox -Prompt "This is the prompt" -Title "This Is The Title" -Icon Critical -BoxType YesNo -DefaultButton 2
        Shows a popup with the parameter as supplied.

    .LINK
        http://gallery.technet.microsoft.com/scriptcenter/Powershell-Show-MsgBox-982f6906

    .LINK
        http://msdn.microsoft.com/en-us/library/microsoft.visualbasic.msgboxresult.aspx

    .LINK
        http://msdn.microsoft.com/en-us/library/microsoft.visualbasic.msgboxstyle.aspx
    .NOTES
        By BigTeddy August 24, 2011
        http://social.technet.microsoft.com/profile/bigteddy/.
#>

Write-Verbose -Message 'Declaring function Show-MsgBox'
function Show-MsgBox
{
    <#
        .SYNOPSIS
                Shows a graphical message box, with various prompt types available.
        .DESCRIPTION
                Emulates the Visual Basic MsgBox function.  It takes four parameters, of which only the prompt is mandatory

        .PARAMETER Message
            Text string that you wish to display in the message (dialog) box windows

        .PARAMETER Title
            The title that appears on the message box

        .PARAMETER Icon
            Available options are:
            Information, Question, Critical, Exclamation (not case sensitive)

        .PARAMETER BoxType
            Available options are:
            OKOnly, OkCancel, AbortRetryIgnore, YesNoCancel, YesNo, RetryCancel (not case sensitive)

            DefaultButton (optional). Available options are:
            1, 2, 3

        .EXAMPLE
            .\PS> Show-MsgBox Hello
            Shows a popup message with the text "Hello", and the default box, icon and defaultbutton settings.

        .EXAMPLE
            .\PS> Show-MsgBox -Message "This is the Message" -Title "This Is The Title" -Icon Critical -BoxType YesNo -DefaultButton 2
            Shows a popup with the parameter as supplied.
        .NOTES
            NAME        :  Show-MsgBox
            CREATED     :  August 24, 2011
            AUTHOR      :  BigTeddy (http://social.technet.microsoft.com/profile/bigteddy/)
            VERSION     :  1.1.0
            LAST UPDATED:  12/3/2015
            BY (EDITOR) :  Bryan Dady (@bcdady)
        .LINK
            http://gallery.technet.microsoft.com/scriptcenter/Powershell-Show-MsgBox-982f6906
            http://msdn.microsoft.com/en-us/library/microsoft.visualbasic.msgboxresult.aspx
            http://msdn.microsoft.com/en-us/library/microsoft.visualbasic.msgboxstyle.aspx
            http://social.technet.microsoft.com/profile/bigteddy/.
        .INPUTS
        INPUTS
        .OUTPUTS
        OUTPUTS
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)] [string]$Message,
        [Parameter(Position = 1, Mandatory = $false)] [string]$Title = '',
        [Parameter(Position = 2, Mandatory = $false)] [ValidateSet('Information', 'Question', 'Critical', 'Exclamation')] [string]$Icon = 'Information',
        [Parameter(Position = 3, Mandatory = $false)] [ValidateSet('OKOnly', 'OKCancel', 'AbortRetryIgnore', 'YesNoCancel', 'YesNo', 'RetryCancel')] [string]$BoxType = 'OkOnly',
        [Parameter(Position = 4, Mandatory = $false)] [ValidateSet(1,2,3)] [int]$DefaultButton = 1
    )
    $null = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    switch ($Icon) {
        'Question'
        {
            $vb_icon = [microsoft.visualbasic.msgboxstyle]::Question
        }
        'Critical'
        {
            $vb_icon = [microsoft.visualbasic.msgboxstyle]::Critical
        }
        'Exclamation'
        {
            $vb_icon = [microsoft.visualbasic.msgboxstyle]::Exclamation
        }
        'Information'
        {
            $vb_icon = [microsoft.visualbasic.msgboxstyle]::Information
        }
    }
    switch ($BoxType) {
        'OKOnly'
        {
            $vb_box = [microsoft.visualbasic.msgboxstyle]::OKOnly
        }
        'OKCancel'
        {
            $vb_box = [microsoft.visualbasic.msgboxstyle]::OkCancel
        }
        'AbortRetryIgnore'
        {
            $vb_box = [microsoft.visualbasic.msgboxstyle]::AbortRetryIgnore
        }
        'YesNoCancel'
        {
            $vb_box = [microsoft.visualbasic.msgboxstyle]::YesNoCancel
        }
        'YesNo'
        {
            $vb_box = [microsoft.visualbasic.msgboxstyle]::YesNo
        }
        'RetryCancel'
        {
            $vb_box = [microsoft.visualbasic.msgboxstyle]::RetryCancel
        }
    }
    switch ($DefaultButton) {
        1
        {
            $vb_defaultbutton = [microsoft.visualbasic.msgboxstyle]::DefaultButton1
        }
        2
        {
            $vb_defaultbutton = [microsoft.visualbasic.msgboxstyle]::DefaultButton2
        }
        3
        {
            $vb_defaultbutton = [microsoft.visualbasic.msgboxstyle]::DefaultButton3
        }
    }
    $popuptype = $vb_icon -bor $vb_box -bor $vb_defaultbutton
    $ans = [Microsoft.VisualBasic.Interaction]::MsgBox($Message,$popuptype,$Title)
    return $ans

} #end function