module Fungible.Core

open Fungible.Helpers

open System
open System.Reflection
open System.Linq.Expressions

open Microsoft.FSharp.Reflection
open Microsoft.FSharp.Quotations

/// <summary>
/// A wrapper to annotate transform expressions with the kind of transform they are
/// </summary>
type FieldAction =
    /// Map over the elements, input function is 'a -> 'a for a' []
    | Map of Expr   
    /// Filter out elements, input function is 'a -> bool for a' []      
    | Filter of Expr  
    /// Collect up elements, input function is 'a -> 'a [] for a' []
    | Collect of Expr 
    /// Default (if none or empty), input function is unit -> 'a [] for a '[]
    | Default of Expr 
    /// Transform at the value level, input function is 'a [] -> 'a [] for a '[] (same as map for single values)
    | Function of Expr 
    /// Adds to the current collection, input function is unit -> 'a [] for a '[]  
    | Add of Expr     
    /// Compares original and changed version of collection, input function is (string list, 'a, 'a) -> unit
    | Compare of Expr
with 
    /// Applies the contents of this FieldAction to the given Expr generating function
    member t.MapExpr (f: Expr -> Expr) =
        match t with
        | Map e -> f e |> Map
        | Filter e -> f e |> Filter
        | Collect e -> f e |> Collect
        | Default e -> f e |> Default
        | Function e -> f e |> Function
        | Add e -> f e |> Add
        | Compare e -> f e |> Compare
    /// All Union Cases
    static member AllActions() = 
        FSharpType.GetUnionCases typeof<FieldAction>

type FieldUpdaters = Map<string list, FieldAction list>

open ExprHelpers
open CollectionHelpers

type FungibleCoreSettings =
    {
        /// When true it will attempt to clone the entire structure
        CloneWhenNoChanges: bool
        /// When true it will fail when it finds a type it doesn't 
        /// know about, when false it will simply return the same
        /// instance
        FailOnUnsupportedType: bool
    }
    with static member Default = { CloneWhenNoChanges = false; 
                                   FailOnUnsupportedType = false }

