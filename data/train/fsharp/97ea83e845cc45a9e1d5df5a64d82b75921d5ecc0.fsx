module Reflected =

    open System.Reflection

    let private apiTypes = ConcurrentMutableDict<string, System.Type>()
    let private bindingFlags = BindingFlags.Static ||| BindingFlags.Public

    let private assembly = 
      AppDomain.CurrentDomain.GetAssemblies() 
        |> Array.find (fun x -> x.FullName.StartsWith("IronJS,"))

    let rec methodInfo type' method' =
      let found, typeObj = apiTypes.TryGetValue type'
      if found then typeObj.GetMethod(method', bindingFlags)
      else
        match assembly.GetType("IronJS." + type', false) with
        | null -> null
        | typeObj ->
          apiTypes.TryAdd(type', typeObj) |> ignore
          methodInfo type' method'

    let rec propertyInfo type' property =
      let found, typeObj = apiTypes.TryGetValue type'
      if found then typeObj.GetProperty(property, bindingFlags)
      else
        let types = assembly.GetTypes()
        match assembly.GetType("IronJS." + type', false) with
        | null -> null
        | typeObj ->
          apiTypes.TryAdd(type', typeObj) |> ignore
          propertyInfo type' property