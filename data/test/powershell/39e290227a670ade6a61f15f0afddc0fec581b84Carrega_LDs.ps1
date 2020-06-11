<#	
	===========================================================================
	.Nome SCRIPT: Carrega_LDs.ps1
    .DESCRIÇÃO:Script para atualizar membros de Lista de Distribuição baseado em arquivo disponibilizado pelo RH.
    .PARAMETROS: <Nenhum>
    .Entradas(INPUTs):
     - Caminho do Script
     - Caminho Arquivo LD%%%%%%%.TXT disponibilizado pelo RH, obs no diretório deve haver apenas estes aquivos com extenção TXT.
     - Caminho do Arquivo de referencia entre Arquivo do RH e Lista de Distribuição a ser carregada.
     - Domain controllers Dominio Oi / Dominio Telemar
    .Saida (OUTPUTs):
     - Listas de distribuição populadas
     - Arquivo de Log gerado no caminho do Script com a data atual.
    .Notas:
     Versao: 1.0
     Criado em: 30/12/2014
	 Autor:Warley Penido Ferreira
     Email:warley.penido@oi.net.br
    ===========================================================================
#>

#---------------------------------------------------------[Initialisações / Declarações]------------------------------------------
#Confiura ação de erro para Silently Continue
$ErrorActionPreference = "SilentlyContinue"
#Coleta Data/Hora Inicial para calculo de execução do script
$InicioScriptTime=Get-Date
#Pega Data atual.
$data=Get-Date -format "yyyy.MM.dd"

#--Entrar com o Caminho do Script
$caminho="C:\warley\Rotina_LD_Exchange\"

#Arquivo de Log
$logfile=$caminho+"Carga_LDs_"+$data+".log"

#----------------------------------------------------------[Entradas <INPUTS>]----------------------------------------------------



#--Entrar com o caminho\nome do arquivo de registros ID / Nome
$RHFiles="C:\warley\Rotina_LD_Exchange\"

#--Entrar com caminho do arquivo de referencia entre arquivo do RH e Lista de Distribuição a ser carregada.
$FileLds = $caminho+"listas.csv"

#--Entrar com Domain controllers dominio Telemar / OI
$DC_Oi="DCMGPRD01"
$DC_TELEMAR="TNLDCMG01"

#-----------------------------------------------------------[Funções]------------------------------------------------------------
Function LogWrite
{
   Param ([string]$logstring)
   (Get-Date).ToString()+" "+$logstring | out-file $logfile -Append -Force
}


#-----------------------------------------------------------[Execução]------------------------------------------------------------

#Carrega referencia dos arquivos forneceidos pelo RH 
$FilesRead= Get-ChildItem $RHfiles LD*.TXT

$message="#################################################################################################################################################################"
$message | out-file $logfile -Append -Force
$message="#    Iniciando Script "+(Get-Date).ToString()
$message | out-file $logfile -Append -Force
$message="#################################################################################################################################################################"
$message | out-file $logfile -Append -Force


