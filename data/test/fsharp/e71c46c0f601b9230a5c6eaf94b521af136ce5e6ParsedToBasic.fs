module ParsedToBasic
open BasicAST
open CasanovaCompiler.ParseAST
open System
open Common

let rec private traverseProgram (program : CasanovaCompiler.ParseAST.Program) =
  let world, entities, imports = traverseWorldOrEntityDecls program.WorldOrEntityDecls
  {
    Module    = { idText = program.ModuleStatement.Lid.Tail |> Seq.fold(fun s t -> s + "." + t.idText) program.ModuleStatement.Lid.Head.idText; idRange = Position.Empty } 
    ReferencedLibraries = program.ReferencedLibraries
    Imports   = imports
    World     = world
    Entities  = entities
  }  
and private traverseWorldOrEntityDecls (worldOrEntityDecls : SynModuleDecl list) =
  let opens = 
    [for decl in worldOrEntityDecls do 
      match decl with
      | SynModuleDecl.Open (longIdentWithDots, position) -> yield traverseLongIdentWithDots longIdentWithDots
      | _ -> ()]
  let world =
    match 
      [for decl in worldOrEntityDecls do 
        match decl with
        | SynModuleDecl.Types(synTypeDefns, position) when synTypeDefns.Length > 0 ->
          let id, body = traverseSynTypeDefn (fst synTypeDefns.Head)
          let world : World =
            { Name      = id
              Body      = body }        
          yield world
        | _ -> ()] with    
    | [] -> raise Position.Empty (sprintf "Program without World. Internal error at %s(%s)" __SOURCE_FILE__ __LINE__)
    | x :: xs -> x
  let entities =
    match 
      [for decl in worldOrEntityDecls do 
        match decl with
        | SynModuleDecl.Types(synTypeDefns, position) when synTypeDefns.Length > 0 ->
          yield!
            [for synTypeDefn in synTypeDefns do
              let id, body = traverseSynTypeDefn (fst synTypeDefn)
              let entity : Entity =
                { Name      = id
                  Body      = body }        
              yield entity]
        | _ -> ()] with    
    | [] -> raise Position.Empty (sprintf "Program without world. Internal error at %s(%s)" __SOURCE_FILE__ __LINE__)
    | x::xs -> xs
  world, entities, opens

and private traverseSynTypeDefn (synTypeDefn : SynTypeDefn) : Id * EntityBody =
  let (TypeDefn(longIdent, synTypeDefnRepr, synMemberDefns, inherits, position)) = synTypeDefn

//  if inherits.Length > 1 then failwith (Common.Position synTypeDefn.Range) "Multiple inheritance not supported."

  let id = traverseLongIdent longIdent
  let inherits = inherits |> List.map(fun ident -> { idText = ident.idText; idRange = id.idRange} )
  let fields = traverseSynTypeDefnRepr inherits synTypeDefnRepr
  let rules, create = traverseSynMemberDefns inherits fields synMemberDefns
  let body =
    {
      Inherits  = inherits
      Fields    = fields
      Rules     = rules
      Create    = create
    }

  id, body

and private traverseSynMemberDefns (inherited_types : List<Id>) (fields : List<Field>) (synMemberDefns : SynMemberDefns) : List<Rule> * Create =
  let mutable _create = None
  let mutable _rules = []
  for synMemberDefn in synMemberDefns do
    let (SynMemberDefn.Member(synBinding, position, flags)) =  synMemberDefn
    let (Binding(synPat, synExpr, _, position)) = synBinding
    let pat = traverseSynPatDomain synPat
    if pat <> [] then      
      let expr = traverseSynExprBlock synExpr
      if expr.Length = 0 then raise (Common.Position synMemberDefn.Range) (sprintf "Rule without body.")
      if Common.is_networked_game |> not then
        for flag in flags do
          match flag with
          | CasanovaCompiler.ParseAST.Flag.Connecting
          | CasanovaCompiler.ParseAST.Flag.Connected
          | CasanovaCompiler.ParseAST.Flag.Master
          | CasanovaCompiler.ParseAST.Flag.Slave -> Common.is_networked_game <- true

      _rules <- {Domain = pat; Body = expr; Flags = flags} :: _rules
    else
      let create_pat = traverseCreateSynPatDomain synPat
      let expr = traverseSynExprBlock synExpr

      let expr =
        match expr |> List.rev with
//        | [] -> 
//          raise (Common.Position synMemberDefn.Range) (sprintf "Crate without body")          
        | return_expr :: expr ->
        
          match return_expr with
          | Expression.NewEntity(elems) ->
            let found_base = ref false
            let res = 
              [for elem,b in elems do
                if elem.idText = "Base" ||
                   (not inherited_types.IsEmpty && inherited_types |> Seq.exists(fun t -> t.idText = elem.idText)) then                   
                  if inherited_types.IsEmpty then failwith elem.idRange "'Base' keyword reserved" |> ignore
                  else 
                    found_base := true
                    if inherited_types.Length = 1 then
                      yield {Common.idText = inherited_types.Head.idText; Common.idRange = elem.idRange}, b
                    else
                      if elem.idText = "Base" then failwith elem.idRange "Ambiguous use of the 'Base' keyword" |> ignore
                      else yield {Common.idText = (inherited_types |> Seq.find(fun t -> t.idText = elem.idText)).idText; Common.idRange = elem.idRange}, b
                else 
                  yield elem, b
              ]


            let res : (Id * Block) list =              
              if not inherited_types.IsEmpty && not !found_base then 
                ({Common.idText = inherited_types.Head.idText; Common.idRange = inherited_types.Head.idRange},
                 [Expression.Call(Static(TypeDecl.Imported({idText = inherited_types.Head.idText; idRange = inherited_types.Head.idRange}, 
                                                           TypeDecl.Tuple([])),
                                         None,
                                         []))]) :: res
              else res