module internal Copiers = 

    let rec makeCopyExpr (rcs: FungibleCoreSettings) (mtype: Type) (funcs: FieldUpdaters) (path: string list) (instance: Expr) : Expr = 
        match mtype with 
        | IsOptionType _ -> genOptionCopy rcs mtype funcs path instance
        | _ when FSharpType.IsRecord mtype -> genRecordCopier rcs mtype funcs path instance
        | _ when FSharpType.IsUnion mtype  -> genUnionCopier rcs mtype funcs path instance
        | _ when mtype.IsValueType || mtype = typeof<String> -> genSimpleValueCopy rcs mtype funcs path instance 
        | _ when mtype.IsArray -> genArrayCopier rcs mtype funcs path instance
        | IsMapType _ -> genMapCopier rcs mtype funcs path instance
        | _ when FSharpType.IsTuple mtype -> genTupleCopyFunExpr rcs mtype funcs path instance
        | _ when mtype = typeof<obj> -> instance 
        | _ when rcs.FailOnUnsupportedType -> failwithf "Type not supported in record cloning: %s" mtype.FullName
        | _ -> instance

    and makeSingleArgCopyFunExpr rcs (mtype: Type) (funcs: FieldUpdaters) (path: string list) : Expr =
        let arg = Var("x", mtype, false)
        let useArg = Expr.Var(arg)
        let contents = makeCopyExpr rcs mtype funcs path useArg
        Expr.Lambda(arg, contents)
  
    and makeMultiArgCopyFunExpr rcs (mtypes: Type []) (funcs: FieldUpdaters) (path: string list) : Expr =
        let tupleType = 
            match mtypes.Length with
            | 0 -> failwith "No types specified for tuple"
            | 1 -> failwith "Single type tuples not supported"
            | _ -> FSharpType.MakeTupleType mtypes
        let arg = Var("x", tupleType, false)
        let useArg = Expr.Var(arg)
        let contents = makeCopyExpr rcs tupleType funcs path useArg
        Expr.Lambda(arg, contents)

    and genTupleCopyFunExpr rcs (ttype: Type) (funcs: FieldUpdaters) (path: string list) (instance: Expr) : Expr =
   
        let tupleElements () = 
            let typeArgs = FSharpType.GetTupleElements ttype
            [ for i = 0 to typeArgs.Length - 1 do 
                let tet = typeArgs.[i]
                let gt = Expr.TupleGet(instance, i)
                let path = (sprintf "Item%i" (i + 1)) :: path
                yield makeCopyExpr rcs tet funcs path gt
            ]
        if funcs |> Map.containsKey path then
            Expr.NewTuple(tupleElements ())
        else instance
       
    and getTypedException (utype: Type) (message: string) =
            let m = (getMethod <@ failwith message @>).MakeGenericMethod([|utype|])
            Expr.Call(m, [ <@ message @> ])

    and genRecordCopier rcs (rtype: Type) (funcs: FieldUpdaters) (path: string list) (instance: Expr) : Expr =  
        let genRecordCopy () =   
            FSharpType.GetRecordFields(rtype) 
            |> Array.toList
            |> List.map (fun field -> field.Name :: path, field)
            |> List.map (fun (fpath, field) -> genFieldCopy rcs instance field funcs fpath)
            |> newrec rtype
        genRecordCopy ()

    and genFieldCopy rcs recordInstance (field: PropertyInfo) (funcs: FieldUpdaters) (path: string list) : Expr = 
        let pval = Expr.PropertyGet(recordInstance, field) 
        makeCopyExpr rcs field.PropertyType funcs path pval
         
    and genSimpleValueCopy _ (vtype: Type) (funcs: FieldUpdaters) (path: string list) (origInstance: Expr) : Expr = 
        let rec applyTransforms (funcs: FieldAction list) (instance: Expr) =
            match funcs with   
            | [] -> instance
            | Map(updater) :: rest -> let instance = updater |> application instance in applyTransforms rest instance
            | Function(updater) :: rest -> let instance = updater |> application instance in applyTransforms rest instance
            | Filter(_) :: _ -> failwith "Cannot filter on simple types"
            | Collect(_) :: _ -> failwith "Cannot collect on simple types" 
            | Default(_) :: _ -> failwith "Cannot default on simple types"   
            | Add(_) :: _ -> failwith "Cannot add on simple types"   
            | Compare(compfun) :: rest -> let instance = compfun |> applyCompare vtype path origInstance instance in applyTransforms rest instance
        match funcs |> Map.tryFind path with
        | Some transforms -> applyTransforms transforms origInstance
        | None -> origInstance

    and genOptionCopy rcs (itype: Type) (funcs: FieldUpdaters) (path: string list) (origInstance: Expr) : Expr = 
        let etype = itype.GetGenericArguments().[0]

        let rec applyTransforms (funcs: FieldAction list) (instance: Expr) =
            match funcs with
            | [] -> instance
            | Map(updater) :: rest -> 
                let m = (getMethod <@ Option.map X X @>).MakeGenericMethod([|etype; etype|])
                let instance = Expr.Call(m, [updater; instance]) in applyTransforms rest instance
            | Filter(updater) :: rest -> 
                let m = (getMethod <@ filterOption X X @>).MakeGenericMethod([|etype|])
                let instance = Expr.Call(m, [updater; instance]) in applyTransforms rest instance
            | Collect(_) :: _ -> failwith "Cannot collect on option types"       
            | Default(updater) :: rest -> 
                let m = (getMethod <@ defaultOptionIfNull X X @>).MakeGenericMethod([|etype|])
                let instance = Expr.Call(m, [updater; instance]) in applyTransforms rest instance
            | Function(updater) :: rest -> let instance = updater |> application instance in applyTransforms rest instance
            | Add(_) :: _ -> failwith "Cannot add on option types"
            | Compare(compfun) :: rest -> let instance = compfun |> applyCompare itype path origInstance instance in applyTransforms rest instance

        let copyOption funcs = 
            let copyfun = makeSingleArgCopyFunExpr rcs etype funcs path
            let m = (getMethod <@ Option.map X X @>).MakeGenericMethod([|etype; etype|])
            Expr.Call(m, [copyfun; origInstance])
    
        match funcs |> Map.tryFind path, funcs |> Map.remove path, rcs.CloneWhenNoChanges with
        | None, _, false -> origInstance
        | None, _, true -> copyOption Map.empty
        | Some transforms, newfuncs, _ -> applyTransforms transforms (copyOption newfuncs)
              
    and genArrayCopier rcs (atype : Type) (funcs: FieldUpdaters) (path: string list) (origInstance: Expr) : Expr = 
        let etype = atype.GetElementType()        

        let rec applyTransforms (funcs: FieldAction list) (instance: Expr) =
            match funcs with
            | [] -> instance
            | Map(updater) :: rest ->
                // Map from e -> e
                let m = (getMethod <@ Array.map X X @>).MakeGenericMethod([|etype; etype|])
                let instance = Expr.Call(m, [updater; instance]) in applyTransforms rest instance
            | Filter(filter) :: rest -> 
                let m = (getMethod <@ Array.filter X X @>).MakeGenericMethod([|etype|])            
                let instance = Expr.Call(m, [filter; instance]) in applyTransforms rest instance
            | Collect(collecter) :: rest -> 
                let m = (getMethod <@ Array.collect X X @>).MakeGenericMethod([|etype; etype|])            
                let instance = Expr.Call(m, [collecter; instance]) in applyTransforms rest instance
            | Default(defaulter) :: rest -> 
                let m = (getMethod <@ defaultArrayIfEmpty X X @>).MakeGenericMethod([|etype|])            
                let instance = Expr.Call(m, [defaulter; instance]) in applyTransforms rest instance
            | Function(updater) :: rest -> let instance = updater |> application instance in applyTransforms rest instance
            | Add (adder) :: rest -> 
                let m = (getMethod <@ addToArray X X @>).MakeGenericMethod([|etype|])          
                let instance = Expr.Call(m, [adder; instance]) in applyTransforms rest instance
            | Compare(compfun) :: rest -> 
                let instance = compfun |> applyCompare atype path origInstance instance in applyTransforms rest instance
              
        let copyArray funcs = 
            let copyfun = makeSingleArgCopyFunExpr rcs etype funcs path
            let m = (getMethod <@ Array.map X X @>).MakeGenericMethod([|etype; etype|])
            Expr.Call(m, [copyfun; origInstance])

        match funcs |> Map.tryFind path, funcs |> Map.remove path, rcs.CloneWhenNoChanges with    
        | None, _, false -> origInstance
        | None, _, true -> copyArray Map.empty 
        // Array of arrays, just move to the inner array
        | Some _, _, _ when etype.IsArray -> copyArray funcs 
        | Some transforms, newfuncs, _ -> applyTransforms transforms (copyArray newfuncs)

    and genMapCopier rcs (atype : Type) (funcs: FieldUpdaters) (path: string list) (origInstance: Expr) : Expr = 
        let (ktype, vtype) = 
            let arr = atype.GetGenericArguments()
            if arr.Length <> 2 then failwithf "Unexpected Params on Map Type: %A" arr
            arr.[0], arr.[1]

        let rec applyTransforms (funcs: FieldAction list) (instance: Expr) =
            match funcs with
            | [] -> instance
            | Map(updater) :: rest ->
                // Map from e -> e
                let m = (getMethod <@ mapMapValues X X @>).MakeGenericMethod([|ktype; vtype|])
                let instance = Expr.Call(m, [updater; instance]) in applyTransforms rest instance
            | Filter(filter) :: rest -> 
                let m = (getMethod <@ filterMap X X @>).MakeGenericMethod([|ktype; vtype|])            
                let instance = Expr.Call(m, [filter; instance]) in applyTransforms rest instance
            | Collect(_) :: _ -> failwith "Cannot collect on Map types"
            | Default(defaulter) :: rest -> 
                let m = (getMethod <@ defaultMapIfEmpty X X @>).MakeGenericMethod([|ktype; vtype|])            
                let instance = Expr.Call(m, [defaulter; instance]) in applyTransforms rest instance
            | Function(updater) :: rest -> let instance = updater |> application instance in applyTransforms rest instance
            | Add (adder) :: rest -> 
                let m = (getMethod <@ addMap X X @>).MakeGenericMethod([|ktype; vtype|])            
                let instance = Expr.Call(m, [adder; instance]) in applyTransforms rest instance
            | Compare(compfun) :: rest -> let instance = compfun |> applyCompare atype path origInstance instance in applyTransforms rest instance

        let copyMap funcs =
            let copyfun = makeSingleArgCopyFunExpr rcs (FSharpType.MakeTupleType([|ktype; vtype|])) funcs path
            let m = (getMethod <@ mapMapValues X X @>).MakeGenericMethod([|ktype; vtype|])
            Expr.Call(m, [copyfun; origInstance])

        match funcs |> Map.tryFind path, funcs |> Map.remove path, rcs.CloneWhenNoChanges with
        | None, _, false -> origInstance
        | None, _, true -> copyMap Map.empty 
        | Some transforms, newfuncs, _ -> applyTransforms transforms (copyMap newfuncs)

    and genUnionCopier rcs (utype: Type) (funcs: FieldUpdaters) (path: string list) (instance: Expr) : Expr = 
        // if - union case - then - copy each field into new case - else - next case
        let cases = FSharpType.GetUnionCases utype
        let genCaseTest case = Expr.UnionCaseTest (instance, case)
        let makeCopyCtor (ci: UnionCaseInfo) = 
            let copiedMembers = [ for field in ci.GetFields() -> genFieldCopy rcs instance field funcs path ]
            Expr.NewUnionCase(ci, copiedMembers)
        let genIf ifCase thenCase elseCase = Expr.IfThenElse(ifCase, thenCase, elseCase)
     
        match funcs |> Map.containsKey path, rcs.CloneWhenNoChanges with
        | _, true
        | true, _ ->                                             
            cases
            |> Array.map (fun case -> genIf (genCaseTest case) (makeCopyCtor case))
            |> Array.foldBack (fun iff st -> iff st) <| (getTypedException utype "Unexpected Case in Union")
        | false, false -> instance       


