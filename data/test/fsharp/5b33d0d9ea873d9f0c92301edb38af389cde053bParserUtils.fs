module ParserUtils

open Common
open ParserAST
open Microsoft.FSharp.Text.Parsing

exception ParseError of string * int * int

let rhs (parseState: IParseState) i =
  let pos = parseState.InputEndPosition i
  (pos.Line + 1,pos.Column)

let checkSymbol ((id,position) : string * (int * int)) (matchingSymbol : string) =
  if id <> matchingSymbol then
    raise(ParseError(sprintf "Expected %s but given %s" matchingSymbol id,fst position, snd position))

let reportErrorAtPos (error : string) (parseState : IParseState) (i : int) =
  let position = rhs parseState i
  raise(ParseError(error,fst position,snd position))

let genericNamespace = "__generic"

let decomposeLiteral (arg : CallArg) =
  match arg with
  | Literal (l,_) -> l
  | _ ->  failwith "You can only use decomposeLiteral with literal arguments"

let buildArithExpr (opName : string) (left : ArithExpr) (right : ArithExpr) (pos : int * int) : ArithExpr =
  match opName with
  | "+" -> Add (left,right)
  | "/%" -> Sub (left,right)
  | "*" -> Mul (left,right)
  | "/" -> Div (left,right)
  | "%" -> Mod (left,right)
  | _ -> raise(ParseError(("Parse Error: invalid arithmetic operator"),fst pos,snd pos))

type TypeDeclOrName =
| Type of TypeDecl
| Name of string
with
  override this.ToString() =
    match this with
    | Type(t) -> t.ToString()
    | Name(s) -> s

let rec combineArgsAndRet args ret =
  match args with
  | Arrow(left,right,nested) -> 
      match right with
      | Arg _
      | _ ->
          Arrow(left,combineArgsAndRet right ret,false)
  | Zero
  | Arg _ -> Arrow(args,ret,false)

let rec splitAtElement (pred : 'a -> bool) (list : 'a list) : ('a list) * ('a list) =
  match list with
  | [] -> failwith "The provided element does not exist in the list"
  | x :: xs ->
      if pred x then
        [],xs
      else
        let left,right = splitAtElement pred xs
        (x :: left,right)

let getLeftAndRightArity (parsedArgs : TypeDeclOrName list) : int * int =
  let isName =
    fun arg ->
          match arg with
          | Name _ -> true
          | Type _ -> false
  let left,right =
    parsedArgs |> splitAtElement isName
  left |> List.filter (fun arg -> not (isName arg)) |> List.length,right |> List.filter (fun arg -> not (isName arg)) |> List.length

let opPos (parsedArgs : TypeDeclOrName list) : OpOrder =
  match parsedArgs with
  | [] -> Prefix
  | [Name _] -> Suffix
  | x :: xs ->
      match x with
      | Name _ -> Prefix
      | Type _ ->
          match xs.[xs.Length - 1] with
          | Name _ -> Suffix
          | _ -> Infix

let rec checkDecl (parsedArgs : TypeDeclOrName list) (row : int) (column : int) : string option * TypeDecl list =
  let n,tds =
    parsedArgs |> List.fold(fun (name,decls) x ->
                              match x with
                              | Type(decl) -> (name, decl :: decls)
                              | Name(n) ->
                                match name with 
                                | None -> (Some n,decls)
                                | Some _ ->
                                    raise(ParseError("Parse Error: duplicate function or data name definition", row, column))) (None,[])
  n,tds |> List.rev

let rec buildArgType (args : TypeDecl list) =
  match args with
  | [] -> Zero
  | [x] -> x
  | x :: xs ->
      match x with
      | Zero -> failwith "Invalid arg type in buildArgType"
      | _ -> x --> (buildArgType xs)

let buildDeclarationRecord opOrder name args ret pos gen priority associativity larity rarity =
  {
    Name = name
    FullType = combineArgsAndRet args ret
    Args = args
    Return = ret
    Order = opOrder
    Priority = priority
    Position = Position.Create(pos, "missing")
    Associativity = associativity
    Premises = []
    Generics = gen
    LeftArity = larity
    RightArity = rarity
  }

let processParsedArgs (parsedArgs : TypeDeclOrName list) (retType : TypeDecl) (row : int) (column : int) (gen : List<Id>) (priority : int option) (associativity : Associativity) =
  let opOrder = opPos parsedArgs
  let larity,rarity = getLeftAndRightArity parsedArgs
  let Some(name),args = checkDecl parsedArgs row column
  let argType = buildArgType args
  match priority with
  | Some priority when priority < 0 -> raise(ParseError("Priority cannot be negative",row,column))
  | Some priority ->
      buildDeclarationRecord opOrder {Namespace =  ""; Name = name} argType retType (row, column) gen priority associativity larity rarity
  | None ->
      buildDeclarationRecord opOrder {Namespace =  ""; Name = name} argType retType (row, column) gen -1 associativity larity rarity