//            let res = res @ inherited_fields
            Expression.NewEntity(res) :: expr |> List.rev

      _create <- Some 
          {
            Args  = create_pat
            Body  = expr
            Position = expr.Head.Position
          }
  match _rules, _create with
  | rules, None -> 
    let p : Common.Position = Position.Empty
    let res =
      {
        Args  = []
        Body  = [Expression.NewEntity([for f in fields do
                                        let v = 
                                          match f.Type with
                                          | BasicAST.TypeDecl.Imported(id, t) when id.idText = "int" -> Literal(Literal.Int(0, p))
                                          | BasicAST.TypeDecl.Imported(id, t) when id.idText = "float32" ||
                                                                                   id.idText = "float"  -> Literal(Literal.Float(0.0f, p))
                                          | BasicAST.TypeDecl.Imported(id, t) when id.idText = "bool" -> Literal(Literal.Bool(false, p))
                                          | BasicAST.TypeDecl.Imported(id, t) when id.idText = "string" -> Literal(Literal.String("", p))
                                          | BasicAST.TypeDecl.Imported(id, t) -> 
                                            Expression.Call(Static(TypeDecl.Imported({idText = id.idText; idRange = p}, TypeDecl.Tuple([])), None, []))
                                          | BasicAST.TypeDecl.TypeName(id) -> BasicAST.Expression.Call(BasicAST.MaybeInstance(id,{idText = "create"; idRange = p},[]))
                                          | BasicAST.TypeDecl.TypeMaybe(t) -> Expression.Maybe(Maybe.Nothing(t.Position))
                                          | BasicAST.TypeDecl.Query(TypeDecl.Tuple(t)) -> Expression.Query([Empty(Some (TypeDecl.Tuple(t)), p)])
                                          | BasicAST.TypeDecl.Query(t) -> Expression.Query([Empty(Some(BasicAST.Tuple([t])), p)])
                                          | _ -> failwith f.Position "Default constructor error."
                                        yield f.Name, [v]])]
        Position = Position.Empty
      }
    rules, res
    
//    raise(None, NotSupportedConstructError("Missing create.", synMemberDefns))
  | rules, Some create -> rules, create

and traverseTypeId (_type : string) p : TypeDecl =  
  match _type with
  | id when id = "float" -> 
              TypeDecl.Imported(({idText = "float32"; idRange = p}), 
                                TypeDecl.Tuple([]))
  | id when id = "bool" || id = "int" || id = "string" -> 
              TypeDecl.Imported(({idText = id; idRange = p}), 
                                TypeDecl.Tuple([]))
  | id -> TypeName({idText = id; idRange = p})

and traverseType (_type : SynType) : TypeDecl =  
  match _type with
  | SynType.LongIdent(longIdentWithDots) when longIdentWithDots.Lid.Length = 1 &&
                                              longIdentWithDots.Lid.Head.idText = "float" -> 
                                                TypeDecl.Imported(({idText = "float32"; idRange = Position longIdentWithDots.Lid.Head.idRange}), 
                                                                  TypeDecl.Tuple([]))
 
  | SynType.LongIdent(longIdentWithDots) when longIdentWithDots.Lid.Length = 1 &&
                                              longIdentWithDots.Lid.Head.idText = "bool" ||
                                              longIdentWithDots.Lid.Head.idText = "int" ||
                                              longIdentWithDots.Lid.Head.idText = "string" -> 
                                                TypeDecl.Imported(({idText = longIdentWithDots.Lid.Head.idText; idRange = Position longIdentWithDots.Lid.Head.idRange}), 
                                                                  TypeDecl.Tuple([]))
  | SynType.LongIdent(longIdentWithDots) -> TypeName(traverseLongIdentWithDots longIdentWithDots)
  | SynType.App(SynType.LongIdent(LongIdentWithDots([ident],[])), _, args, _, _, _,_) when  ident.idText.ToLower() = "option" && args.Length = 1 ->
    TypeDecl.TypeMaybe(traverseType args.[0])    
  | SynType.App(SynType.LongIdent(LongIdentWithDots([ident],[])), _, args, _, _, _,_) when  ident.idText.ToLower() = "option" && args.Length > 1 ->
    TypeDecl.TypeMaybe(TypeDecl.Tuple([for arg in args do yield traverseType arg]))
  | SynType.App(SynType.LongIdent(LongIdentWithDots([ident],[])), _, args, [], _, _,_) when  ident.idText = "list" && args.Length > 1 ->
    TypeDecl.Query(TypeDecl.Tuple([for arg in args do yield traverseType arg]))    
  | SynType.App(SynType.LongIdent(LongIdentWithDots([ident],[])), _, [arg], [], _, _,_) when  ident.idText.ToLower() = "list" -> TypeDecl.Query(traverseType arg)    
  | SynType.App(typeName, lessM, typeArgs, commasm, greaterM, isPostfix, p) ->
    let typeName : TypeDecl = traverseType typeName
    let typeArgs = TypeDecl.Tuple(typeArgs |> List.map traverseType)
    match typeName with
    | TypeDecl.TypeName(id) -> TypeDecl.Imported(id, typeArgs)
    | _ -> raise (Position p) "Irregular type application. "
  | SynType.Tuple(synType_list, position) ->  TypeDecl.Tuple(synType_list |> List.map(fun (_, t) -> traverseType t))
  | SynType.Array(dim, synType, position) -> TypeDecl.Query(traverseType synType)
  | SynType.Fun(_, _, p) -> raise (Position p) "Functionals types not supported. "
  | SynType.Anon(p) -> raise (Position p) "Anon types not supported. "
  | SynType.MeasureDivide(_, _, p) -> raise (Position p) "Measure types not supported. "
  | SynType.MeasurePower(_, _, p) -> raise (Position p) "Measure types not supported. "
  | SynType.StaticConstant(_, p) -> raise (Position p) "Static constant types not supported. "

