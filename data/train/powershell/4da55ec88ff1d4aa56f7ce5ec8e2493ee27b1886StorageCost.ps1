function Get-StorageCostDollarPerTeraBytePerYear {
    param(
        $Dollars,
        $TeraBytes,
        $Years
    )
    $Dollars / $TeraBytes / $Years
}

$PrimaryStorageSANCost = 130000
$PrimaryStorageSANUsableCapacityInTB = 40
$PrimaryStorageSANYearsOfMaintenanceWithInitialPurchase = 4
$PrimaryStorageSANMaintenanceCostPerYear = $PrimaryStorageSANCost * .2
$PrimaryStorageSANMaximumYearsOfUsefulLife = 7

$BackupStorageSANCost = 55000
$BackupStorageSANCapacityOfUsableStorageItCanHoldInTB = 250
$BackupStorageSANsYearsOfMaintenanceWithInitialPurchase = 4
$BackupStorageSANsMaintenanceCost = $BackupStorageSANCost * .2
$BackupStorageSANsMaximumYearsOfUsefulLife = 7

$BackupStorageSoftwareCost = 10000
$BackupStorageSoftwareUsableTBItCanManage = 250
$BackupStorageSoftwareYearsOfMaintenanceWithInitialPurchase = 1
$BackupStorageSoftwareMaintenanceCostPerYear = $BackupStorageSoftwareCost * .2

$StorageUsageRateInTBPerDay = .1/1

$FTESalaryPerYearToManageStorage = 80000
$TBOfUsableStorageThatCanBeMangedByFTEInAYear = 500

$PrimaryStoargeCostPerTBPerYear = Get-StorageCostDollarPerTeraBytePerYear -Dollars $PrimaryStorageSANCost -TeraBytes $PrimaryStorageSANUsableCapacityInTB -Years $PrimaryStorageSANYearsOfMaintenanceWithInitialPurchase
$PrimaryStoargeMaintenanceCostPerTBPerYear = Get-StorageCostDollarPerTeraBytePerYear -Dollars $PrimaryStorageSANMaintenanceCostPerYear -TeraBytes $PrimaryStorageSANUsableCapacityInTB -Years 1
$BackupStorageCostPerTBPerYear = Get-StorageCostDollarPerTeraBytePerYear -Dollars $BackupStorageSANCost -TeraBytes $BackupStorageSANCapacityOfUsableStorageItCanHoldInTB -Years $BackupStorageSANsYearsOfMaintenanceWithInitialPurchase
$BackupStorageMaintenanceCostPerTBPerYear = Get-StorageCostDollarPerTeraBytePerYear -Dollars $BackupStorageSANsMaintenanceCost -TeraBytes $BackupStorageSANCapacityOfUsableStorageItCanHoldInTB -Years 1
$BackupStorageSoftwareCostPerTBPerYear = Get-StorageCostDollarPerTeraBytePerYear -Dollars $BackupStorageSoftwareCost -TeraBytes $BackupStorageSoftwareUsableTBItCanManage -Years $BackupStorageSoftwareYearsOfMaintenanceWithInitialPurchase
$BackupStorageSoftwareMaintenanceCostPerTBPerYear = Get-StorageCostDollarPerTeraBytePerYear -Dollars $BackupStorageSoftwareMaintenanceCostPerYear -TeraBytes $BackupStorageSoftwareUsableTBItCanManage -Years 1
$FTEToManageStorageCostPerTBPerYear = Get-StorageCostDollarPerTeraBytePerYear -Dollars $FTESalaryPerYearToManageStorage -TeraBytes $TBOfUsableStorageThatCanBeMangedByFTEInAYear -Years 1

$PrimaryStorageTotalCostFor7Years = ($PrimaryStoargeCostPerTBPerYear * $PrimaryStorageSANYearsOfMaintenanceWithInitialPurchase) + ($PrimaryStoargeMaintenanceCostPerTBPerYear * ($PrimaryStorageSANMaximumYearsOfUsefulLife - $PrimaryStorageSANYearsOfMaintenanceWithInitialPurchase))
$BackupStorageTotalCostFor7Years = ($BackupStorageCostPerTBPerYear * $BackupStorageSANsYearsOfMaintenanceWithInitialPurchase) + ($BackupStorageMaintenanceCostPerTBPerYear * ($BackupStorageSANsMaximumYearsOfUsefulLife - $BackupStorageSANsYearsOfMaintenanceWithInitialPurchase))
$BackupSoftwareTotalCostFor7Years = $BackupStorageSoftwareCostPerTBPerYear * $BackupStorageSoftwareYearsOfMaintenanceWithInitialPurchase + $BackupStorageSoftwareMaintenanceCostPerTBPerYear * 6
$FTEToManageStorageCostPer7Years = $FTEToManageStorageCostPerTBPerYear * 7

$TotalStorageCostPerTBPerYear = ($PrimaryStorageTotalCostFor7Years + ($BackupStorageTotalCostFor7Years + $BackupSoftwareTotalCostFor7Years) * 2 + $FTEToManageStorageCostPer7Years) / 7
$TotalStorageCostPerTBPerYear


#Below is an additional experiment on showing our actual cash flow over time for storage

#$FTEToManageStorageCostPerTBPerYear * 1.33

<#
foreach ($Days in 1..10000) {
    $UsedStorageInTB = $Days * $StorageUsageRateInTBPerDay
    if($UsedStorageInTB -eq 1) {
        $TotalCost += $PrimaryStorageSANCostPer40TBOfUsableSpace
        $TotalCost += $BackupStorageSANsCostPer250TBOfUsableSpace
        $TotalCost += $BackupStorageSoftwareCostPer250TBOfUsableSpace
    }
    
    $WeHaveUsedAnother40TBOfStorage = $UsedStorageInTB % 40 -eq 0
    if($WeHaveUsedAnother40TBOfStorage) {
        $TotalCost += $PrimaryStorageSANCostPer40TBOfUsableSpace
    }
    
    $WeHaveUsedAnother250TBOfStorage = $UsedStorageInTB % 250 -eq 0
    if($WeHaveUsedAnother250TBOfStorage) {
        $TotalCost += $BackupStorageSANsCostPer250TBOfUsableSpace
        $TotalCost += $BackupStorageSoftwareCostPer250TBOfUsableSpace
    }

}
#>