let insertNamespaceAndFileName (program : Program) (fileName : string) : Program =  
  let nameSpace,imports,parsedProgram = program.Namespace,program.Imports,program.Program
  let rec processTypeDecl (g : List<Id>) (i : int) (t : TypeDecl) =
    match t with
    | Arrow(left,right,n) -> Arrow(processTypeDecl g i left,processTypeDecl g i right,n)
    | Arg(arg,gen) -> 
        Arg((processArg g i arg), gen |> List.map (processTypeDecl g i))
    | External(s,pos) -> External(s,{ pos with File = fileName })
    | Zero -> Zero

  and processSymbolDecl (decl : SymbolDeclaration) (i : int) =
    {
      decl with
        Name = { decl.Name with Namespace = nameSpace }
        FullType = processTypeDecl decl.Generics i decl.FullType
        Args = processTypeDecl decl.Generics i decl.Args
        Return = processTypeDecl decl.Generics i decl.Return
        Position = { decl.Position with File = fileName }
        Premises = decl.Premises |> List.map processPremise
        Generics = decl.Generics |> List.map (fun id -> { id with 
                                                            Name = id.Name + (string i) 
                                                            Namespace = nameSpace })
    }
  
  and processArg g i arg =
      match arg with
      | Literal(l,p) -> Literal(l, { p with File = fileName })
      | Id(id,p) -> 
          let nativeOpt = builtInTypes |> List.tryFind (fun x -> x = id.Name)
          match nativeOpt with
          | Some native ->
              Id({ id with Namespace = systemNamespace },{ p with File = fileName })
          | None ->
              if g |> List.contains(id) then
                Id({ id with Name = id.Name + (string i); Namespace = nameSpace },{ p with File = fileName })
              else
                Id({ id with Namespace = nameSpace },{ p with File = fileName })
      | NestedExpression(expr) -> NestedExpression(expr |> List.map (processArg g i))
      | _ -> failwith "Lambdas not parsed yet"
  
  and processArgs left right =
    let processedLeft = left |> List.map (processArg [] 0)
    let processedRight = right |> List.map (processArg [] 0)
    processedLeft,processedRight

  and processExpr (expr : ArithExpr) =
    match expr with
    | Add(left,right) -> Add (processExpr left,processExpr right)
    | Sub(left,right) -> Sub (processExpr left,processExpr right)
    | Mul(left,right) -> Mul (processExpr left,processExpr right)
    | Div(left,right) -> Div (processExpr left,processExpr right)
    | Mod(left,right) -> Mod (processExpr left,processExpr right)
    | Nested(expr) -> Nested(processExpr expr)
    | Value arg -> Value (processArg [] 0 arg)
  and processPremise (p : Premise) =
    match p with
    | Emit(args,res,position) ->
        Emit(args,{ res with Namespace = nameSpace },{ position with File = fileName })
    | Arithmetic(expr,res,position) ->
        Arithmetic(processExpr expr,{ res with Namespace = nameSpace },{ position with File = fileName })
    | FunctionCall(left,right) ->                
        FunctionCall(processArgs left right)
    | Bind(id,pos,arg) -> Bind({ id with Namespace = nameSpace },{ pos with File = fileName },processArg [] 0 arg)
    | Conditional(left,c,right) ->
        Conditional(processArg [] 0 left,c,processArg [] 0 right)
  let processConclusion (c : Conclusion) =
    match c with
    | ValueOutput(left,right) -> ValueOutput(processArgs left right)
    | _ -> failwith "Modules not supported yet"

  let processedDeclarations =
    parsedProgram.Declarations |> 
    List.mapi (fun i x -> (i,x)) |>
    List.map (fun (i,d) -> 
                match d with
                | Data(decl) -> Data(processSymbolDecl decl i)
                | Func(decl) -> Func(processSymbolDecl decl i)
                | TypeFunc(decl) -> TypeFunc(processSymbolDecl decl i)
                | TypeAlias(decl) -> TypeAlias(processSymbolDecl decl i))
  let processedRules =
    parsedProgram.Rules |> 
    List.map(fun r ->
              match r with
              | Rule(r) -> Rule({ Main = r.Main; Premises = r.Premises |> List.map processPremise; Conclusion = processConclusion r.Conclusion })
              | TypeRule(tr) -> TypeRule({ Main = tr.Main; Premises = tr.Premises |> List.map processPremise; Conclusion = processConclusion tr.Conclusion }))
  let processedSubTypes =
    parsedProgram.Subtyping |>
    List.map(fun (lt,rt) -> 
              match lt,rt with
              | Arg(leftArg,[]),Arg(rightArg,[]) -> Arg(processArg [] 0 leftArg,[]),Arg(processArg [] 0 rightArg,[])
              | _ -> failwith "Something went wrong while parsing the subtypes")
  
  { Namespace = nameSpace;Imports = imports;Program = { Declarations = processedDeclarations; Rules = processedRules; Subtyping = processedSubTypes} }
        