//and private traverseOpenLongIdentWithDots longIdentWithDots : ImportedType =
//  let string = longIdentWithDots.Lid |> List.map(fun id -> id.idText) |> List.reduce(fun a b -> a + "." + b)
//  System.Type.GetType(string), longIdentWithDots.Range
and private tupleOrUnitToList expr =
  match traverseSynExprBlock expr with 
  | [BasicAST.Expression.Literal(BasicAST.LUnit(_))] -> [] 
  | [BasicAST.Expression.Tuple(expr)] -> [for expr in expr do yield! expr ] 
  | args -> args
and private traverseQuery (expr : SynExpr) : List<InnerQueryExpression> =
  let rec traverse_expr expr =
      match expr with
      | SynExpr.Sequential(_,_,e1,e2,_) ->
        traverseSynExpr e1 :: (traverse_expr e2)
      | _ -> [traverseSynExpr expr]    
  [InnerQueryExpression.LiteralList(traverse_expr expr)]

and private traverseSynExpr (synExpr : SynExpr) : Expression =
  match synExpr with
  //The order is if much importance. Do not exchange the cases.
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_BooleanAnd" ->
    Expression.And(traverseSynExpr expr1, traverseSynExpr expr2)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_BooleanOr" ->
    Expression.Or(traverseSynExpr expr1, traverseSynExpr expr2)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_Equality" ->
    Expression.Equals(traverseSynExpr expr1, traverseSynExpr expr2)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_Inequality" ->
    Expression.Not(Expression.Equals(traverseSynExpr expr1, traverseSynExpr expr2))  
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_GreaterThanOrEqual" ->
    Expression.Or(Expression.Greater(traverseSynExpr expr1, traverseSynExpr expr2),
                         Expression.Equals(traverseSynExpr expr1, traverseSynExpr expr2))  
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_LessThanOrEqual" ->
    Expression.Not(Expression.Greater(traverseSynExpr expr1, traverseSynExpr expr2))
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_LessThan" ->
    Expression.Greater(traverseSynExpr expr2, traverseSynExpr expr1)
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1) when ident.idText = "not" ->
    Expression.Not(traverseSynExpr expr1)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_GreaterThan" ->
    Expression.Greater(traverseSynExpr expr1, traverseSynExpr expr2)

  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_Addition" ->
    Expression.Add(traverseSynExpr expr1, traverseSynExpr expr2)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_Subtraction" ->
    Expression.Sub(traverseSynExpr expr1, traverseSynExpr expr2)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_Multiply" ->
    Expression.Mul(traverseSynExpr expr1, traverseSynExpr expr2)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_Division" ->
    Expression.Div(traverseSynExpr expr1, traverseSynExpr expr2)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), expr1, p1), expr2, p2) when ident.idText = "op_Modulus" ->
    Expression.Modulus(traverseSynExpr expr1, traverseSynExpr expr2)

  | SynExpr.Const(SynConst.Bool(b), p) -> Expression.Literal(Literal.Bool(b,Position p))
  | SynExpr.Const(SynConst.Single(s), p) -> Expression.Literal(Literal.Float(s, Position p))
  | SynExpr.Const(SynConst.Int32(n), p) -> Expression.Literal(Literal.Int(n, Position p))
  | SynExpr.Const(SynConst.String(s, _), p) -> Expression.Literal(Literal.String(s, Position p))
  | SynExpr.Const(SynConst.Unit(_), p) -> Expression.Literal(Literal.LUnit(Position p))
  | SynExpr.Const(SynConst.Double(_), p) -> raise (Position p) "Double values are not allowed (syntax: 1.30f, 1.40e10f etc.)."
  | SynExpr.Const(SynConst.Char(_), p) -> raise  (Position p) "Char values are not allowed (syntax: 'a')."
  | SynExpr.Const(SynConst.Byte(_), p) -> raise (Position p) "Byte values are not allowed (syntax: 13uy, 0x40uy, 0oFFuy, 0b0111101uy)."
  | SynExpr.Const(SynConst.Measure(_, _), p) -> raise (Position p)  "Measure values are not allowed."
  | SynExpr.Tuple(synExpr_list, _, position) -> Expression.Tuple([for e in synExpr_list do yield (traverseSynExprBlock e)])
  | SynExpr.IfThenElse(synExpr1, synExpr2, None, _, _, p, _) ->
    Expression.IfThen(traverseSynExpr synExpr1, traverseSynExprBlock synExpr2)
  | SynExpr.IfThenElse(synExpr1, synExpr2, Some synExpr3, _, _, p, _) ->
    Expression.IfThenElse(traverseSynExpr synExpr1, traverseSynExprBlock synExpr2, traverseSynExprBlock synExpr3)     
  | SynExpr.Paren(synExpr, _, _, _) -> traverseSynExpr synExpr
  | SynExpr.Typed(synExpr, synType, _) -> traverseSynExpr synExpr
  | SynExpr.ArrayOrListOfSeqExpr(_,SynExpr.CompExpr(_ ,_ , 
                                                    SynExpr.ForEach(info, seqExprOnly, bool, synPat, synExpr1, synExpr2, position),
                                                    crange), range) -> 
    let expr = SynExpr.ForEach(info, seqExprOnly, bool, synPat, synExpr1, synExpr2, position)
    Expression.Query((traverseQueryExpression expr))
  | SynExpr.App(_, _, SynExpr.Ident(id), synexpr2, position) when id.idText = "Some" -> Expression.Maybe(Maybe.Just(traverseSynExpr synexpr2))
  | SynExpr.Ident(ident) when ident.idText = "None"-> Expression.Maybe(Maybe.Nothing(Position ident.idRange))
  | SynExpr.Ident(ident) -> 
    
    Expression.Id({idText = ident.idText; idRange = Position ident.idRange})
  | SynExpr.LongIdent(_, longIdent, _, position) -> Expression.Id(traverseLongIdentWithDots longIdent)  

  | SynExpr.App(_, _, SynExpr.Ident(id), SynExpr.Tuple([e1; e2], _, _), p2) when id.idText = "op_ColonColon" ->

    Expression.AppendToQuery (traverseSynExpr e1, traverseSynExpr e2)
  | SynExpr.App(_, _, SynExpr.Ident(id), synexpr2, position) ->
    let res = 
      Expression.Call(Static(TypeDecl.Imported({idText = id.idText; idRange = Position id.idRange}, 
                                               TypeDecl.Tuple([])),
                                    None,
                                    tupleOrUnitToList synexpr2))
    res
  | SynExpr.App(_, _, SynExpr.LongIdent(_, LongIdentWithDots(lid,p), _, _), synexpr2, position) when lid.Length > 1 ->

    let id, _method = lid |> Seq.take(lid.Length - 1) |> Seq.map(fun a -> a.idText) |> Seq.reduce(fun a b -> a + "." + b), 
                      lid |> Seq.skip(lid.Length - 1) |> Seq.head
    let res = 
      Expression.Call(MaybeInstance({idText = id; idRange = Position position},
                                    ({idText = _method.idText; idRange = Position _method.idRange}),
                                    tupleOrUnitToList synexpr2))
    res
  | SynExpr.App(_, _, SynExpr.TypeApp(SynExpr.Ident(ident), position, synType_list, _, _, _, _), synexpr2, _) ->
    let res = 
      Expression.Call(Static(TypeDecl.Imported({idText = ident.idText; idRange = Position ident.idRange}, 
                                               TypeDecl.Tuple([for t in synType_list do yield traverseType t])),
                             None,
                             tupleOrUnitToList synexpr2))

    res
  | SynExpr.App(_, _, SynExpr.TypeApp(SynExpr.LongIdent(_, LongIdentWithDots(lid,p), _, _), position, synType_list, _, _, _, _), synexpr2, _) ->
    let firsts, last = lid |> List.rev |> List.tail|> List.rev, lid |> List.rev |> List.head

    let res = 
      Expression.Call(Static(TypeDecl.Imported(traverseLongIdentWithDots (LongIdentWithDots(lid,p)), 
                                               TypeDecl.Tuple([for t in synType_list do yield traverseType t])),
                             Some ({idText = last.idText; idRange = Position last.idRange}),
                             tupleOrUnitToList synexpr2))
    res

  | SynExpr.App(_, _, SynExpr.DotGet( SynExpr.TypeApp(SynExpr.LongIdent(_, LongIdentWithDots(type_name,t_p), _, _), _, parameters, _, _, _, _), _, method_name, p), args, _) when method_name.Lid.Length = 1 ->
    let res = 
      Expression.Call(Static(TypeDecl.Imported(traverseLongIdentWithDots (LongIdentWithDots(type_name,t_p)), 
                                               TypeDecl.Tuple([for t in parameters do yield traverseType t])),
                             Some ({idText = method_name.Lid.Head.idText; idRange = Position method_name.Lid.Head.idRange}),
                             tupleOrUnitToList args))
    res
  | SynExpr.App(_, _, SynExpr.DotGet( SynExpr.TypeApp(SynExpr.Ident(type_name), _, parameters, _, _, _, _), _, method_name, p), args, _) when method_name.Lid.Length = 1 ->
    let res = 
      Expression.Call(Static(TypeDecl.Imported({idText = type_name.idText; idRange = Position type_name.idRange}, 
                                               TypeDecl.Tuple([for t in parameters do yield traverseType t])),
                             Some ({idText = method_name.Lid.Head.idText; idRange = Position method_name.Lid.Head.idRange}),
                             tupleOrUnitToList args))
    res
  | SynExpr.DotGet(SynExpr.TypeApp(SynExpr.Ident(type_name), _, parameters, _, _, _, _), _, method_name, p) when type_name.idText = "Query" -> 
    Expression.Query([InnerQueryExpression.Empty(Some (BasicAST.Tuple([for p in parameters do yield traverseType p])), Common.Position p)])
  | SynExpr.While(sequencePointInfoForWhileLoop, cond, body, psition) ->
    
    Expression.While(traverseSynExpr cond, traverseSynExprBlock body)
  // [] catches an empty list
  | SynExpr.ArrayOrList(_, [], position) -> 
    //[Expression.Query([InnerQueryExpression.Empty(BasicAST.Tuple([for p in parameters do yield traverseType p]))])]
    Expression.Query([InnerQueryExpression.Empty(None, Common.Position synExpr.Range)])
    //raise (Position position) "ArrayOrList not supported (syntax: [ e1; ...; en ], [| e1; ...; en |]). "
  | SynExpr.ArrayOrList(_, synExpr_list, position) -> raise (Position position) "ArrayOrList not supported (syntax: [ e1; ...; en ], [| e1; ...; en |]). "
  // [x;..;xn] catches a non-empty list
  | SynExpr.ArrayOrListOfSeqExpr(_, SynExpr.CompExpr(true, true_ref, expr, inner_range), range) when !true_ref = true -> 
    Expression.Query(traverseQuery expr)
  | SynExpr.WaitStatement(synExpr, position) -> Expression.Wait(traverseSynExpr synExpr)
  | SynExpr.WaitUntilStatement(synExpr, position) -> Expression.Wait(traverseSynExpr synExpr)
  | SynExpr.YieldStatement(synExpr, position) -> 
    let syn_expr = traverseSynExpr synExpr
    match syn_expr with
    | Expression.Tuple(_) -> Expression.Yield(syn_expr)
    | _ -> Expression.Yield(Expression.Tuple([[syn_expr]]))
  | SynExpr.New(_, synType, synExpr, position) -> Expression.New(traverseType synType, synExpr |> tupleOrUnitToList)
  | SynExpr.For(_, ident, synExpr, _, synExpr1, synExpr2, position) -> raise (Position position)  "Indexed for not supported (syntax: 'for i = ... to ... do ...'). "
  | SynExpr.ForEach(_, _, _, synPat, synExpr1, synExpr2, position) ->
    Expression.For(traverseSynPat synPat, traverseSynExpr synExpr1, traverseSynExprBlock synExpr2)
  | SynExpr.CompExpr(_, _, synExpr, position) -> raise (Position position) "Lists not supported (syntax: { expr }). "
  | SynExpr.Match (_, synExpr, synMatchClause_list, _ , position) -> raise (Position position)  "Match not supported (syntax: match expr with pat1 -> expr | ... | patN -> exprN). "
  | SynExpr.Do(synExpr, _) -> traverseSynExpr synExpr
  | SynExpr.DotGet(synExpr, position1, longIdentWithDots, position2) -> raise (Position position2)  "DoGet not supported (syntax: expr.ident.ident). "
  | SynExpr.TypeApp(synExpr, position1, synType_list, position_list, position_option, position2, position3) -> raise (Position position2)  "Type application not supported (syntax: expr<type1,...,typeN>). "
  | SynExpr.Upcast(synExpr, synType, position) -> raise (Position position)  "Upcast not supported (syntax: expr :> type). "
  | SynExpr.Null(position) -> raise (Position position)  "Null values not supported (syntax: null). "
  | SynExpr.Record(None, None , exprs, p) ->
    Expression.NewEntity([for ((field_name, _), expr, _) in exprs do  
                            if field_name.Lid.Length = 0 then
                              raise Position.Empty (sprintf "New entity without body. Internal error at %s(%s)" __SOURCE_FILE__ __LINE__)
                            let field_name = field_name.Lid.Head
                            let expr = match expr with | Some expr -> expr | None -> raise (Position p) "Missing field body."
                            let expr = traverseSynExprBlock expr
                            yield { idText = field_name.idText; idRange = Position field_name.idRange}, expr])
  | SynExpr.DotIndexedGet(SynExpr.Ident(lst), [expr], p1, p2) -> 
    Expression.IndexOf({idText = lst.idText; idRange = Position lst.idRange}, traverseSynExpr expr)
  | SynExpr.Choice(interruptible,choices) -> 
    let choices1 = 
      [for (c,b,p) in choices do
        yield traverseSynExpr c, traverseSynExprBlock b, Position p]
    Expression.Choice(interruptible,choices1)
  
  | SynExpr.Parallel(_parallel) ->
    let parallel1 =
      [for (b,p) in _parallel do
          yield traverseSynExprBlock b, Position p]
    Expression.Parallel(parallel1)

  | SynExpr.ArrayOrListOfSeqExpr(_, SynExpr.App(_, _, SynExpr.App(_,_, SynExpr.Ident(f), _from,_), _to, _), position) when f.idText = "op_Range" -> 
    let _from = traverseSynExpr _from
    let _to = traverseSynExpr _to
    Expression.Range(_from, _to, Position position)
  
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), e1, _), e2, _) when ident.idText = "op_Append" ->

    let rec traverse_expr expr : List<Expression>=
      match expr with
      | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.Ident(ident), e1, _), e2, _) when ident.idText = "op_Append" ->
        traverse_expr e1 @ traverse_expr e2
      | SynExpr.ArrayOrListOfSeqExpr(_,SynExpr.CompExpr(_ ,_ , 
                                                        SynExpr.ForEach(info, seqExprOnly, bool, synPat, synExpr1, synExpr2, position),
                                                        crange), range) -> 
        let expr = SynExpr.ForEach(info, seqExprOnly, bool, synPat, synExpr1, synExpr2, position)
        [Expression.Query(traverseQueryExpression expr)]

      | SynExpr.DotGet(SynExpr.TypeApp(SynExpr.Ident(type_name), _, parameters, _, _, _, _), _, method_name, p) when type_name.idText = "Query" -> 
        [Expression.Query([InnerQueryExpression.Empty(Some(BasicAST.Tuple([for p in parameters do yield traverseType p])), Common.Position p)])]

      | SynExpr.ArrayOrListOfSeqExpr(_, SynExpr.CompExpr(true, true_ref, expr, inner_range), range) when !true_ref = true -> 
        [Expression.Query(traverseQuery expr)]
      | SynExpr.LongIdent(_, longIdent, _, position) -> [Expression.Id(traverseLongIdentWithDots longIdent)]

      | SynExpr.Ident(lst) -> [Expression.Id({Common.idText = lst.idText; Common.idRange = Position lst.idRange})]
      | _ -> failwith (Position expr.Range) "Expected query"    

    let res = ConcatQuery(traverse_expr e1 @ traverse_expr e2)
    res
  
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.LongIdent(_, lid,_,_), 
                      SynExpr.Paren(SynExpr.Lambda(_,_, p, body, _) , _,_,_), _), expr, position) ->
    let rec try_reduce_lambdas expr =
      match expr with
      | SynExpr.Lambda(_,_, p, body, _) ->
        let ps, b = try_reduce_lambdas body
        p :: ps, b
      | _ -> [], expr
      
    let lid = lid.Lid
    let id, _method = lid |> Seq.take(lid.Length - 1) |> Seq.map(fun a -> a.idText) |> Seq.reduce(fun a b -> a + "." + b), 
                      lid |> Seq.skip(lid.Length - 1) |> Seq.head
    let pats, body = try_reduce_lambdas body
    let pats = [for p in p :: pats do yield! traverseSynSimplePats p]
    let body = traverseSynExprBlock body
    let arg1 = Expression.Lambda(pats, body)
    let arg2 = traverseSynExpr expr

    let res = 
      MaybeInstance({idText = id; idRange = Position position},
                    ({idText = _method.idText; idRange = Position _method.idRange}),
                    [arg1; arg2])
    Expression.Call(res)
    //ExprAtomicFlag * bool * SynExpr * SynExpr * Position
  | SynExpr.App(ExprAtomicFlag.NonAtomic, false, SynExpr.Paren(SynExpr.Ident(_tp_to_cast), _, _, _), expr, p) -> 
    Expression.Cast(traverseTypeId _tp_to_cast.idText (Position _tp_to_cast.idRange), traverseSynExpr expr, Position p)
  | _ -> raise  (Position synExpr.Range)  "Generic: expression not supported. "

