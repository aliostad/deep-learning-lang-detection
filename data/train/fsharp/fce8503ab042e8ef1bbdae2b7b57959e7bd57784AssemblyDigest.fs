module AssemblyDigest

open System
open System.Reflection
open Config
open IO
open Domain
open CodeDigest

let _loadDomain (config : ConfigValues) =    
    Assembly.LoadFrom(config.pathToDomainAssembly)

let checkEventHandlerType (t : Type) =
    let signature1 = @"IHandleEvent`1"
    let signature2 = @"IHandle`1"    
    let events =
        t.GetInterfaces()
        |> Seq.choose (fun i ->
            if (i.Name = signature1 || i.Name = signature2)
            then i.GetGenericArguments().[0].Name |> Some
            else None)
        |> Seq.toList
    if (List.length events = 0)
    then None
    else Some events
    
type ClassPresentation<'T> = Type -> 'T option
       
let scanDomainClasses (config: ConfigValues) (present: ClassPresentation<'T>) : 'T list =
    let domain = _loadDomain(config)
    domain.GetTypes() |> Seq.toList |> List.choose present         


let domainClassTypeToPath (config : ConfigValues) (t : Type) =   
    let domainNsPrefix = config.domainNsPrefix
    [ 
        yield config.pathToDomainClasses
        yield! Array.toList <|  t.Namespace.Replace(domainNsPrefix, "").Split('.')           
    ]
    |> fun pieces -> String.Join("\\", pieces)
    |> fun path -> Dir'.toDir'(path).getFiles()
    |> List.find (fun f ->
        let build (name, path) =
            if (name = t.Name)
            then Some (name, path)
            else None
        discoverClassInFile build f |> List.exists Option.isSome)
    |> fun f -> f.Path

let getAllEventHandlerClasses (configValues : ConfigValues) =
    let getEventHandlerType t =
            checkEventHandlerType t 
            |> Option.bind (                
                fun es ->
                    let events = es |> List.map EventClass 
                    EventHandlerClass (t.Name, domainClassTypeToPath configValues t, events) |> Some)                   
    scanDomainClasses configValues getEventHandlerType        

let getAllDomainClasses configValues = 
    let handlerClassReps = getAllEventHandlerClasses configValues |> List.map (fun x -> Q.name x, Q.path x)
    scanDomainClassFiles configValues (discoverClassInFile Domain.DomainClass >> Some)     
    |> List.concat
    |> List.where (fun x ->
        let rep = (Q.name x, Q.path x) 
        List.contains rep handlerClassReps |> not)