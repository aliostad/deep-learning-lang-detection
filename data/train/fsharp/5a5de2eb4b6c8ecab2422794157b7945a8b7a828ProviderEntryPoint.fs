namespace OfficeProvider

open System
open System.IO
open System.Reflection
open Microsoft.FSharp.Core.CompilerServices
open ProviderImplementation.ProvidedTypes
open Microsoft.FSharp.Quotations

type OfficeTypeProvider(config:TypeProviderConfig, 
                        rootTypeCtor: (Assembly * string -> ProvidedTypeDefinition), 
                        providerCtor : (ProviderInitParameters -> IOfficeProvider),
                        loadExpr : (ProviderInitParameters * Expr list) -> Expr) as this = 
    inherit TypeProviderForNamespaces()
    
    let rootNamespace = "OfficeProvider"
    let thisAssembly = Assembly.GetExecutingAssembly()
    let officeRootType = rootTypeCtor (thisAssembly, rootNamespace)


    let staticParameters = [
        ProvidedStaticParameter("Document", typeof<string>)
        ProvidedStaticParameter("WorkingDirectory", typeof<string>, "")
        ProvidedStaticParameter("CopySourceFile", typeof<bool>, true)
        ProvidedStaticParameter("AllowNameEquality", typeof<bool>, true)
    ]

    do officeRootType.DefineStaticParameters(staticParameters, 
        fun typeName parameters ->
            let documentPath = (parameters.[0] :?> string)
            let resolutionPath = 
                let respath = (parameters.[1] :?> string)
                if String.IsNullOrWhiteSpace respath 
                then config.ResolutionFolder
                else respath
            let shadowCopy = (parameters.[2] :?> bool)
            let allowNameEquality = (parameters.[3] :?> bool)

            let typePrefix = Path.GetFileNameWithoutExtension(documentPath).Replace(" ", "")
            let serviceType = ProvidedTypeDefinition(typePrefix + "DocumentTypes", None, HideObjectMethods = true)
            let documentType = ProvidedTypeDefinition(typePrefix + "Document", Some typeof<ITransacted>, HideObjectMethods = true)

            let parameters = { 
                ResolutionPath = resolutionPath; 
                DocumentPath = documentPath; 
                ShadowCopy = shadowCopy;
                AllowNameEquality = allowNameEquality
            }

            let provider = providerCtor(parameters) 

            let properties = 
                provider.GetFields()
                |> Array.map (Field.toProvidedProperty serviceType documentType)
            
            documentType.AddMembers(properties |> Array.toList)

            provider.Dispose()

            serviceType.AddMember(documentType)

            let rootType = ProvidedTypeDefinition(Assembly.LoadFrom config.RuntimeAssembly, rootNamespace, typeName, Some typeof<obj>, HideObjectMethods = true)
            
            rootType.AddMember(serviceType)
            rootType.AddMember(ProvidedMethod("Load", [ProvidedParameter("document", typeof<string>)], 
                                documentType, 
                                IsStaticMethod = true, 
                                InvokeCode = (fun args -> loadExpr(parameters, args))))

            rootType
    )
    
    do this.AddNamespace(rootNamespace, [officeRootType])

[<TypeProvider>]
type ExcelTypeProvider(config:TypeProviderConfig) =
    inherit OfficeTypeProvider(
        config, 
        (fun (assm, ns) -> ProvidedTypeDefinition(assm, ns, "Excel", Some typeof<obj>)),
        (fun param -> new ExcelProvider(param.ResolutionPath, param.DocumentPath, param.ShadowCopy) :> IOfficeProvider),
        (fun (param, args) -> 
            let (rp, sc) = (param.ResolutionPath, param.ShadowCopy)
            <@@  
                 let doc = (%%args.[0] : string)
                 new ExcelProvider(rp, doc, sc) :> ITransacted @@>)   
    )

// [<TypeProvider>]
// type WordTypeProvider(config:TypeProviderConfig) =
//     inherit OfficeTypeProvider(
//         config, 
//         (fun (assm, ns) -> ProvidedTypeDefinition(assm, ns, "Word", Some typeof<obj>)),
//         (fun param -> new WordProvider(param.ResolutionPath, param.DocumentPath, param.ShadowCopy) :> IOfficeProvider),
//         (fun (param, args) -> 
//             let (rp, sc) = (param.ResolutionPath, param.ShadowCopy)
//             <@@ 
//                  let doc = (%%args.[0] : string)
//                  new WordProvider(rp, doc, sc) :> ITransacted @@>)   
//     )

[<assembly:TypeProviderAssembly>]
do()

     