and private traverseSynExprBlock (synExpr : SynExpr) : Block =
  match synExpr with  
  | SynExpr.Sequential(sequencePointInfoForSeq, bool, SynExpr.Choice(interruptible,choices), synExpr2, position) ->
    let rest : Ref<Option<SynExpr>> = ref None
    let rec select_choices expr =
      match expr with
      | SynExpr.Sequential(sequencePointInfoForSeq, bool, SynExpr.Choice(_,choices1), SynExpr.Choice(_,choices2), position) ->
        match choices1, choices2 with
        | [] ,_  | _, [] -> raise (Common.Position synExpr.Range) "Error: Choices without body."
        | _ -> ()
        [choices1.Head; choices2.Head]
      | SynExpr.Sequential(_, _, SynExpr.Choice(_,choices1), SynExpr.Sequential(_, _, SynExpr.Choice(_,choices2), expr, position), _) ->
        match choices1, choices2 with
        | [] ,_  | _, [] -> raise (Common.Position synExpr.Range) "Error: Choices without body."
        | _ -> ()
        choices1.Head :: choices2.Head :: (select_choices expr)
      | SynExpr.Choice(_,choices) -> 
        if choices.Length = 0 then raise (Common.Position synExpr.Range) "Error: Choices without body."
        [choices.Head]
      | _ -> 
        rest := Some expr
        []
    let choice = SynExpr.Choice(interruptible,select_choices synExpr)
    let synexpr1 = traverseSynExpr choice
    if rest.Value.IsSome then
      let synexpr2 = traverseSynExprBlock rest.Value.Value
      synexpr1 :: synexpr2
    else [synexpr1]
  
  | SynExpr.Sequential(sequencePointInfoForSeq, bool, SynExpr.Parallel(_parallel), synExpr2, position) ->
    let rest : Ref<Option<SynExpr>> = ref None
    let rec select_parallel expr =
        match expr with
        | SynExpr.Sequential(sequencePointInfoForSeq, bool, SynExpr.Parallel(parallel1), SynExpr.Parallel(parallel2), position) ->
            match parallel1, parallel2 with
            | [] ,_  | _, [] -> raise (Common.Position synExpr.Range) "Error: Parallel without body."
            | _ -> ()
            [parallel1.Head; parallel2.Head]
        | SynExpr.Sequential(_, _, SynExpr.Parallel(parallel1), SynExpr.Sequential(_, _, SynExpr.Parallel(parallel2), expr, position), _) ->
            match parallel1, parallel2 with
            | [] ,_  | _, [] -> raise (Common.Position synExpr.Range) "Error: Parallel without body."
            | _ -> ()
            parallel1.Head :: parallel2.Head :: (select_parallel expr)
        | SynExpr.Parallel(_parallel) ->
          if _parallel.Length = 0 then raise (Common.Position synExpr.Range) "Error: Parallel without body."
          [_parallel.Head]
        | _ ->
            rest := Some expr
            []

    let _parallel = SynExpr.Parallel(select_parallel synExpr)
    let synexpr1 = traverseSynExpr _parallel
    if rest.Value.IsSome then
      let synexpr2 = traverseSynExprBlock rest.Value.Value
      synexpr1 :: synexpr2
    else [synexpr1]
      
  | SynExpr.Sequential(sequencePointInfoForSeq, bool, synExpr1, synExpr2, position) ->
    let synexpr1 = traverseSynExpr synExpr1
    let synexpr2 = traverseSynExprBlock synExpr2
    synexpr1 :: synexpr2
  | SynExpr.LetOrBindingOrUse(_, _,false, [synBinding], synExpr, position) -> 
    let binding_identifier = traverseSynPat synBinding.SynPat
    if binding_identifier.Length > 1 then raise (Position position) "Multiple identifiers on a let binding are not supported yet." |> ignore
    if binding_identifier.Length = 0 then raise (Position position) "Let binding without identifiers." |> ignore
    let binding_expr = traverseSynExpr synBinding.GetExpr
    let synexpr = traverseSynExprBlock synExpr
    Expression.Let(binding_identifier.Head, binding_expr) :: synexpr
  | SynExpr.LetOrBindingOrUse(_, _,true, [synBinding], synExpr, position) -> 
    let binding_identifier = traverseSynPat synBinding.SynPat
    if binding_identifier.Length > 1 then raise (Position position) "Multiple identifiers on a let binding are not supported yet." |> ignore
    if binding_identifier.Length = 0 then raise (Position position) "Let binding without identifiers." |> ignore
    let binding_expr = traverseSynExpr synBinding.GetExpr
    let synexpr = traverseSynExprBlock synExpr
    Expression.LetWait(binding_identifier.Head, binding_expr) :: synexpr

  | _ -> [traverseSynExpr synExpr]
  