open Copiers
open Fungible.Paths
open Fungible.Helpers.Linq

let fillFieldUpdaterParents (fis: FieldUpdaters) =
    let rec inner (toProcess: (string list * FieldAction list) list) (fis: FieldUpdaters) =
        match toProcess with
        | h :: rest ->  
            match h with
            | _ :: pathRest, _ -> 
                match fis |> Map.containsKey pathRest with
                | true -> inner ((pathRest, []) :: rest) fis
                | false -> inner ((pathRest, []) :: rest) (fis |> Map.add pathRest [])
            | _ -> inner rest fis
        | [] -> fis
    inner (fis |> Map.toList) fis

/// <summary>
/// Given a collection of FieldUpdater transform produces a function which applies them to a F# type tree
/// </summary>
/// <param name="settings">Settings to control how the transforms are done</param>
/// <param name="updaters">The transforms to be applied to the F# type tree</param>
let genrateRecordTransformFunction<'T> settings (updaters: FieldUpdaters) : ('T -> 'T) = 
    let filledMappedFuncs = fillFieldUpdaterParents updaters
    let expr = makeSingleArgCopyFunExpr settings typeof<'T> filledMappedFuncs []
    let castExpr : Expr<'T -> 'T> = expr |> Expr.Cast
    let compiledExpr = (castExpr |> toLinq).Compile()
    fun (v : 'T) -> compiledExpr.Invoke(v)

/// <summary>
/// Like genrateRecordTransformFunction but allows the user to specify an additional argument 
/// </summary>
/// <param name="settings">Settings to control how the transforms are done</param>
/// <param name="replacmentVarName">The name of the placeholder Var name which will be swapped out</param>
/// <param name="updaters">The transforms to be applied to the F# type tree</param>
let genrateRecordTransformFunctionWithArgs<'U,'T> settings (replacmentVarName: string) (funcs: FieldUpdaters) : ('U -> 'T -> 'T) = 
    let rootArg = Var("root", typeof<'U>, false)
    let useRootArg = Expr.Var(rootArg)

    let mappedFuncs = 
        let subValFun (v: Var) : Expr option = 
            if v.Name = replacmentVarName then Some useRootArg
            else None
        funcs |> Map.map (fun _ v -> v |> List.map (fun fu -> fu.MapExpr(fun expr -> expr.Substitute(subValFun))))

    let filledMappedFuncs = fillFieldUpdaterParents mappedFuncs
    let contents = makeSingleArgCopyFunExpr settings typeof<'T> filledMappedFuncs []
    let lambda = Expr.Lambda(rootArg, contents)

    let castExpr : Expr<'U -> 'T -> 'T> = lambda |> Expr.Cast
   
    let compiledExpr = (castExpr |> toLinq2<'U,'T,'T>).Compile()
    fun (u: 'U) (v : 'T) -> compiledExpr.Invoke(u, v)
