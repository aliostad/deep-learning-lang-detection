namespace Jenkins.Fsharp

open System
open System.Web

module JenkinsRoutes = 
    [<Literal>]
    let Info = "api/json"
    [<Literal>]
    let JobInfo = "job/{0}/api/json?depth={1}"
    [<Literal>]
    let JobName = "job/{0}/api/json?tree=name"
    [<Literal>] 
    let PluginInfo = "pluginManager/api/json?depth={0}"
    [<Literal>] 
    let CrumbUrl = "crumbIssuer/api/json"
    [<Literal>] 
    let QueueInfo = "queue/api/json?depth=0"
    [<Literal>] 
    let CancelQueue = "queue/cancelItem?id={0}"
    [<Literal>] 
    let CreateJob = "createItem?name={0}"
    [<Literal>] 
    let ConfigJob = "job/{0}/config.xml"
    [<Literal>] 
    let DeleteJob = "job/{0}/doDelete"
    [<Literal>] 
    let EnableJob = "job/{0}/enable"
    [<Literal>] 
    let DisableJob = "job/{0}/disable"
    [<Literal>] 
    let CopyJob = "createItem?name={0}&mode=copy&from={1}"
    [<Literal>] 
    let RenameJob = "job/{0}/doRename?newName={1}"
    [<Literal>] 
    let BuildJob = "job/{0}/build"
    [<Literal>] 
    let StopBuild = "job/{0}/{1}/stop"
    [<Literal>] 
    let BuildWithParametersJob = "job/{0}/buildWithParameters"
    [<Literal>] 
    let BuildInfo = "job/{0}/{1}/api/json?depth={2}"
    [<Literal>] 
    let BuildConsoleOutput = "job/{0}/{1}/consoleText"
    [<Literal>] 
    let NodeList = "computer/api/json"
    [<Literal>] 
    let CreateNode = "computer/doCreateItem?{0}"
    [<Literal>] 
    let DeleteNode = "computer/{0}/doDelete"
    [<Literal>] 
    let NodeInfo = "computer/{0}/api/json?depth={1}"
    [<Literal>] 
    let NodeType = "hudson.slaves.DumbSlave$DescriptorImpl"
    [<Literal>] 
    let ToggleOffline = "computer/{0}/toggleOffline?offlineMessage={1}"
    [<Literal>] 
    let ConfigNode = "computer/{0}/config.xml"