and private traverseInnerQueryExpression (synExpr : SynExpr) : InnerQueryExpression =
  let raise = raise (Position synExpr.Range)
  match synExpr with
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "select" -> InnerQueryExpression.Select(traverseSynExpr expr)
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "where" -> InnerQueryExpression.Where(traverseSynExpr expr)
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "for_all" -> InnerQueryExpression.ForAll(traverseSynExpr expr)
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "exists" -> InnerQueryExpression.Exists(traverseSynExpr expr)
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "groupBy" -> InnerQueryExpression.GroupBy(traverseSynExpr expr)
  | SynExpr.App(_, _, SynExpr.App(_, _, SynExpr.App(_, _, 
                                                      SynExpr.Ident(groupBy), expr, _), 
                                                      SynExpr.Ident(into), _),
                                                      SynExpr.Ident(projection), p) when groupBy.idText = "groupByInto" &&
                                                                                         into.idText = "into" -> 
    InnerQueryExpression.GroupByInto(traverseSynExpr expr, ({idText = projection.idText; idRange = Position projection.idRange}))
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "maxBy" -> InnerQueryExpression.MaxBy(traverseSynExpr expr)
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "minBy" -> InnerQueryExpression.MinBy(traverseSynExpr expr)
  
  | SynExpr.App(_, _, SynExpr.Ident(ident), expr, p) when ident.idText = "findBy" -> InnerQueryExpression.FindBy(traverseSynExpr expr)
  | SynExpr.Ident(ident) when ident.idText = "sum" -> InnerQueryExpression.Sum (Position.Position ident.idRange)
  | SynExpr.Ident(ident) when ident.idText = "min" -> InnerQueryExpression.Min (Position.Position ident.idRange)
  | SynExpr.Ident(ident) when ident.idText = "max" -> InnerQueryExpression.Max (Position.Position ident.idRange)
  | e -> raise (sprintf "Not supported inner query operation. %s" (e.ToString()))

