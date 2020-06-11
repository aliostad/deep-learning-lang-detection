#This script creates a new Azure HDInsight cluster.
#You will need to supply basic information for creating a cluster by setting values for variables below.

#Subscription name was set when you created your Windows Azure subscription.
#If you don't know your subscription name, you can find it by logging into the Azure Portal: http://manage.windowsazure.com .
$SubscriptionName = "your_subscription_name"

#The name of your HDinsight cluster.
$ClusterName = "your_cluster_name"

#The location of your HDInsight cluster.
#This should be in the same location as the storage account for the cluster.
$Location = "desired_cluster_location" #e.g. "West US", "East US", "North Europe"

#The default storage account for the cluster.
#This assumes you have already created the account.
$StorageAccount = "your_storage_account"

#The default container within your storage account.
#This assumes you have already created the container.
$Container = "default_storage_container"

#The number of data nodes in the cluster.
$ClusterSize = 4

#Create the cluster.
Set-AzureSubscription -SubscriptionName $SubscriptionName -CurrentStorageAccount $StorageAccount
$SubscriptionId = (Get-AzureSubscription –Current).SubscriptionId
$Credentials = Get-Credential
$FullStorageAccountName = (Get-AzureSubscription -Default).CurrentStorageAccount.ToString() + ".blob.core.windows.net"
$StorageKey = (Get-AzureStorageKey (Get-AzureSubscription -default).CurrentStorageAccount).Primary

New-AzureHDInsightCluster -Subscription $SubscriptionId -Name $ClusterName -Location $Location `
	-DefaultStorageAccountName $FullStorageAccountName -DefaultStorageAccountKey $StorageKey `
	-DefaultStorageContainerName $Container -Credential $Credentials -ClusterSizeInNodes $ClusterSize
