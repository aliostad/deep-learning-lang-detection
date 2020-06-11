namespace FactorioRecipes

open NLua

type LuaType =
    | String of string
    | Float of float
    | Bool of bool
    | Value of (LuaType * LuaType) list
    | Unsupported of string

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module LuaType =
    let rec fromLuaTable (x:LuaTable) =
        let keys = Array.zeroCreate x.Keys.Count
        let values = Array.zeroCreate x.Values.Count
        x.Keys.CopyTo( keys, 0 )
        x.Values.CopyTo( values, 0 )

        let toValue = 
            Array.map
                (fun (v:obj) ->
                match v with
                | :? string as x -> String x
                | :? float as x -> Float x
                | :? bool as x -> Bool x
                | :? LuaTable as x -> Value (fromLuaTable x)
                | _ as x -> Unsupported (x.ToString()))

        Seq.map2 (fun a b -> (a, b)) (keys |> toValue) (values |> toValue)
        |> Seq.sort
        |> Seq.toList

    let isValue = function | Value x -> true | _ -> false
    let tryValue = function | Value x -> Some x | _ -> None
    let value = function | Value x -> x | _ -> failwith "not a value"
