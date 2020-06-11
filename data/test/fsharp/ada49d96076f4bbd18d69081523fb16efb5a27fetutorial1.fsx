(*** hide ***)
// This block of code is omitted in the generated HTML documentation. Use 
// it to define helpers that you do not want to show in the documentation.
#I "../../bin/Azure.Batch.Toolkit"

(**
Tutorial 1: Using the DSL
========================

The purpose of this tutorial is to use the Toolkit DSL to define a very simple workload and submit it.

When you are done, you should have:

1. An understanding of the basic object model of workloads
1. An understanding of some operations that are supported by the toolkit
1. An experience of having interacted with the Batch Service and submitted your first workload

Remember, you should have run the [Getting Set Up](tutorial0.html) tutorial first!
*)

(**
#### Reference and Namespace

The first thing to do is to reference the toolkit. _Note that it is packaged in **Batch.Toolkit.dll**_

The next thing is to open the namespace. _Note that this is **Batch.Toolkit**_

The DSL is found in the 
*)
#r "Batch.Toolkit.dll"
open Batch.Toolkit
open Batch.Toolkit.DSL

(**
#### Object Model: Command

A ``Command`` is the basic unit of execution. This is typically the name of your executable file or batch script.

The object model defined in the toolkit has two kinds of commands: 

* A ``SimpleCommand`` is just a string with the command line of the executable you want to run. You can have spaces and static arguments passed to the executable name as part of a simple command
* A ``ParametrizedCommand`` pairs a command line _template_ with a collection of parameter names, which can be replaced by the toolkit with a range of values. Surround the parameter name with ``%`` in the command line to identify it as a placeholder.

The following ``let`` creates an instance of a ``ParametrizedCommand`` through the DSL shortcut ``:parametric_cmd``.
*)

let helloUserCommand = ``:parametric_cmd`` "echo 'Hello %user%'" ``:with_params`` ["user"]

(**
*Note that the double backticks around ``:parametric_cmd`` - and around all the DSL keywords - are required.*

As you probably imagine, this command will eventually be expressed as a different command-line for each value that we might bind to ``user``.

#### Object Model: WorkloadUnitTemplate

We can compose commands into more complex objects in the toolkit, but the one that is ultimately useful for us is the ``WorkloadUnitTemplate`` object.

For now, let's skip discussing the intermediate objects and build one from our command using the ``:unit_template`` "keyword" from the DSL.
*)

let workloadUnitTemplate = 
    ``:unit_template`` 
        ``:admin`` false 
        ``:main`` 
            [
                ``:do`` helloUserCommand
            ] 
        ``:finally``
            []
        ``:files`` 
            []

(**
The key components of the ``:unit_template`` are:

1. The ``:admin`` flag: This specifies if the commands in the template require administrative privileges to run.
1. The ``:main`` block: This is a list of ``Command``s which are composed together to run. We only have one here, which says that we want to ``:do`` the ``helloUserCommand`` specified earlier without any error handling.
1. The ``:finally`` block: This is a list of ``Command``s which we require to be run at the end of the main block. We won't need to run anything here for this simple workload.
1. The ``:files`` block: This is a list of ``FileInfo`` objects representing files we want to upload in order to run the workload successfully. We don't need any files for this simple workload.

#### Object Model: Workload

Now, let's specify a ``Workload``, which will represent a Batch Job. We can do this by using the ``:workload`` DSL command.
*)

let workload =
    ``:workload``
        ``:unit_templates`` 
            [
                workloadUnitTemplate 
            ]
        ``:files`` 
            []
        ``:arguments`` 
            [
                ``:range`` "user" ``:over`` ["John"; "Ivan"; "Pablo"]
            ]

(**
A ``:workload`` is associated with the following:

1. A ``:unit_templates`` block: This is a collection of ``WorkloadUnitTemplate``s associated with this ``Workload``. Our example uses the single template we defined earlier.
1. A ``:files`` block: This is a list of ``FileInfo`` objects which represents the files common to all the instances of all the ``WorkloadUnitTemplate``s in this workload.
1. An ``:arguments`` block: This is a collection of named ``:range``s, which specify the set of values for each parameter.

A new instance of each ``WorkloadUnitTemplate`` is created and bound to each unique set of arguments, and these instances form the Tasks in our Batch Job. 

In this example, the ``Workload`` will be expressed into a single Batch Job with three tasks: one for each value of ``user`` specified in the ``:range``.

Now we are done with the definition, and all we need to do is to run the workload on the Batch Service.

#### Object Model : Configuration Objects

Interacting with the Batch service requires us to pass some credentials to in order to obtain a set of correctly configured context objects against which we can operate.

The toolkit has defined a few configuration objects (and helper methods to read these objects in from JSON files) so we can easily write applications and manage the credentials sensibly.

* BatchConfiguration
*)
type BatchConfiguration = {
    BatchAccountName : string
    BatchAccountKey  : string
    BatchAccountRegion : string
    BatchServiceUri : string
}