and private traverseQueryExpression (synExpr : SynExpr) : List<InnerQueryExpression> =
  let raise = raise (Position synExpr.Range)  
  match synExpr with
  | SynExpr.ForEach(info, seqExprOnly, bool, synPat, synExpr1, synExpr2, position) -> 
    let _for = InnerQueryExpression.QueryFor(traverseSynPat synPat, traverseSynExpr synExpr1)
    let _cont = traverseQueryExpression synExpr2
    _for :: _cont
  | SynExpr.Sequential(sequencePointInfoForSeq, bool, synExpr1, synExpr2, position) ->
    let synexpr1 = traverseInnerQueryExpression synExpr1
    let synexpr2 = traverseQueryExpression synExpr2
    synexpr1 :: synexpr2
  | SynExpr.LetOrBindingOrUse(_,_, _, [synBinding], synExpr, position) -> 
    let binding_identifier = traverseSynPat synBinding.SynPat
    if binding_identifier.Length > 1 then raise "Multiple identifiers on a let binding are not supported yet. " |> ignore
    if binding_identifier.Length = 0 then raise "Let binding without identifiers." |> ignore
    let binding_expr = traverseSynExpr synBinding.GetExpr
    let synexpr = traverseQueryExpression synExpr
    InnerQueryExpression.Let(binding_identifier.Head, binding_expr) :: synexpr
  | _ -> [traverseInnerQueryExpression synExpr]

