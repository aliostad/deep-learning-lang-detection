// --------------------------------------------------------------------------------------
// FAKE build script
// --------------------------------------------------------------------------------------

#r @"packages/FAKE/tools/FakeLib.dll"
open Fake

#load "generate.fsx"

let defaultOutputDir = __SOURCE_DIRECTORY__ + "/wwwroot"

/// Run a local web server using the local copy of wwwroot/
Target "Run" (fun _ ->
    Generate.watch defaultOutputDir true
)

/// Rebuild the local copy of wwwroot/
Target "Generate" (fun _ ->
    Generate.rebuildSite defaultOutputDir true None
)

/// For use when publishing the website on Azure using Kudu and Git-based deployment.
/// Just pushing the root of the repository to the Azure Git repository associated with the website
/// will trigger the following build step on the Kudu server which rebuilds the server copy of the wwwroot/ directory.
Target "AzureKudu" (fun _ ->
    let domainName =
        let domain = System.Environment.GetEnvironmentVariable("WEBSITE_HOSTNAME")
        if isNull domain then
            failwith "Web hostname not specified. Is this script really running in Azure/Kudu?"
        elif domain = "luweiblog.azurewebsites.net" then // remap Azure domain to custom domain name.
            Some "william.famille-blum.org"
        else
            Some domain

    // Push sources to Azure then build&deploy using Kudu deployment on the Azure server
    // See https://github.com/projectkudu/kudu/wiki/Custom-Deployment-Script
    Generate.rebuildSite (__SOURCE_DIRECTORY__ + "/../wwwroot") true domainName
)

/// For use when updating the local copy of the /wwwroot directory to be later
/// published by pushing the wwwroot/ git repository to Azure website.
Target "AzureInPlace" (fun _ ->
    // Push wwwroot to Azure through a separate Git repo
    // See https://github.com/projectkudu/kudu/wiki/Deploying-inplace-and-without-repository
    // for instructions on how to perform inplace Git deployment to wwwroot
    //   SCM_REPOSITORY_PATH=wwwroot
    //   SCM_TARGET_PATH=wwwroot
    Generate.rebuildSite defaultOutputDir true (Some "william.famille-blum.org")

    printfn "ACTION REQUIRED: Push wwwroot/ git repository to Azure to publish the website."
)

RunTargetOrDefault "Run"