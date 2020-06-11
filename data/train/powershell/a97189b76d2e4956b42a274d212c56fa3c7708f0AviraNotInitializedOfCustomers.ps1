<# Avira Not Initialized Of Customers 
AUTOR: Mike Semlitsch
DATE: 07.06.2016
VERSION: V1.0
DESC: Creates an excel file with a report of all Avira Sensors with status "Still not initialized" for all customers
#>

param(
    [string]$apiKey
)

$subtypeOfAgent = "72AC0BFD-0B0C-450C-92EB-354334B4DAAB";


############################################
#Get Name Of File
############################################
function getNameOfFile($cId) {
    #$url = "https://api.server-eye.de/2/customer/$cId\?apiKey=$apiKey";
    $url = "https://api.server-eye.de/2/me?apiKey=$apiKey";

    $jsonResponse = (Invoke-RestMethod -Uri $url -Method Get);

    $date = Get-Date -format d;

    $retval = $jsonResponse.surname + " " + $jsonResponse.prename + " AviraNotInitializedOfCustomers " + $date + ".xlsx";

    $retval = $PSScriptRoot + "\" + $retval -replace '\s','_'
    
    return $retval;


}

############################################
#END Name Of File
############################################


############################################
#Get Visible Customers
############################################
function getVisibleCustomers() {
    $url = "https://api.server-eye.de/2/me/nodes?apiKey=$apiKey&filter=customer";

    $jsonResponse = (Invoke-RestMethod -Uri $url -Method Get);

    return $jsonResponse;


}

############################################
#END Get Visible Customers
############################################






############################################
#Get Containers Of Customer
############################################
function getContainersOfCustomer($cId) {
    $url = "https://api.server-eye.de/2/customer/$cId/containers?apiKey=$apiKey";

    $jsonResponse = (Invoke-RestMethod -Uri $url -Method Get);

    return $jsonResponse;


}

############################################
#END Get Containers Of Customer
############################################


############################################
#Get Agents Of Container
############################################
function getAgentsOfContainer($cId) {
    $url = "https://api.server-eye.de/2/container/$cId/agents?apiKey=$apiKey";

    $jsonResponse = (Invoke-RestMethod -Uri $url -Method Get);

    return $jsonResponse;


}

############################################
#END Get Agents Of Container
############################################





$global:isFirstSheet = $true;
$global:actRow = 2;



$excelFileName = getNameOfFile($customerId);


#OPEN Excel File
$SheetName1 = "Employee Accounts"
$ObjExcel = New-Object -ComObject Excel.Application
$Objexcel.Visible = $false
$Objworkbook=$ObjExcel.Workbooks.Add()
#$Objworkbook.Worksheets(1).Delete > $null;
#$Objworkbook.ActiveSheet.Name = $containerName;
$Objworkbook.ActiveSheet.Cells.Item(1,1) = "Kunde";
$Objworkbook.ActiveSheet.Cells.Item(1,2) = "OCC-Connector";
$Objworkbook.ActiveSheet.Cells.Item(1,3) = "Sensorhub";
$Objworkbook.ActiveSheet.Cells.Item(1,4) = "SensorName";
$Objworkbook.ActiveSheet.Cells.Item(1,5) = "Message";


$arrayCustomers = getVisibleCustomers;

:outer foreach($customer in $arrayCustomers)
{

    Write-Host "customer name: " $customer.name;

    $customerId = $customer.id;

    $arrayContainers = getContainersOfCustomer($customerId);

    :inner1 foreach($container in $arrayContainers)
    {

        #Write-Host "container ID: " $container.id " " $container.subtype;

        if ($container.subtype -eq "0") {
        #if ($false) {
            
            Write-Host "OCC-Connector: " $container.name ;

            #Write-Host "container ID: " $container.id; 
            #Write-Host "container Name: " $container.name;


            :inner2 foreach($sensorhub in $arrayContainers)
            {

                
                
                if ( $sensorhub.subtype -eq "2" -and $sensorhub.parentId -eq $container.id) {

                    Write-Host "   Sensorhub: " $sensorhub.name;

                    #getAgentsOfContainer($sensorhub.id);



                    $arrayAgents = getAgentsOfContainer($sensorhub.id);
                    #getAgentsOfContainer($container.id);

            
                    :inner3 foreach($agent in $arrayAgents)
                    {

                        #break inner3;
                
                        #Write-Host "agent subtype: " $agent.subtype;
                         
                        #showAgentState $agent.id $container.name;

                        if ($agent.subtype -like $subtypeOfAgent -and ( $agent.message.IndexOf("initial") -gt -1 -or $agent.message.IndexOf("Unhandled exception") -gt -1 ) ) {

                            Write-Host "      SensorName: " $agent.name;

                            Write-Host $agent.message;

                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,1) = $customer.name;
                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,2) = $container.name;
                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,3) = $sensorhub.name;
                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,4) = $agent.name;
                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,5) = $agent.message;

                            $global:actRow++;

                        }

                    #    break outer;
                    }

                }
            }



        
        }


    }

}

$Objworkbook.ActiveSheet.Cells.Select() > $null;
$Objworkbook.ActiveSheet.Cells.EntireColumn.AutoFit() > $null;
$Objworkbook.ActiveSheet.Cells.Item(1,1).Select() > $null;


#CLOSE/SAVE Excel File
$Objexcel.DisplayAlerts = $false
if ($global:actRow -gt 2) {
    $Objworkbook.SaveAs($excelFileName)
    $Objexcel.DisplayAlerts = $true

    
} else {
    
    Write-Host "##########################################################"
    Write-Host "No unitialized Avira-Sensor found. No Excel-File created."
    Write-Host "##########################################################"

}

$Objworkbook.Close()
$Objexcel.Quit()
[void][System.Runtime.Interopservices.Marshal]::FinalReleaseComObject($Objexcel)

exit;

#-And $sensorhub.parentId -eq $container.id

$tmp = "Still not initialized.";


Write-Host $tmp.IndexOf("initial") 

if ($tmp.IndexOf("initial") -gt -1) {
    Write-Host "gefunden"
}