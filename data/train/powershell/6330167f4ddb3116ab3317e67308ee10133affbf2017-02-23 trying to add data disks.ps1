Login-AzureRmAccount -SubscriptionName "VSE MPN"

$VM = get-azurermvm -ResourceGroupName "DevAPI_Test" -Name "DevApi"

$H = New-Object hashtable
$H."VmName" = "DevApi"
$H."VhdUri.BlobPath" = "vhds/" + $H.'VmName' + "DataDisk1.vhd"
$H."RgName" = "DevApi_Test"
$H."Storage.Name" = $H.VmName + "testdatastorage"
$H."Storage.Name" = $H.'Storage.Name'.tolower()

$DataStorage = Get-AzureRmStorageAccount -ResourceGroupName $H.'RgName' -Name $H.'Storage.Name'

$H."VhdUri.Name" = $H.VmName + "DataDisk2"
$H."VhdUri" = $DataStorage.PrimaryEndpoints.Blob.ToString() + $H.'VhdUri.BlobPath'
Add-AzureRmVMDataDisk -VM $VM -Name $H.'VhdUri.Name' -VhdUri $H.VhdUri -CreateOption Empty -DiskSizeInGB 10 -Lun 1 -Caching None
Update-AzureRmVM -VM $vm -ResourceGroupName $H.RgName
# the above worked, but I had lun and cashing parameters set, where previous attempts didn't have those set.

