// reads relevant information from assembly
namespace Plainion.IronDoc.Parsing

[<AutoOpen>]
module private ReflectionImpl = 
    open System
    open System.IO
    open System.Reflection
    open System.Diagnostics
    open Plainion.IronDoc

    /// <summary>
    /// Load assembly from byte[] to avoid getting the file locked by our process
    /// </summary>
    let reflectionOnlyLoad assemblyFile =
        let assemblyBytes = File.ReadAllBytes assemblyFile
        { DAssembly.name = Path.GetFileNameWithoutExtension(assemblyFile)
          location = Path.GetFullPath(assemblyFile)
          assembly = Assembly.ReflectionOnlyLoad assemblyBytes }

    let getAssemblyLocation (assemblyName:AssemblyName) baseDirs =
        let assemblyExtensions = [ ".dll"; ".exe" ]

        baseDirs
        |> List.collect( fun baseDir -> assemblyExtensions |> List.map( fun ext -> Path.Combine(baseDir, assemblyName.Name + ext) ) )
        |> List.tryFind File.Exists

    let tryReflectionOnlyLoadByName baseDirs (assemblyName:AssemblyName) =
        let reflectionOnlyLoadByName baseDirs assemblyName =
            let dependentAssemblyPath = baseDirs |> getAssemblyLocation assemblyName
            
            let tryLoadFromGAC () =
                try
                    // e.g. .NET assemblies, assemblies from GAC
                    Assembly.ReflectionOnlyLoad assemblyName.FullName
                with
                | _ -> 
                    // ignore exception here - e.g. System.Windows.Interactivity - app will work without
                    Debug.WriteLine ( "Failed to load: " + assemblyName.ToString() )
                    null

            match dependentAssemblyPath with
            | None -> tryLoadFromGAC()
            | Some x -> 
                if File.Exists x then
                    (reflectionOnlyLoad x).assembly
                else
                    tryLoadFromGAC()

        let tryFindLoadedAssembly (assemblies:Assembly seq) =
            assemblies |> Seq.tryFind( fun asm -> String.Equals(asm.FullName, assemblyName.FullName, StringComparison.OrdinalIgnoreCase) )

        match AppDomain.CurrentDomain.GetAssemblies() |> tryFindLoadedAssembly with
        | Some x -> // dont try to load the given assembly because we cannot load the same assembly twice from different locations
                    // instead just load the already "linked" assembly (e.g. Fsharp.Core) with reflection only again
                    Assembly.ReflectionOnlyLoad(x.FullName)
        | None ->
            match AppDomain.CurrentDomain.ReflectionOnlyGetAssemblies() |> tryFindLoadedAssembly with
            | Some x -> x
            | None -> assemblyName |> reflectionOnlyLoadByName baseDirs 
    
    let loadAssembly baseDirs file = 
        let newBaseDirs = 
            Path.GetDirectoryName(file)::baseDirs
            |> Seq.distinct
            |> List.ofSeq

        newBaseDirs, reflectionOnlyLoad file
        
    type LoadAssemblyMsg = 
        | LoadAssembly of string * replyChannel : AsyncReplyChannel<DAssembly>
        | Stop 

