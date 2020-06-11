namespace AccesRessources

open System
open FSharp.Configuration
open FSharp.Data

module InfoRessources =
    
    // Description des ressources
    type Parametres = JsonProvider<Sample="DescriptionRessources.json">
    let parametres = Parametres.Load "DescriptionRessources.json"
    
    // déclaration du type de donnée "Api"
    type ParametresAPI = Parametres.Api2
    
    // Récupération des information d'une api donnée
    let infoApi nomApi :option<ParametresAPI> =
        parametres.Api.Apis 
        |> Seq.toArray 
        |> Array.tryPick (fun x -> if x.Nom = nomApi then Some x else None)
    
    // déclaration du type de donnée "Ressource"
    type ParametresRessource = Parametres.Ressourcis
    
    // déclaration du type de donnée "Ressource" à laquelle on ajoute le endpoint de l'api
    type AllInfoRessource = 
        {   Ressource   :   ParametresRessource ;
            EndPoint    :   string  }

    // récupération des informations de laressource sur la base de son nom et de son api
    let infoRessource nomRessource (paramApi:ParametresAPI) :option<ParametresRessource> =
        paramApi.Ressources
        |> Seq.toArray
        |> Array.tryPick (fun x -> if x.Ressource = nomRessource then Some x else None)    

    // récupération des informations de l'api de la ressource
    let getApi nomRessource :option<ParametresAPI> =
        parametres.Api.Apis
        |> Seq.toArray
        |> Array.tryPick (
            fun x -> 
                let y = infoRessource nomRessource x
                match y with
                | Some z -> Some x
                | None -> None  )

    // récupération des informations de la ressource sur la base de son nom uniquement
    let infoRessourceApi nomRessource :option<AllInfoRessource> =  
        let infoApi = getApi nomRessource
        match infoApi with
        | Some x -> 
            Some (
                {   EndPoint    =   x.Endpoint
                    Ressource   =   (infoRessource nomRessource x).Value  } )
        | None -> None
        
module ManageDB =
    
    open System.IO

    Directory.SetCurrentDirectory(__SOURCE_DIRECTORY__)

    // récupération de toutes les informations de paramètres de stockage (documentDB et local)
    type InfoManagementDB = YamlConfig<"ParametresStockage.yaml">
    let infoDB = new InfoManagementDB()
    infoDB.Load("ParametresStockage.yaml")

    // module pour la gestion des données en local
    module Local =
        
        let racine = infoDB.local.dossier
        
        let dossier nom = Path.Combine(racine,nom)
        let creerDossier nom = Directory.CreateDirectory(dossier nom)

        // création du nom du fichier sur la base des dates
        let nomFichier (dates:((DateTime*DateTime) option)) = 
            (match dates with
            | Some (d,f) when d < System.DateTime.Today -> // nom de fichier "Historique" 
                "HIST_" + d.ToString(infoDB.local.formatDatePortee) + "_" + f.ToString(infoDB.local.formatDatePortee)

            | _ -> // nom de fichier de données courantes
                "COUR_" + System.DateTime.Today.ToString(infoDB.local.formatDatePortee))  
            + "-" + System.DateTime.Now.ToString(infoDB.local.formatDateMaj) + ".json"
         
        // tâche asynchrone d'écriture de fichier
        let printJson nomDossier nomFichier contenu = 
            async { 
                Directory.CreateDirectory(nomDossier) |> ignore
                System.IO.File.WriteAllText(Path.Combine(nomDossier,nomFichier), contenu) }
    
    module Cosmos =

        open Microsoft.Azure.Documents
        
        //let dataBase = infoDB.Azure.DataBase
        //let endpoint = infoDB.Azure.EndPoint
        //let primKey = infoDB.Azure.PrimaryKey
        //let connections

        let clientCosmos = new Client.DocumentClient(infoDB.Azure.EndPoint,infoDB.Azure.PrimaryKey)
        let dbRTE = new Database(Id = infoDB.Azure.DataBase)



module Requetes =

    open InfoRessources
    open Token.InfoToken

    let formatDate = "yyyy-MM-ddTHH:mm:sszzzzz"
    
    // paramètre de requête
    type ParametresRequete = 
        {   debut   :   DateTime    ;
            fin     :   DateTime    }

        member this.http = 
            [   ("start_date"   ,   this.debut.ToString(formatDate))    ;
                ("end_date"     ,   this.fin.ToString(formatDate))      ]

    //creation de l'uri de la ressource
    let uriRessource (api:ParametresAPI) (ressource:ParametresRessource) =
        parametres.Domaine + parametres.Api.EndPoint + api.Endpoint + "/" + ressource.Fonction
        
    // création de la requête async de la ressource
    let requeteRessource (application:string) (api:ParametresAPI) (dates:option<ParametresRequete>) (ressource:ParametresRessource) = 
        
        let atoken = (infoApplication application).Value.Token
        let entete = 
            [   "Authorization"                 ,   atoken.TokenType + " " + atoken.AccessToken ;
                parametres.Api.LibContenttype   ,   parametres.Api.ContentType                  ]

        match dates with
        | Some d ->
            
            Http.AsyncRequestString(
                url     =   uriRessource api ressource  ,
                headers =   entete                      ,
                query   =   d.http             )

        | _ -> 

            Http.AsyncRequestString(
                url     =   uriRessource api ressource  ,
                headers =   entete                      )

module Application =

    open InfoRessources
    open Requetes
    open ManageDB
    open ManageDB.Local

    let runApi (application:string) (api:string) (dates:(DateTime*DateTime) option) =
        
        let paramApi = (infoApi api).Value
        let ressources = paramApi.Ressources 
        let folders = ressources |> Seq.toList |> List.map (fun x -> x.Collection)
        
        let (paramRequette:ParametresRequete option) =
            match dates with
            | Some (d,f) when (d < System.DateTime.Today) ->
                Some ({ debut   =   d
                        fin     =   List.min [f;System.DateTime.Today]   })
            | _ -> None

        let reponsesRequetes = 
            ressources
            |> Seq.map (requeteRessource application paramApi paramRequette)
            |> Async.Parallel
            |> Async.RunSynchronously
            |> Seq.toList

        List.zip folders reponsesRequetes
        |> List.map (fun x -> printJson (dossier (fst x)) (nomFichier dates) (snd x))
        |> Async.Parallel
        |> Async.RunSynchronously
    
    