(**

* StorageConfiguration
*)
type StorageConfiguration = {
    StorageAccountName : string
    StorageAccountKey  : string
    StagingContainerName : string
}

(**

There is also a helper function ``readConfig<'a>`` which can construct an ``'a`` from an appropriately written JSON file. 
We can now build these objects from our JSON files like so:

*)
let (batchConfig, storageConfig) = 
    succeed {        
        let! batchConfig = readConfig<BatchConfiguration>("batch-config.json")
        let! storageConfig = readConfig<StorageConfiguration>("storage-config.json")
        return (batchConfig, storageConfig)
    } |> getOrThrow

(**
#### Object Model : Pool Object

Azure Batch is remarkable in its approach to providing a Batch execution context in that it separates the concern of Resource Allocation from the concern of Job Management. We have focussed in this sample on defining the Job in a user-centric way, but in order to run the job, we require a Pool.

Azure Batch allows us to specify an automatic pool, or to re-use a named pool. In our example, we'll use a named pool and the Toolkit infrastructure will create one for us if it doesn't exist already.

*)
let pool = NamedPool { NamedPoolName = PoolName "sample-pool"; NamedPoolSpecification = PoolOperations.GetDefaultPoolSpecification }        

(**

Now we can run the workload we've created, and the task representing the ``helloUserCommand`` for each respective user will be executed on a virtual machine managed by the pool.
*)
workload |> WorkloadOperations.RunWorkloadOnPool batchConfig storageConfig pool

(**
#### Finishing touches 

We can, in fact, make a utility function to run *any* workload against our configuration files, and re-use that for all our samples:

*)

module SampleCommon =
    open Batch.Toolkit.PoolOperations
    open Batch.Toolkit.WorkloadOperations
    let runSampleWorkload workload = 
        let pool = NamedPool { NamedPoolName = PoolName "sample-pool"; NamedPoolSpecification = GetDefaultPoolSpecification }        
        let (batchConfig, storageConfig) = 
            succeed {        
                let! batchConfig = readConfig<BatchConfiguration>("batch-config.json")
                let! storageConfig = readConfig<StorageConfiguration>("storage-config.json")
                return (batchConfig, storageConfig)
            } |> getOrThrow

        workload |> RunWorkloadOnPool batchConfig storageConfig pool

(** 
#### The whole enchilada

Using this utility function, we can focus *purely* on defining our workload in our main sample. 

The whole sample looks like this:
*)
module Sample1 =
    let helloUserCommand = 
        ``:parametric_cmd`` "echo 'Hello %user%'" ``:with_params`` ["user"]
    
    let workloadUnitTemplate = 
        ``:unit_template`` 
            ``:admin`` false 
            ``:main`` 
                [
                    ``:do`` helloUserCommand
                ] 
            ``:finally``
                []
            ``:files`` 
                []

    let workload =
        ``:workload``
            ``:unit_templates`` 
                [
                    workloadUnitTemplate 
                ]
            ``:files`` 
                []
            ``:arguments`` 
                [
                    ``:range`` "user" ``:over`` ["John"; "Ivan"; "Pablo"]
                ]

    workload |> runSampleWorkload

(**
Just *one* of the 30 lines of code above is the act of running the workload. The remaining code is *entirely* focussed on defining the workload itself.

#### Summary

We were able to model a workload with a parametric sweep and execute it against Azure Batch using a _little_ DSL in the Toolkit.

The key take-aways are:

1. It's useful to be able to take a workload-centric view of the problem, and abstract away the interaction with the Azure Batch Service (via the Azure Batch Client SDK).
1. We have an object model that allows us to think about *composing* smaller pieces together to make more complex workloads.
1. We have a little DSL that allows us to hide even the creation of the object model instances in a pleasant (if idiosyncratic) manner.
1. Specifically, this model (and the DSL) supports a way to sweep a set of values over a set of parameters to build a set of batch tasks.

Hope you have fun playing around with the DSL. You'll find the other supported operations [here](https://github.com/johnazariah/batch-toolkit/blob/master/src/Azure.Batch.Toolkit/DSL.fs).

Enjoy!
*)