and private traverseSynPatDomain (synPat : SynPat) : List<Id> =
  let raise = raise (Position synPat.Range)
  match synPat with
  | SynPat.Named(synPat, ident, bool, position) -> [{idText = ident.idText; idRange = Position ident.idRange}]
  | SynPat.LongIdent(longIdentWithDots, None, [], position) -> [traverseLongIdentWithDots longIdentWithDots]
  | SynPat.Tuple(synPat_list, position) -> [for p in synPat_list do yield! traverseSynPatDomain p]
  | SynPat.LongIdent(longIdentWithDots, None, args, position) ->  
    //(LongIdentWithDots([Ident("Create",_range)],[]))
    do 1 //we we should manage the entity contructor
    [] 
  | _ -> raise "Not supported pattern in rule definition. "

and private traverseCreateSynPatDomain (synPat : SynPat) : List<Id * Option<TypeDecl>> =
  let raise = raise (Position synPat.Range)
  match synPat with
  | SynPat.LongIdent((LongIdentWithDots([ident],[])), None, args, position) when ident.idText = "Create" ->  
    let args =
      [for arg in args do
        let rec eval_arg arg : List<Id * Option<TypeDecl>> =
          match arg with
          |SynPat.Typed(SynPat.Named(_, id, _, _), tp, r) -> [{idText = id.idText; idRange = Position id.idRange}, Some (traverseType tp)]
          |SynPat.Typed(SynPat.LongIdent(LongIdentWithDots([ident],_), _,_,_), tp, r) -> [{idText = ident.idText; idRange = Position ident.idRange}, Some (traverseType tp)]
          |SynPat.Paren(p, _) -> eval_arg p
          |SynPat.Tuple(ps, _) -> [for p in ps do yield! eval_arg p]
          |SynPat.Named(_,id,_,_) -> [{idText = id.idText; idRange = Position id.idRange}, None]
          
          |SynPat.LongIdent(LongIdentWithDots([t], _), _, [SynPat.Named(_,id,_,_)], p) ->
            [{idText = id.idText; idRange = Position id.idRange}, Some (traverseTypeId t.idText (Position t.idRange))]

          |SynPat.Const(SynConst.Unit, p) -> []
          | _ -> raise "Not supported arg in create definition. "
        yield! eval_arg arg ]
    args
  | _ -> raise "Not supported pattern in create definition. "