[<AutoOpen>]
module ReflectionApi = 
    open System
    open System.IO
    open System.Reflection
    open Plainion.IronDoc

    // https://kimsereyblog.blogspot.de/2016/07/manage-mutable-state-using-actors-with.html
    type AssemblyLoaderApi = {
        Load: string -> DAssembly
        Stop: unit -> unit
    }

    let assemblyLoader =
        let baseDirs = ref([ AppDomain.CurrentDomain.BaseDirectory ])

        let onAssemblyResolve = System.ResolveEventHandler( fun _ e ->
            let assembly = AppDomain.CurrentDomain.GetAssemblies ()
                            |> Array.tryFind( fun asm -> String.Equals(asm.FullName, e.Name, StringComparison.OrdinalIgnoreCase) )

            match assembly with
            | Some x -> x
            | None -> null )

        let onReflectionOnlyAssemblyResolve (e:ResolveEventArgs) = 
            let assembly = new AssemblyName( e.Name ) |> tryReflectionOnlyLoadByName !baseDirs

            if assembly <> null then
                // get all types to ensure that all relevant assemblies are loaded
                assembly.GetTypes() |> ignore

            assembly 

        AppDomain.CurrentDomain.add_AssemblyResolve onAssemblyResolve
        AppDomain.CurrentDomain.add_ReflectionOnlyAssemblyResolve (ResolveEventHandler( fun _ e -> onReflectionOnlyAssemblyResolve e))
        
        let agent = ResilientMailbox<LoadAssemblyMsg>.Start(fun inbox ->
            let rec loop () =
                async {
                    let! msg = inbox.Receive()

                    match msg with
                    | LoadAssembly (file, replyChannel) -> 
                        let newBaseDirs, assembly = file |> loadAssembly !baseDirs
                        
                        baseDirs := newBaseDirs

                        // get all types to ensure that all relevant assemblies are loaded
                        assembly.assembly.GetTypes() |> ignore

                        replyChannel.Reply assembly

                        return! loop ()
                    | Stop -> return ()
                }
            loop () ) 

        agent.Error.Add(handleLastChanceException)

        { Load = fun assembly -> agent.PostAndReply( fun replyChannel -> LoadAssembly( assembly, replyChannel ) )
          Stop = fun () -> agent.Post Stop }

    let rec createDType assembly (t : Type) =
        // we also want to have protected members
        let bindingFlags = BindingFlags.Instance ||| BindingFlags.Static ||| BindingFlags.DeclaredOnly ||| BindingFlags.Public ||| BindingFlags.NonPublic

        let getParameters (memberInfo : MemberInfo) = 
            (memberInfo :?> MethodBase).GetParameters()
            |> Seq.map(fun x -> { name = x.Name
                                  parameterType = x.ParameterType })
            |> List.ofSeq

        { assembly = assembly
          nameSpace = t.Namespace + (if t.IsNested then "." + t.DeclaringType.Name else String.Empty)
          name = t.Name
          fields =  t.GetFields(bindingFlags) 
                    |> Seq.filter(fun x -> not (x.IsPrivate || x.IsAssembly))
                    |> Seq.map(fun x -> { name = x.Name
                                          fieldType = x.FieldType })
                    |> List.ofSeq
          constructors = t.GetConstructors(bindingFlags) 
                         |> Seq.filter(fun x -> not (x.IsPrivate || x.IsAssembly))
                         |> Seq.map(fun x -> { Constructor.parameters = getParameters x })
                         |> List.ofSeq
          properties = t.GetProperties(bindingFlags) 
                       |> Seq.filter(fun x -> not (x.GetMethod.IsPrivate || x.GetMethod.IsAssembly))
                       |> Seq.map(fun x -> { name = x.Name
                                             propertyType = x.PropertyType })
                       |> List.ofSeq
          events = t.GetEvents(bindingFlags) 
                   |> Seq.filter(fun x -> not (x.AddMethod.IsPrivate || x.AddMethod.IsAssembly))
                   |> Seq.map(fun x -> { name = x.Name
                                         eventHandlerType = x.EventHandlerType})
                   |> List.ofSeq
          methods = t.GetMethods(bindingFlags) 
                    |> Seq.filter(fun x -> not (x.IsPrivate || x.IsAssembly))
                    |> Seq.filter(fun x -> not (x.IsSpecialName))
                    |> Seq.map(fun x -> { name = x.Name
                                          parameters = getParameters x
                                          returnType = x.ReturnType})
                    |> List.ofSeq
          nestedTypes = t.GetNestedTypes(bindingFlags) 
                        |> Seq.filter(fun x -> not (x.IsNestedPrivate || x.IsNestedAssembly))
                        |> Seq.map (createDType assembly)
                        |> List.ofSeq
        }
