(*** hide ***)
// This block of code is omitted in the generated HTML documentation. Use 
// it to define helpers that you do not want to show in the documentation.
#load "../../packages/MBrace.Azure/MBrace.Azure.fsx"
#r "../../packages/MBrace.Flow/lib/net45/MBrace.Flow.dll"


//let config = Unchecked.defaultof<MBrace.Azure.Configuration>

open MBrace.Azure

(**

# Using MBrace on Azure 

1. [Create an Azure account](https://azure.microsoft.com) and [download your publication settings file ](https://manage.windowsazure.com/publishsettings).

2. [Download or clone the starter pack](https://github.com/mbraceproject/MBrace.StarterKit/blob/master/mbrace-versions.md).

3. Build the solution to get the required packages 

4. Open the ``HandsOnTutorial/AzureCluster.fsx`` script. Insert the path to your publication settings file and edit any other Azure settings as required.
  
5. Open the ``HandsOnTutorial/0-provision-azure-cluster.fsx`` script and follow the instruction up to the line

        let deployment = Config.ProvisionCluster()
 
   Diagnostics will be shown.  When created your cluster will now appear as a cloud service in the [Azure management portal](https://manage.windowsazure.com).
   If you have any trouble, [report an issue on github](https://github.com/mbraceproject/MBrace.Azure/issues).

5. Open the first tutorial script in the starter pack 
   hands-on tutorial (or read [the online version](starterkit/HandsOnTutorial.FSharp/1-hello-world.html)). The scripts follow the tutorials in the
   [Core Programming Model](http://www.mbrace.io/programming-model.html).


### How your MBrace code runs on Azure

Your MBrace code has two parts: a client and a cluster. The cluster runs as an Azure Cloud Service with associated
storage and queue assets. You can [manage your cluster on the Azure management portal](https://manage.windowsazure.com/).

Typically your MBrace client will run in:

* an F# interactive instance in your editor; or

* as part of another cloud service, website or web job; or

* as a client desktop process.

In all cases, the client will need sufficient network access to be able to write to the
Azure storage and Service Bus accounts used by the MBrace runtime/cluster nodes.

When your client submits jobs using ``cluster.CreateProcess`` or ``cluster.Run``, parts of 
your client code will be transported to the cluster and executed
there. MBrace looks after the transport of code and data using Vagabond.

Take care that the base architectures on client and cluster are compatible, e.g. both are 64-bit.

### Using your Azure cluster from compiled code

To use your Azure cluster from compiled projects (rather than scripts),
add a reference to the ``MBrace.Azure`` package and use the 
following code. The configuration strings can be found by the
Azure management console or the ``GetDeployment().Configuration`` in
an MBrace data script.

*)

let myStorageConnectionString = "..."
let myServiceBusConnectionString = "..."
let config = Configuration(myStorageConnectionString, myServiceBusConnectionString)
let cluster = AzureCluster.Connect(config, 
                                   logger = ConsoleLogger(true), 
                                   logLevel = LogLevel.Info)


