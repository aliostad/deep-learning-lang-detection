module Scoper

open AlyoshaAST
open FunScopes
open VariablesInformation

open System.Collections.Generic

exception NotDefinedYetException of string

type StringConstantsDictionary (stringConstants : string []) =
    
    let constants = stringConstants
    let dict = 
        let res = new Dictionary<string, int>()
        for i = 0 to stringConstants.Length - 1 do
            res.[stringConstants.[i]] <- i
        res

    member this.Length = constants.Length
    member this.getString n = constants.[n]
    member this.getIndex s = dict.[s]

let GetScopes (ast : program) (tableOfSymbols : varIdInformation []) =
    let res = new ResizeArray<Scope>()
    let scopeNumber = ref -1
    let depthCounter = ref -1
    let mainScopeBlock = match ast with Program (_, _, x)-> x
    let stringConstants = new ResizeArray<string>()
    
    let rec makeScope naturalParameters (parentScope : int) (ownName : int) (corecursiveFunsArr : int []) (body : expression) =
        incr scopeNumber
        incr depthCounter
        let corecursiveFunDict = new CorecursiveFunDictionary(corecursiveFunsArr)

        let itsNumber = !scopeNumber
        res.Add null
        let usedVariables = new ResizeArray<(int * variableIdScopeRelationType)>()
        
        let rec processNaturalParameters = function
            | [] -> ()
            | np :: nps -> 
            tableOfSymbols.[np].ScopeInfo <- itsNumber
            usedVariables.Add (np, NaturalParameter)
            processNaturalParameters nps
        processNaturalParameters naturalParameters

        let usedVariablesSet =  ref (Set.ofList naturalParameters)

        let processInnerVariable tableId =
            usedVariablesSet := Set.add tableId !usedVariablesSet
            usedVariables.Add (tableId, InnerVariable)
            tableOfSymbols.[tableId].ScopeInfo <- itsNumber

        let processVariableId tableId =
            if (!usedVariablesSet).Contains tableId |> not then
                //if it was inner parameter, it would be there
                //so it can be own name, co-recursive fun or external parameter
                if tableId = ownName || corecursiveFunDict.ContainsCorecursiveName tableId then ()
                else 
                    usedVariables.Add(tableId, ExternalParameter)
                usedVariablesSet := Set.add tableId !usedVariablesSet

        let rec processBlock blk =
            unboxBlock blk |> List.iter processStatement

        and processStatement = function
            | Statement stmnt -> 
                match stmnt with
                | LetAssignment ass ->
                    match ass with
                    | UsualAssignment ((_, tableId), expr) ->
                        processInnerVariable !tableId
                        processStatement expr
                    | ReadNum (_, tableId) -> processInnerVariable !tableId
                    | ReadLine (_, tableId) -> processInnerVariable !tableId

                | LetRecursiveAssignment asss ->
                    let rec unzip4 = function
                    | [] -> ([], [], [], [])
                    | (a, b, c, d) :: t ->
                        let at, bt, ct, dt = unzip4 t
                        (a::at, b::bt, c::ct, d::dt)
                    let corecursiveIds, _, _, _ = unzip4 asss
                    let corecursiveIdArr = corecursiveIds |> List.map (fun (x, y) -> !y) |> Array.ofList
                    corecursiveIds |> List.iter
                        (fun (_, x) -> processInnerVariable !x)
                    for ((_, tableId), args, valueExpr, scopeId) in asss do
                        let newNaturalParameters = args |> List.map (fun (x,y) -> !y)
                        scopeId := !scopeNumber + 1
                        let newUsedVariables = makeScope  newNaturalParameters itsNumber !tableId corecursiveIdArr valueExpr
                        Set.iter processVariableId newUsedVariables
                    
                | Reassignment ass ->
                    match ass with
                    | UsualAssignment ((_, tableId), expr) ->
                        processVariableId !tableId
                        processStatement expr
                    | ReadNum (_, tableId) -> processVariableId !tableId
                    | ReadLine (_, tableId) -> processVariableId !tableId
                | IfStatement (condition, trueBlock, elifList, elseBlock) ->
                    processStatement condition
                    processBlock trueBlock
                    elifList |> List.iter 
                        (fun (x, y) ->
                            processStatement x
                            processBlock y
                        )
                    match elseBlock with
                    | Some eb -> processBlock eb
                    | None -> ()

                | WhileStatement (expr, whileBlock) ->
                    processStatement expr
                    processBlock whileBlock

                | WriteStatement expr -> processStatement expr
                | MatchStatement _ -> raise (NotDefinedYetException "Match statements in scoper")

            | OrList exprs
            | AndList exprs -> 
                exprs |> List.iter processStatement
            | Not expr -> processStatement expr
            | IsEqual (expr1, expr2)
            | NotEqual (expr1, expr2)
            | Greater (expr1, expr2)
            | Less (expr1, expr2)
            | NotGreater (expr1, expr2)
            | NotLess (expr1, expr2)
            | Mod (expr1, expr2) ->
                processStatement expr1
                processStatement expr2
            | Sum operands ->
                operands |> List.iter (fun (x, y) -> processStatement y)
            | Mult operands ->
                operands |> List.iter (fun (x, y) -> processStatement y)
            | StringConcat strings ->
                strings |> List.iter processStatement
            | SequenceExpression (Block x) ->
                x |> List.iter processStatement
            | ExprId (_, tableId) ->
                processVariableId !tableId
            | Abstraction (args, value, scopeId) -> 
                let newNaturalParameters = args |> List.map (fun (x,y) -> !y)
                scopeId := !scopeNumber + 1
                let newUsedVariables = makeScope newNaturalParameters itsNumber -1 [||] value
                Set.iter processVariableId newUsedVariables
            | Application (appF, args) ->
                processStatement appF
                args |> List.iter processStatement
            | Reference expr ->
                processStatement expr
            | Unref expr ->
                processStatement expr
            | NumVal _ -> ()
            | BoolVal _ -> ()
            | StringVal stringVal ->
                stringConstants.Add stringVal
            | UnitVal -> ()


        processStatement body

        let resScope = new Scope(itsNumber, body, !depthCounter, parentScope, ownName, corecursiveFunDict, List.ofSeq usedVariables)
        res.[itsNumber] <- resScope
        decr depthCounter
        !usedVariablesSet |> Set.filter (fun x -> tableOfSymbols.[x].ScopeInfo < itsNumber)
    
    makeScope [] -1 -1 [||] (SequenceExpression mainScopeBlock) |> ignore
    res.ToArray() , (new StringConstantsDictionary(stringConstants.ToArray()))
    