<#
# Módulo com rotinas de interação com usuário 
#>

<#
.Synopsis
   Descrição resumida
.DESCRIPTION
   Descrição longa
    Value  Description   
    0 Show OK button. 
    1 Show OK and Cancel buttons. 
    2 Show Abort, Retry, and Ignore buttons. 
    3 Show Yes, No, and Cancel buttons. 
    4 Show Yes and No buttons. 
    5 Show Retry and Cancel buttons. 
#>
function Get-ChoiceYesNo
{
    [CmdletBinding()]
    [OutputType([boolean])]

    Param(
        # Descrição da ajuda de parâm1
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [String] $Prompt,
        # Descrição da ajuda de parâm2
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=1)]
        [String] $Caption
    )

    begin{
        if( -not $Global:ShellDialog ){
            $Global:ShellDialog = new-object -comobject wscript.shell 
        }
    }
    process{
        $intAnswer = $Global:ShellDialog.popup( $Prompt,0,$Caption,4)  ####!!!! Veja a maluquice com a liberação da instancia
        $ret = ($intAnswer -eq 6) #necessário salvar resultado antes da liberação
        return $ret
    }
}


Export-ModuleMember -Function Get-ChoiceYesNo