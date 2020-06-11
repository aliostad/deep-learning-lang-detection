Import-Module ShowUI


function Out-LastNameFirstName
{
    param($firstName,$lastName)
    
    "$lastName, $firstName"
}

$in = New-UniformGrid  -Columns 2 -ControlName Get-FirstAndLastName -Children {
    'First Name'
    New-TextBox -Name FirstName
    'Last Name'
    New-TextBox -Name LastName
    ' ' 
    New-Button "OK" -IsDefault -On_Click {
        $parent | Set-UIValue -passThru | Close-Control    
    }
} -show

Out-LastNameFirstName @in
