#r "../packages/FSharp.Configuration.1.2.0/lib/net46/FSharp.Configuration.dll"
#r "../packages/FSharp.Data.2.3.3/lib/net40/FSharp.Data.dll"
#r "../packages/Microsoft.Azure.DocumentDB.1.14.1/lib/net45/Microsoft.Azure.Documents.Client.dll"

open FSharp.Configuration
open FSharp.Data
open System

module Definitions = 

    let contenType = "accept","Application/json;charset=UTF-8"
    
    type Token = YamlConfig<FilePath="Application1.yml">

    type ParametresApplication = AppSettings<"App.Config">
    type DescriptionRessources = JsonProvider<Sample="../DescriptionRessources.json">
    type TokenJson = JsonProvider<Sample="../ReponseTokenSample.json"> 
        
    module Format =
        let datetime = "yyyy-MM-ddTHH:mm:sszzzzz"

    type RequestBody = 
        {   debut   : DateTime ; 
            fin     : DateTime  }
        
        member this.stringDebut = this.debut.ToString(Format.datetime)
        member this.stringFin = this.fin.ToString(Format.datetime)
        member this.http = [("start_date",this.stringDebut);("end_date",this.stringFin)]
    
    let ressources = DescriptionRessources.Load("../DescriptionRessources.json")

module Parametres =

    open Definitions

    module Locaux =

        let dossierSource = __SOURCE_DIRECTORY__
        let executable = System.IO.Path.Combine [|dossierSource; "bin/debug" ; "DataServices.exe"|]
        ParametresApplication.SelectExecutableFile executable

module Authentification =

    open Definitions
    open Parametres
    
    type InfoToken =
        {   Json        : TokenJson.Root ; 
            DateExpire  : System.DateTime    }
        
        member this.httpheader = "Authorization", this.Json.TokenType + " " + this.Json.AccessToken
    
    let mutable tokenCourant:InfoToken =
        {   Json        = TokenJson.GetSample() ;
            DateExpire  = System.DateTime.MinValue   }
       
    let getToken =

        let oauthKey =
            "Basic " 
            + 
            System.Convert.ToBase64String(
                System.Text.ASCIIEncoding.ASCII.GetBytes(
                    string (ParametresApplication.IdClient) 
                    + ":" 
                    + string (ParametresApplication.IdSecret)))

        let req = 
            Http.AsyncRequestString(
                url     = API.racineDomaine + ParametresApplication.TokenEndPoint,
                headers = 
                    [   "Authorization" , oauthKey ; 
                        "Content-Type"  , ParametresApplication.TokenContentType    ])

        let rep = TokenJson.Parse (Async.RunSynchronously req)

        {   Json        = rep ; 
            DateExpire  = System.DateTime.Now.AddSeconds (float rep.ExpiresIn)   }

    let token = 
        if tokenCourant.DateExpire < System.DateTime.Now
        then getToken
        else tokenCourant

module RunAPI =

    open Definitions
    open Parametres

    let urisApi (api:DescriptionRessources.Api) = 
        api.Ressources
        |> Seq.toArray 
        |> Array.map (fun (x:DescriptionRessources.Ressourcis) -> x.Ressource , (API.racineDomaine + api.Endpoint + x.Fonction))

    let uriRessource (api:DescriptionRessources.Api) (ressource:string) =
        urisApi api |> Array.pick (fun x -> if (fst x) = ressource then Some (snd x) else None)
        
    let req (api:DescriptionRessources.Api) (res:string) (parametresRequete:option<RequestBody>) = 
        match parametresRequete with
        | Some pr ->
            Http.AsyncRequestString(
                url     = uriRessource api res,
                headers = [Authentification.token.httpheader;contenType],
                query    = pr.http)
        | None -> 
            Http.AsyncRequestString(
                url     = uriRessource api res,
                headers = [Authentification.token.httpheader;contenType])
                
    let reponse (api:DescriptionRessources.Api) (res:string) (parametresRequete:option<RequestBody>) =
        Async.RunSynchronously (req api res parametresRequete)

module ManageDB =
    
    open Definitions
    open Definitions

    module Local =
    
        let foldersApi (api:DescriptionRessources.Api) = 
            api.Ressources
            |> Seq.toArray
            |> Array.map (fun x -> x.Ressource, ParametresApplication.FolderLocal + "/" + api.Nom + "/" + x.Collection)
         
        let folderRessource (api:DescriptionRessources.Api) (res:string) =
            foldersApi api
            |> Array.pick (fun x -> if (fst x) = res then Some (snd x) else None)
            
        let fileName (date:option<System.DateTime>) = 
            (match date with
            | Some d -> "HIST_" + d.ToString("yyyyMMdd")
            | None -> "COUR_" + System.DateTime.Today.ToString("yyyyMMdd"))  
            + "-" + System.DateTime.Now.ToString("yyyyMMddhhmmsss") + ".json"
         
        let printJson fichier contenu = System.IO.File.WriteAllText(fichier, contenu)

        let jsonUnJour (api:DescriptionRessources.Api) (res:string) (date:option<System.DateTime>) =
            (match date with
            | Some d -> Some {debut = d.AddDays(-1.0) ; fin = d}
            | None -> None) 
            |> RunAPI.reponse api res
            |> printJson ((folderRessource api res) + "/" + (fileName date))
                        
        let jsonMultiple (api:DescriptionRessources) (res:string) (dates:System.DateTime[]) =