and private traverseSynPat (synPat : SynPat) : List<Id> =
  let raise = raise (Position synPat.Range)
  match synPat with
  | SynPat.Named(synPat, ident, bool, position) -> [{idText = ident.idText; idRange = Position ident.idRange}]
  | SynPat.LongIdent(longIdentWithDots, None, [], position) -> [traverseLongIdentWithDots longIdentWithDots]
  | SynPat.Tuple(synPat_list, position) -> [for p in synPat_list do yield! traverseSynPatDomain p]
  | SynPat.Paren(synPat, position) -> traverseSynPat synPat
  | SynPat.Typed(synPat,_, position) -> traverseSynPat synPat
  | _ -> raise "Not supported pattern. "
  
and private traverseSynSimplePats (synPat : SynSimplePats) : List<Id * Option<TypeDecl>> =
  match synPat with
  | SynSimplePats.SimplePats (synSimplePat_list, _) -> synSimplePat_list |> List.map(fun e -> traverseSynSimplePat e)
  | SynSimplePats.Typed(synSimplePats, synType, _) -> traverseSynSimplePats synSimplePats

and private traverseSynSimplePat (synPat : SynSimplePat) : Id * Option<TypeDecl> =
  let raise = raise (Position synPat.Range)
  match synPat with
  | SynSimplePat.Id(id, _, _,_,_,p) -> {idText = id.idText; idRange = Position id.idRange}, None
  | SynSimplePat.Typed(SynSimplePat.Id(id, _, _,_,_,p), synType, _) -> {idText = id.idText; idRange = Position id.idRange}, Some (traverseType synType)
  |_ -> raise "Not supported SynSimplePat"


and private traverseSynTypeDefnRepr (inherited_types : Id list) (synTypeDefnRepr : SynTypeDefnRepr) : List<Field> =
  let raise = raise (Position synTypeDefnRepr.Range)
  let (Simple(synTypeDefnSimpleRepr, position)) = synTypeDefnRepr
  match synTypeDefnSimpleRepr with
  | SynTypeDefnSimpleRepr.Record(synFields, position) ->
    let res = 
      [
       for inherited_class in inherited_types do
        yield 
          {
            IsExternal    = None
            Name          = {idText = inherited_class.idText; idRange = inherited_class.idRange}
            Type          = BasicAST.TypeDecl.Imported(inherited_class, BasicAST.TypeDecl.Tuple([]))
            IsReference   = true
          }
        match OpenContext.inherited_types |> Seq.tryFind(fun t -> t.Name = inherited_class.idText) with
        | None -> ()
        | Some t -> 
          //System.Diagnostics.Debugger.Launch() |> ignore
          let properties = t.GetProperties()
          let fields = t.GetFields()
          for f in fields do
            if f.CustomAttributes |> Seq.exists (fun a -> a.AttributeType.FullName = typeof<System.ObsoleteAttribute>.FullName) |> not 
               && (f.Name.ToLower() = "m_cachedptr" |> not ) && (f.Name.ToLower() = "m_instanceid" |> not ) then
              yield 
                {
                  IsExternal    = Some (inherited_class, not f.IsPrivate, not f.IsPrivate)
                  Name          = {idText = f.Name; idRange = inherited_class.idRange}
                  Type          = BasicAST.TypeDecl.Imported({ idText =  f.FieldType.FullName; idRange = inherited_class.idRange}, BasicAST.TypeDecl.Tuple([]))
                  IsReference   = true
                }
          for p in properties do
            let public_get = 
              if p.GetMethod = null || p.Name.ToLower() = "m_cachedptr" || p.Name.ToLower() = "m_instanceid"  then false
              else p.GetMethod.Attributes.HasFlag(Reflection.MethodAttributes.Private) |> not
            let public_set = 
              if p.SetMethod = null || p.Name.ToLower() = "m_cachedptr" || p.Name.ToLower() = "m_instanceid" then false
              else p.SetMethod.Attributes.HasFlag(Reflection.MethodAttributes.Private) |> not
            if (public_set || public_get) then
              if p.CustomAttributes |> Seq.exists (fun a -> a.AttributeType.FullName = typeof<System.ObsoleteAttribute>.FullName) |> not then
                yield 
                  {
                    IsExternal    = Some (inherited_class, public_get, public_set)
                    Name          = {idText = p.Name; idRange = inherited_class.idRange}
                    Type          = BasicAST.TypeDecl.Imported({ idText = p.PropertyType.FullName; idRange = inherited_class.idRange}, BasicAST.TypeDecl.Tuple([]))
                    IsReference   = true
                  }


       for field in synFields do  
        match field.Ident with
        | Some field_ident ->
          yield {
                  IsExternal    = None
                  Name          = {idText = field.Ident.Value.idText; idRange = Position field_ident.idRange}
                  Type          = traverseType field.GetType
                  IsReference   = field.IsReferenceType
                }
        | _ -> raise (sprintf "Internal error %s(%s)" __SOURCE_FILE__ __LINE__) |> ignore]
    res
  | SynTypeDefnSimpleRepr.Union(synFields, position) -> raise "Union representations not supported. "


and private traverseLongIdentWithDots (longIdentWithDots : LongIdentWithDots) : Id =
  let string = longIdentWithDots.Lid |> List.map(fun id -> id.idText) |> List.reduce(fun a b -> a + "." + b)
  {idText = string; idRange = Position longIdentWithDots.Range}

and private traverseLongIdent (longIdent : LongIdent) : Id =  
  {idText = longIdent |> List.map(fun id -> id.idText) |> List.reduce(fun a b -> a + "." + b); 
   idRange = if longIdent.Length > 0 then Position longIdent.Head.idRange else Position.Empty}
  

let ConvertProgram (p:CasanovaCompiler.ParseAST.Program) : BasicAST.Program = 
  traverseProgram p