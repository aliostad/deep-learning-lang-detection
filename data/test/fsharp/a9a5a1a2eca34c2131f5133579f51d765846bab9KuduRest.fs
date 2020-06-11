namespace KuduRest

open Http

type KuduRestClient (siteName:string, username:string, password:string) =
    
    let baseUrl = sprintf "https://%s.scm.azurewebsites.net" siteName
    let client = RestClient(username,password)

    member __.ScmInfo () = 
        client.Get (sprintf "%s/api/scm/info" baseUrl) 
        |> unpackResponse streamToString
    member __.ScmClean () = 
        client.Post (sprintf "%s/api/scm/info" baseUrl) ""
        |> unpackResponse streamToString
    member __.ScmDelete () = 
        client.Delete (sprintf "%s/api/scm" baseUrl)
        |> unpackNoResponse
    member __.Command command dir = 
        client.Post (sprintf "%s/api/command" baseUrl) (sprintf """{ "command": "%s", "dir": "%s" }""" command dir)
        |> unpackResponse streamToString
    member __.GetFile path = 
        client.Get (sprintf "%s/api/vfs/%s" baseUrl path)
        |> unpackResponse streamToBytes
    member __.PutFile filepath fileContent = 
        client.PutBinary (sprintf "%s/api/vfs/%s" baseUrl filepath) fileContent
        |> unpackResponse streamToString
    member __.PutDirectory dir = 
        client.Put (sprintf "%s/api/vfs/%s/" baseUrl dir) ""
        |> unpackResponse streamToString
    member __.VfsDeleteFile filePath = 
        client.Delete (sprintf "%s/api/vfs/%s" baseUrl filePath)
        |> unpackResponse streamToString
    member __.ZipGet filePath = 
        client.Get (sprintf "%s/api/zip/%s" baseUrl filePath)
        |> unpackResponse streamToBytes
    member __.ZipPut filePath fileContent = 
        client.PutBinary (sprintf "%s/api/zip/%s" baseUrl filePath) fileContent
        |> unpackResponse streamToString
    member __.DeploymentsList () = 
        client.Get (sprintf "%s/api/deployments" baseUrl)
        |> unpackResponse streamToString
    member __.GetDeployment id = 
        client.Get (sprintf "%s/api/deployments/%s" baseUrl id)
        |> unpackResponse streamToString
    member __.RedployDeployment id = 
        client.Put (sprintf "%s/api/deployments/%s" baseUrl id) ""
        |> unpackResponse streamToString
    member __.AddDeploymentStatus id = 
        client.Put (sprintf "%s/api/deployments/%s" baseUrl id) "TODO"
        |> unpackResponse streamToString
    member __.DeleteDeployment id = 
        client.Delete (sprintf "%s/api/deployments/%s" baseUrl id)
        |> unpackResponse streamToString
    member __.GetDeploymentLog deploymentId = 
        client.Get (sprintf "%s/api/deployments/%s/log" baseUrl deploymentId)
        |> unpackResponse streamToString
    member __.GetDeploymentLogById deploymentId logId = 
        client.Get (sprintf "%s/api/deployments/%s/log/%s" baseUrl deploymentId logId)
        |> unpackResponse streamToString
    member __.DeployPost () = 
        client.Post (sprintf "%s/deploy" baseUrl) ""
        |> unpackResponse streamToString
    member __.GenerateSshKey () = 
        client.Get (sprintf "%s/api/sshkey?ensurePublicKey=1" baseUrl)
        |> unpackResponse streamToString
    member __.SetSshPrivateKey key = 
        client.Put (sprintf "%s/api/sshkey" baseUrl) key
        |> unpackResponse streamToString
    member __.GetSsHPublicKey () = 
        client.Get (sprintf "%s/api/sshkey" baseUrl)
        |> unpackResponse streamToString
    member __.KuduVersion () = 
        client.Get (sprintf "%s/api/environment" baseUrl)
        |> unpackResponse streamToString
    member __.UpdateSettings () = 
        client.Post (sprintf "%s/api/settings" baseUrl) ""
        |> unpackResponse streamToString
    member __.GetAllSettings () = 
        client.Get (sprintf "%s/api/settings" baseUrl)
        |> unpackResponse streamToString
    member __.GetSetting key = 
        client.Get (sprintf "%s/api/settings/%s" baseUrl key)
        |> unpackResponse streamToString
    member __.DeleteSetting key = 
        client.Delete (sprintf "%s/api/settings/%s" baseUrl key)
        |> unpackResponse streamToString
    member __.Diagnostics () = 
        client.Get (sprintf "%s/api/dump" baseUrl)
        |> unpackResponse streamToBytes
    member __.SetDiagnosticsSetting () = 
        client.Post (sprintf "%s/api/diagnostics/settings" baseUrl) ""
        |> unpackResponse streamToString
    member __.GetAllGetDiagnosticsSettings () = 
        client.Get (sprintf "%s/api/diagnostics/settings" baseUrl)
        |> unpackResponse streamToString
    member __.GetDiagnosticsSetting key = 
        client.Get (sprintf "%s/api/diagnostics/settings/%s" baseUrl key)
        |> unpackResponse streamToString
    member __.DeleteDiagnosticsSetting key = 
        client.Delete (sprintf "%s/api/diagnostics/settings/%s" baseUrl key)
        |> unpackResponse streamToString
    member __.Logs () = 
        client.Get (sprintf "%s/api/logs/recent" baseUrl)
        |> unpackResponse streamToString
    member __.ListAllExtentions () = 
        client.Get (sprintf "%s/api/extensionfeed" baseUrl)
        |> unpackResponse streamToString
    member __.ListExtentionById id = 
        client.Get (sprintf "%s/api/extensionfeed/%s" baseUrl id)
        |> unpackResponse streamToString
    member __.InstalledSiteExtentions () = 
        client.Get (sprintf "%s/api/siteextensions" baseUrl)
        |> unpackResponse streamToString
    member __.GetInstalledExtentionById id = 
        client.Get (sprintf "%s/api/siteextensions/%s" baseUrl id)
        |> unpackResponse streamToString
    member __.InstallSiteExtention id package = 
        client.Put (sprintf "%s/api/siteextensions/%s" baseUrl id) ""
        |> unpackResponse streamToString
    member __.UninstallExtentions id = 
        client.Delete (sprintf "%s/api/siteextensions/%s" baseUrl id)
        |> unpackResponse streamToString
