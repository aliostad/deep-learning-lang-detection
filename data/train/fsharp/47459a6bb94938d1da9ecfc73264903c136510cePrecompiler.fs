module MCPU.MCPUPP.Parser.Precompiler

open MCPU.MCPUPP.Parser.SyntaxTree
open MCPU.MCPUPP.Parser.Analyzer
open MCPU
open System.Collections.Generic
open System


type IMVariable =
    {
        Name : string
        Type : SymbolVariableType
    }

type IMLabel = int

// everything is stack-based here (will be thrown onto the sya-stack)
type IMInstruction =
    | Halt
    | Call of string * int (* call <Name> <argc> *)
    | Ret
    | Inline of string
    | Ldci of int
    | Ldcf of float
    | Ldloc of int
    | Stloc of int
    | Ldarg of int
    | Starg of int
    | Malloc of VariableType
    | Delete
    | Ldlen
    | Ldaddrfld of IMVariable
    | Ldaddrarg of int
    | Ldaddrloc of int
    | Ldptra
    | Stptra
    | Ldptrv
    | Stptrv
    | Ldelem of VariableType
    | Stelem of VariableType
    | Ldptr of VariableType
    | Stptr of VariableType
    | Ldfld of IMVariable
    | Stfld of IMVariable
    | Nop
    | Cmp
    | FCmp
    | Label of IMLabel
    | Jmp of IMLabel
    | Jz of IMLabel
    | Jnz of IMLabel
    | Dup
    | Add
    | Sub
    | Mul
    | Div
    | Mod
    | Shr
    | Shl
    | Ror
    | Rol
    | Neg
    | Not
    | Or
    | And
    | Xor
    | Bool
    | Pow
    | Pop
    | FIcast
    | IFcast

type IMMethod =
    {
        Name : string
        ReturnType : VariableType
        Parameters : IMVariable list
        Locals : IMVariable list
        Body : IMInstruction list
    }
    member x.Signature =
        sprintf "%s %s(%s)" <| string x.ReturnType
                            <| x.Name
                            <| String.Join(", ", x.Parameters
                                                 |> List.map (fun p -> sprintf "%s %s" <| p.Name
                                                                                       <| p.Type.ToString()))

type IMProgram =
    {
        Fields : IMVariable list
        Methods : IMMethod list
    }

type IMVariableScope =
    | FieldScope of IMVariable
    | ArgumentScope of int
    | LocalScope of int

type VariableMappingDictionary = Dictionary<VariableDeclaration, IMVariableScope>

let TypeOf = function
                | Unit -> typeof<Void>
                | Int -> typeof<int>
                | Float -> typeof<float32>
    
let CreateIMVariable = function
                       | ScalarDeclaration (t, i) ->
                            {
                                Type = {
                                            Type = t
                                            Cover = Scalar
                                       }
                                Name = i
                            }
                       | ArrayDeclaration (t, i) ->
                            {
                                Type = {
                                            Type = t
                                            Cover = VariableCoverType.Array
                                       }
                                Name = i
                            }
                       | PointerDeclaration (t, i) ->
                            {
                                Type = {
                                            Type = t
                                            Cover = Pointer
                                       }
                                Name = i
                            }