Foreach ($FileRead in $FilesRead)
{
    if ($fileRead -ne $null)
    {

        $message = "Lendo Arquivo Export RH:"+$RHFiles+$FileRead
        Logwrite $message

        #Entrar com o caminho\nome do CSV de Arquivo vs LDs
        
        $message = "Caminho do arquivo que identifica (Arquivo Export RH vs Lista de Distribuição): " + $FileLds
        Logwrite $message

        $message = "Domain Controler Dominio OI: "+$DC_Oi
        Logwrite $message

        $message = "Domain Controler Dominio TELEMAR: "+$DC_TELEMAR
        Logwrite $message

        #Carrega conteudo do arquivo na variavel $Regs separando por ";" e criando atributos
        $regs=gc $RHFiles$fileread | select @{N="ID"; E={($_ -split ";")[0]}},@{N="Name"; E={($_ -split ";")[1]}}

        #Carrega conteudo do arquivo na variavel $arq_ld separando por ";" e criando atributos
        $Arq_LD=gc $RHFiles"listas.csv" | select @{N="Arq"; E={($_ -split ";")[0]}},@{N="LD"; E={($_ -split ";")[1]}}

        #pega o nome do arquivo que esta na primeira linha do registro para variável 
        $arq=$regs.id[0]

        #Pega o nome da Lista de Distribuição de acordo com registro do arquivo Lista.csv
        $Conta=0
        foreach ($lds in $Arq_LD)
        {
            if ($arq -match $lds.Arq)
            {     
                $LD=$lds.LD
            }
        $conta++
        }

        $message="Lista de Distribuição: "+$LD
        Logwrite $message               
                
        #Limpa Membros do Grupo do dominio Telemar
        $grupo=Get-ADGroup -filter {name -eq $LD} -server $DC_TELEMAR
        
        if($grupo -ne $null)
        {
            $members=Get-ADGroupMember -Identity $grupo.SamAccountName -server $DC_TELEMAR
        }

        if (($members -ne $null)-and($grupo -ne $null))
        {
            $message="Removendo membros do grupo: "+$grupo.samaccountname +" Dominio Telemar" 
            Logwrite $message
            Remove-ADGroupMember -Identity $grupo.samaccountname -Members $members -server $DC_TELEMAR -Confirm:$false

        }

        #Limpa Membros do Grupo do dominio Oi
        $grupo=Get-ADGroup -filter {name -eq $LD} -server $DC_Oi
        
        if($grupo -ne $null)
        {
            $members=Get-ADGroupMember -Identity $grupo.SamAccountName -server $DC_Oi
        }

        if (($members -ne $null)-and($grupo -ne $null))
        {
            $message="Removendo membros do grupo: "+$grupo.samaccountname +" Dominio Oi" 
            Logwrite $message
            Remove-ADGroupMember -Identity $grupo.samaccountname -Members $members -server $DC_Oi -Confirm:$false
        }

        #Localiza usuário no AD e adiciona o usuário a LD identificada.
        
        $message="Identificando usuários e populando os Grupos:"
        Logwrite $message

        $message="Número de Usuários carregados do arquivo: "+ $regs.count
        Logwrite $message
        
        $Conta=1
        foreach ($reg in $regs)
        {
             $r=[System.Math]::Abs($regs.ID[$conta]).ToString()
             #Consulta usuário no Dominio Telemar
         
             $message= "Registro lido do arquivo "+$Arq+" - "+$Reg.ID+";"+$reg.Name
             Logwrite $message

             #Consulta ID existente no atributo extensionattribute11
             $users=Get-ADUser -Filter {extensionattribute11 -eq $r} -server $DC_TELEMAR
             

             if ($users -ne $null)
             {
                
                    Get-ADGroup -filter {name -eq $LD} -server $DC_TELEMAR | add-ADGroupMember -members $users -server $DC_TELEMAR
                    $message="Dominio:TELEMAR;Usuário: "+$users+"--> LD: "+$LD
                    Logwrite $message
             }

             #Consulta usuário no Dominio OI
             #Consulta ID existente no atributo extensionattribute11
             $users=Get-ADUser -Filter {extensionattribute11 -eq $r} -server $DC_Oi
             if ($users -ne $null)
             {
                    Get-ADGroup -filter {name -eq $LD} -server $DC_Oi | add-ADGroupMember -members $users -server $DC_Oi
                    $message="Dominio:Oi;Usuário: "+$users+"--> LD: "+$LD
                    Logwrite $message
             }
            $conta++
        }
    }
    Else
    {
                $message="Não foram identificados os arquivos forncidos pelo RH no caminho:"+$RHFiles
                Logwrite $message
    }

$message="#################################################################################################################################################################"
$message | out-file $logfile -Append -Force

}
$FimScriptTime = Get-date
$message="# - Fim da Execução do Script - "+(Get-Date).ToString()+" - Tempo de execução: "+ (($Fimscripttime-$InicioScriptTime).tostring())+" -###############################################################################################"
$message | out-file $logfile -Append -Force
