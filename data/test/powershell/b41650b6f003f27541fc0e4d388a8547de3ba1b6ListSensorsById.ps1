<# List All Sensors By SensorID 
AUTOR: Mike Semlitsch
DATE: 07.10.2016
VERSION: V1.0
DESC: Creates an excel file with a report of all sensors specified by the sensorID. The script iterates over all customers and sensorhubs to create the list.
#>

param(
    [string]$apiKey,
    [string]$subtypeOfAgent
)

#$subtypeOfAgent = "72AC0BFD-0B0C-450C-92EB-354334B4DAAB";


############################################
#Get Name Of File
############################################
function getNameOfFile($cId) {
    #$url = "https://api.server-eye.de/2/customer/$cId\?apiKey=$apiKey";
    $url = "https://api.server-eye.de/2/me?apiKey=$apiKey";

    $jsonResponse = (Invoke-RestMethod -Uri $url -Method Get);

    $date = Get-Date -format d;

    #Write-Host "  inner: " $global:nameOfAgent;



    $retval = $jsonResponse.surname + " " + $jsonResponse.prename + " All_ " + $global:nameOfAgent + " _Sensors_ " + $date + ".xlsx";

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



$arrayCustomers = getVisibleCustomers;

$global:nameOfAgent = "";


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

                        if ($agent.subtype -like $subtypeOfAgent ) {

                            Write-Host "      SensorName: " $agent.name;

                            $global:nameOfAgent = $agent.name;

                            #Write-Host $agent.message;

                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,1) = $customer.name;
                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,2) = $container.name;
                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,3) = $sensorhub.name;
                            $Objworkbook.ActiveSheet.Cells.Item($global:actRow,4) = $agent.name;
 

                            $global:actRow++;

                        }

                    #    break outer;
                    }

                }
            }



        
        }


    }

}

#Write-Host "  cccc: " $global:nameOfAgent;



$Objworkbook.ActiveSheet.Cells.Select() > $null;
$Objworkbook.ActiveSheet.Cells.EntireColumn.AutoFit() > $null;
$Objworkbook.ActiveSheet.Cells.Item(1,1).Select() > $null;

$excelFileName = getNameOfFile($customerId);


#CLOSE/SAVE Excel File
$Objexcel.DisplayAlerts = $false
if ($global:actRow -gt 2) {
    $Objworkbook.SaveAs($excelFileName)
    $Objexcel.DisplayAlerts = $true

    
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