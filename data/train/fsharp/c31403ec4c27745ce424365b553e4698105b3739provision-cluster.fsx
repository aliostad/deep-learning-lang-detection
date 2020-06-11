#load "../config.fsx"
#load "../lib/utils.fsx"
#load "../lib/dashboard.fsx"
//#load "../lib/thespian.fsx"

open MBrace.Azure
open MBrace.Azure.Management
open Dashboard

(**

From Async to Cloud (Progressive F# Tutorials 2015 London)
==========================================================

# Chapter 0: Provisioning an MBrace cluster on Azure

In this tutorial you will learn how you can deploy an MBrace cluster using Azure.
Follow the instructions and complete the assignments described below.
Once done, you should have succesfully connected to your very own MBrace cluster running in the cloud!


/////////////////////////////////////////
// Section 1: Create a Microsoft account

In order to work with Azure, you will need to have access to a microsoft account.
If you already have an account available, you can ignore this task.
If not, visit https://login.live.com/ and *sign up* for a free account.

////////////////////////////////
// Section 2: Sign up for Azure

You are now ready to sign up for an Azure subscription.
Microsoft offers a free trial to every new user.
You can claim yours by visiting https://azure.microsoft.com/en-us/pricing/free-trial/.
For more detailed instructions, be sure to watch @shanselman's tutorial at 
https://azure.microsoft.com/en-in/documentation/videos/sign-up-for-microsoft-azure/

If for whatever reason you are unable to obtain an azure subscription of your own,
please contact any of the speakers, so they can provision an mbrace cluster for you.


////////////////////////////////////////////////////////
// Section 3: Obtaining your Azure PublishSettings file

Now that you have successfully created your own Azure subscription,
you can proceed with downloading the publication settings file
associated with your account. This contains a set of authentication tokens
for your Azure subscriptions.

WARNING: Be very private with your publish settings file!
It can be used to authorize deployments that may affect your Azure bill.

Your publish settings file can be obtained by visiting the following url:

https://manage.windowsazure.com/publishsettings

Once download is complete, place your the path to your locally downloaded
publish settings files in the following assignment:

*)

let pubSettingsPath : string = __IMPLEMENT_ME__

(**

If your publication settings defines more than one subscription,
you will need to specify which one you will be using here.

*)

let subscriptionId : string option = __IMPLEMENT_ME__

(**

/////////////////////////////////////////////////
// Section 4: Choosing a cluster name and region

Let's now choose a name for your cluster.
Your cluster name must be unique to azure and be a valid DNS prefix name.
Valid name examples include 'eirikcluster', 'isaacmbrace2' and 'mbracedon42'

*)

let clusterName : string = __IMPLEMENT_ME__

(*

Let's now choose a geographical region for our cluster.
We usually want to select something that's close to our vicinity.
The recommended region for this tutorial is North Europe (Netherlands).

*)

let region : Region = __IMPLEMENT_ME__

(*

Choose the desired VM size and number of VMs.
For this tutorial, let's create a cluster of 4 VMs of size 'A3' (quad core, 7GB RAM).

*)

let vmSize : VMSize = __IMPLEMENT_ME__
let vmCount : int = __IMPLEMENT_ME__

(**

Finally, let's make sure that our preferences are stored in 'config.fsx' for future use.

*)

Config.UpdateConfig(pubSettingsPath, subscriptionId, clusterName, region, vmSize, vmCount)

(*

///////////////////////////////////////
// Section 5: Provisioning our cluster

We are now ready to start provisioning our cluster.
First, let's reload 'config.fsx' with our updated preferences.

*)

#load "../config.fsx"

(**

Let's begin the provisioning operation.

*)

let deployment = Config.ProvisionCluster()

(*

If the operation was successful, a 'deployment' handle will be received.
Provisioning has not completed just yet, it should take ~5 minutes until our cluster is up and running.
Let's track the provisioning progress by loading a dashboard.

*)

deployment.OpenDashboard()

(*

////////////////////////////////////////////////////
// Section 6: Connecting to our provisioned cluster

Once provisioning has completed, we can proceed connecting to our MBrace cluster.

*)

let cluster = Config.GetCluster()

(*

Let's verify that it's properly populated by viewing its listed workers.

*)

cluster.ShowWorkers()

(*

We can also open a dashboard that displays information on the cluster.

*)

cluster.OpenDashboard()


(* YOU HANE NOW COMPLETED CHAPTER 0 *)