type IMMethodBuilder (analyzerres : AnalyzerResult, mapping : VariableMappingDictionary) =
    let mutable argndx = 0
    let mutable locndx = 0
    let mutable lblndx = 0
    let arrassgnloc = Dictionary<Expression, int>()
    let ptrassgnloc = Dictionary<Expression, int>()
    let endwhilelbl = Stack<IMLabel>()
    
    let BrTrue l = [
                       Cmp
                       Jnz l
                   ]
    let BrFalse l = [
                        Cmp
                        Jz l
                    ]

    let LookupIMVariableScope id =
        let decl = analyzerres.SymbolTable.[id]
        mapping.[decl]

    let CreateIMLabel() =
        let res = lblndx
        lblndx <- lblndx + 1
        res
    
    let ProcessIdentifierLoad id = function
                                   | FieldScope v -> [Ldfld v]
                                   | ArgumentScope i -> [Ldarg i]
                                   | LocalScope i -> [Ldloc i]
                                  <| LookupIMVariableScope id

    let ProcessIdentifierStore id = function
                                    | FieldScope v -> [Stfld v]
                                    | ArgumentScope i -> [Starg i]
                                    | LocalScope i -> [Stloc i]
                                   <| LookupIMVariableScope id

    let rec ProcessExpr expr =  match expr with
                                | ScalarAssignmentExpression (i, e) ->
                                    [
                                        ProcessExpr e
                                        [Dup]
                                        ProcessIdentifierStore i
                                    ]
                                | ArrayAssignmentExpression (i, e1, e2) as ae ->
                                    [
                                        ProcessIdentifierLoad i
                                        ProcessExpr e1
                                        ProcessExpr e2
                                        [
                                            Dup
                                            Stloc arrassgnloc.[ae]
                                            Stelem (analyzerres.SymbolTable.GetIdentifierType i).Type
                                            Ldloc arrassgnloc.[ae]
                                        ]
                                    ]
                                | ArraySizeExpression i ->
                                    [
                                        ProcessIdentifierLoad i
                                        [Ldlen]
                                    ]
                                | ArrayAllocationExpression (t, e) ->
                                    [
                                        ProcessExpr e
                                        [Malloc t]
                                    ]
                                | ArrayDeletionExpression i ->
                                    [
                                        ProcessIdentifierLoad i
                                        [Delete]
                                    ]
                                | ArrayIdentifierExpression (i, e) ->
                                    [
                                        ProcessIdentifierLoad i
                                        ProcessExpr e
                                        [Ldelem (analyzerres.SymbolTable.GetIdentifierType i).Type]
                                    ]
                                | IdentifierExpression i -> [ProcessIdentifierLoad i]
                                | RawAddressOfExpression i ->
                                    [
                                        function
                                        | FieldScope v -> [Ldaddrfld v]
                                        | ArgumentScope i -> [Ldaddrarg i]
                                        | LocalScope i -> [Ldaddrloc i]
                                       <| LookupIMVariableScope i
                                    ]
                                | PointerAddressIdentifierExpression i ->
                                    [
                                        ProcessIdentifierLoad i
                                        [Ldptra]
                                    ]
                                | PointerValueIdentifierExpression i ->
                                    [
                                        ProcessIdentifierLoad i
                                        [Ldptrv]
                                    ]
                                | PointerAssignmentExpression (i, e) ->
                                    [
                                        ProcessIdentifierLoad i
                                        ProcessExpr e
                                        [Stptra]
                                    ]
                                | PointerValueAssignmentExpression (i, e) ->
                                    [
                                        ProcessIdentifierLoad i
                                        ProcessExpr e
                                        [Stptrv]
                                    ]
                                | FunctionCallExpression (i, a) ->
                                    [
                                        List.collect ProcessExpr a
                                        [Call(i, a.Length)]
                                    ]
                                | LiteralExpression l ->
                                    match l with
                                    | IntLiteral i -> [[Ldci i]]
                                    | FloatLiteral f -> [[Ldcf f]]
                                | BinaryExpression (e1, op, e2) -> ProcessBinExpr e1 op e2
                                | UnaryExpression (op, e) ->
                                    [
                                        ProcessExpr e
                                        ProcessUnOp op
                                    ]
                                |> List.concat
    and ProcessBinExpr l op r = [
                                    ProcessExpr l
                                    ProcessExpr r
                                    ProcessBinOp op
                                ]
    and ProcessBinOp = function
                       | BinaryOperator.And -> [And]
                       | BinaryOperator.Or -> [Or]
                       | BinaryOperator.Xor -> [Xor]
                       | BinaryOperator.Add -> [Add]
                       | BinaryOperator.Divide -> [Div]
                       | BinaryOperator.Multiply -> [Mul]
                       | BinaryOperator.Modulus -> [Mod]
                       | BinaryOperator.Subtract -> [Sub]
                       | BinaryOperator.Power -> [Pow]
                       | BinaryOperator.ShiftLeft -> [Shl]
                       | BinaryOperator.ShiftRight -> [Shr]
                       | BinaryOperator.RotateLeft -> [Rol]
                       | BinaryOperator.RotateRight -> [Ror]
                       | BinaryOperator.Equal -> [
                                                    Cmp
                                                    Ldci 0x0800
                                                    And
                                                    Bool
                                                 ]
                       | BinaryOperator.NotEqual -> [
                                                        Cmp
                                                        Ldci 0x0800
                                                        And
                                                        Not
                                                        Bool
                                                    ]
                       | BinaryOperator.Greater -> [
                                                       Cmp
                                                       Ldci 0x0200
                                                       And
                                                       Bool
                                                   ]
                       | BinaryOperator.GreaterEqual -> [
                                                            Cmp
                                                            Ldci 0x0200
                                                            Xor
                                                            Ldci 0x0200
                                                            And
                                                            Not
                                                            Bool
                                                        ]
                       | BinaryOperator.Less -> [
                                                    Cmp
                                                    Ldci 0x0400
                                                    And
                                                    Bool
                                                ]
                       | BinaryOperator.LessEqual -> [
                                                         Cmp
                                                         Ldci 0x0400
                                                         Xor
                                                         Ldci 0x0400
                                                         And
                                                         Not
                                                         Bool
                                                     ]
                       | _ as op -> raise <| Errors.InvalidOperator op
    and ProcessUnOp = function
                      | LogicalNegate -> [Not]
                      | Negate -> [Neg]
                      | Identity -> [Nop]
                      | IntConvert -> [IFcast]
                      | FloatConvert -> [FIcast]
                      | BooleanConvert -> [Bool]
    and ProcessStatement = function
                           | ExpressionStatement x ->
                                match x with
                                | Expression x ->
                                    List.concat [
                                                    ProcessExpr x
                                                    [(if analyzerres.ExpressionTypes.[x].Type <> Unit then Pop else Nop)]
                                                ]
                                | ExpressionStatement.Nop -> [Nop]
                           | BlockStatement (_, s) -> List.collect ProcessStatement s
                           | IfStatement (e, s1, Some s2) ->
                                let lb_then = CreateIMLabel()
                                let lb_end = CreateIMLabel()
                                List.concat [
                                                ProcessExpr e
                                                BrTrue lb_then
                                                ProcessStatement s2
                                                [
                                                    Jmp lb_end
                                                    Label lb_then
                                                ]
                                                ProcessStatement s1
                                                [
                                                    Label lb_end
                                                ]
                                            ]
                           | IfStatement (e, s, None) ->
                                let lb_then = CreateIMLabel()
                                let lb_end = CreateIMLabel()
                                List.concat [
                                                ProcessExpr e
                                                BrTrue lb_then
                                                [
                                                    Jmp lb_end
                                                    Label lb_then
                                                ]
                                                ProcessStatement s
                                                [
                                                    Label lb_end
                                                ]
                                            ]
                           | WhileStatement (e, s) ->
                                let lb_start = CreateIMLabel()
                                let lb_cond = CreateIMLabel()
                                let lb_end = CreateIMLabel()
                                endwhilelbl.Push lb_end
                                let instr = List.concat [
                                                            [
                                                                Jmp lb_cond
                                                                Label lb_start
                                                            ]
                                                            ProcessStatement s
                                                            [
                                                                Label lb_cond
                                                            ]
                                                            ProcessExpr e
                                                            BrTrue lb_start
                                                            [
                                                                Label lb_end
                                                            ]
                                                        ]
                                endwhilelbl.Pop()
                                |> ignore
                                instr
                           | BreakStatement -> [Jmp <| endwhilelbl.Peek()]
                           | ReturnStatement x ->
                                match x with
                                | Some x -> ProcessExpr x
                                | None -> []
                                @ [Ret]
                           | InlineAsmStatement asm -> [Inline asm.Code]

    let ProcessVarDecl (mdnx : byref<_>) f decl =
        let v = CreateIMVariable decl
        mapping.Add(decl, f mdnx)
        mdnx <- mdnx + 1
        v
    
    let ProcessLocalDecl decl = ProcessVarDecl &locndx LocalScope decl
    
    let ProcessParamDecl decl = ProcessVarDecl &argndx ArgumentScope decl

    let rec CollectLocalVarDecl stat =
        let rec FromStatement = function
                                | ExpressionStatement es -> match es with
                                                            | Expression e -> FromExpr e
                                                            | ExpressionStatement.Nop -> []
                                | BlockStatement (vars, stat) ->
                                    List.concat [
                                                    vars |> List.map ProcessLocalDecl
                                                    stat |> List.collect CollectLocalVarDecl
                                                ]
                                | IfStatement (e, s1, s2) ->
                                    List.concat [
                                                    FromExpr e
                                                    CollectLocalVarDecl s1
                                                    (match s2 with
                                                     | Some s2 -> CollectLocalVarDecl s2
                                                     | None -> [])
                                                ]
                                | WhileStatement (e, s) ->
                                    List.concat [
                                                    FromExpr e
                                                    CollectLocalVarDecl s
                                                ]
                                | ReturnStatement (Some e) -> FromExpr e
                                | _ -> []
        and FromExpr = function
                       | ScalarAssignmentExpression (_, e) -> FromExpr e
                       | ArrayAssignmentExpression (i, e1, e2) as ae ->
                            let v = {
                                        Type = analyzerres.SymbolTable.GetIdentifierType i
                                        Name = "arrassgntmp_" + string locndx
                                    }
                            arrassgnloc.Add(ae, locndx)
                            locndx <- locndx + 1
                            [v] @ FromExpr e2
                       | BinaryExpression (l, _, r) -> List.concat [ FromExpr l; FromExpr r ]
                       | UnaryExpression (_, e) -> FromExpr e
                       | ArrayIdentifierExpression (_, e) -> FromExpr e
                       | FunctionCallExpression (_, a) -> List.collect FromExpr a
                       | ArrayAllocationExpression (_, e) -> FromExpr e
                       | PointerAssignmentExpression (_, e) -> FromExpr e
                       | PointerValueAssignmentExpression (_, e) -> FromExpr e
                       | _ -> []
        FromStatement stat
    
    member x.BuildMethod (ret, name, param, (locdecl, stats)) =
        {
            Name = name
            ReturnType = ret
            Parameters = param
                         |> Array.map ProcessParamDecl
                         |> Array.toList
            Locals = List.concat [
                                    List.map ProcessLocalDecl locdecl
                                    List.collect CollectLocalVarDecl stats
                                 ]
            Body = List.collect ProcessStatement stats
        }

type IMBuilder (analyzerres) =
    let mapping = VariableMappingDictionary HashIdentity.Reference

    let ProcessGlobalVarDecl decl =
        let v = CreateIMVariable decl
        mapping.Add(decl, FieldScope v)
        v
    
    let ProcessFuncDecl func =
        let mb = IMMethodBuilder(analyzerres, mapping)
        mb.BuildMethod func

    member x.BuildClass (program : Program) =
        let vardecl = program
                      |> List.choose (function
                                      | GlobalVarDecl x -> Some x
                                      | _ -> None)
                      |> List.map ProcessGlobalVarDecl
        let funcdecl = program
                       |> List.choose (function
                                      | FunctionDeclaration x -> Some x
                                      | _ -> None)
                       |> List.map ProcessFuncDecl

        if (List.where (fun f -> (f.Name = EntryPointName)
                              && (f.Parameters.Length = 0)
                              && (f.ReturnType = Unit)) funcdecl).Length <= 0 then
            raise <| Errors.InvalidMainSignature()
        else
            {
                Fields = vardecl
                Methods = funcdecl
            }

do
    ()
