namespace Microsoft.P2Boogie
module RemoveNamedTuples = 
  open Syntax
  open Common
  open Helper
  open ProgramTyping

  let rec processType ty =
    match ty with
    | Type.NamedTuple ts -> Type.Tuple (List.map (fun (a,b) -> processType b) ts)
    | Seq t -> Seq (processType t)
    | Map(t1,t2) -> Map(processType t1, processType t2)
    | Type.Tuple ts -> Type.Tuple (List.map (fun a -> processType a) ts)
    | _ -> ty

  let rec processExpr G expr =
    match expr with
    | Nil
    | ConstInt _
    | ConstBool _
    | Event _
    | This
    | Nondet
    | Expr.Var _ -> expr
    | Default t -> Default (processType t)
    | Bin(op, e1, e2) -> Bin(op, processExpr G e1 , processExpr G e2)
    | Un(op, e) -> Un(op, processExpr G e)
    | Expr.Dot(e,i) -> Expr.Dot(processExpr G e, i)
    | Expr.NamedDot(e, f) ->
    begin
      let (Type.NamedTuple(ts)) = typeof e G in
      let index = lookupNamedFieldIndex f ts in
        Expr.Dot(processExpr G e , index)
    end
    | Cast(e, t) -> Cast(processExpr G e, processType t)
    | Tuple(es) -> Tuple(List.map (fun e -> processExpr G e) es)
    | NamedTuple(es) -> Tuple(List.map (fun (f,e) -> processExpr G e) es)
    | New(s, e) -> New(s, processExpr G e)
    | Call(callee, args) -> Call(callee, List.map (fun e -> processExpr G e) args)

  let rec processLval G lval =
    match lval with
    | Var _ -> lval
    | Dot(l, i) -> Dot(processLval G l, i)
    | NamedDot(l, f) -> 
    begin
      let (Type.NamedTuple(ts)) = typeofLval l G in
      Dot(processLval G l, lookupNamedFieldIndex f ts)
    end
    | Index(l, e) -> Index(processLval G l, processExpr G e)

  let rec processStmt G st =
    match st with
    | Assign(l, e) -> Assign(processLval G l, processExpr G e)
    | Insert (l, e1, e2) -> Insert(processLval G l, processExpr G e1, processExpr G e2)
    | Remove (l, e) -> Remove(processLval G l, processExpr G e)
    | Assume e -> Assume (processExpr G e)
    | Assert e -> Assert (processExpr G e)
    | NewStmt(_, Nil) -> st
    | NewStmt(s, e)-> NewStmt(s, (processExpr G e))
    | Raise(e1, Nil) -> Raise((processExpr G e1), Nil)
    | Raise(e1, e2) -> Raise((processExpr G e1), (processExpr G e2))
    | Send (e1, e2, Nil) -> Send((processExpr G e1), (processExpr G e2), Nil)
    | Send (e1, e2, e3) -> Send((processExpr G e1), (processExpr G e2), (processExpr G e3))
    | Skip(_) -> st
    | While(c, s) -> While((processExpr G c), (processStmt G s))
    | Ite(c, i, e) -> Ite((processExpr G c), (processStmt G i), (processStmt G e))
    | SeqStmt(l) -> SeqStmt(List.map (processStmt G) l)
    | Receive(_) -> st 
    | Pop -> st
    | Return(None) -> st
    | Return(Some(e)) -> Return(Some (processExpr G e))
    | Monitor(e1, e2) -> Monitor ((processExpr G e1), (processExpr G e2))
    | FunStmt(s, el, None) -> FunStmt(s, (List.map (processExpr G) el), None)
    | FunStmt(s, el, v) -> FunStmt(s, (List.map (processExpr G) el), v)
    | Goto(s, e) -> Goto(s, processExpr G e)

  let processEnv G =
    Map.map (fun key value -> processType value) G

  let processVd (vd: VarDecl) = 
    new VarDecl(vd.Name, (processType vd.Type))
  
  let processEd (ed: EventDecl) = 
    match ed.Type with 
    | None -> ed
    | Some(t) -> new EventDecl(ed.Name, ed.QC, Some(processType t))

 ///Return a new FunDecl with all named tuples removed.
  let removeNamedTuplesFn G (f: FunDecl) = 
    let G' = mergeMaps G f.VarMap
    let formals = List.map processVd f.Formals
    let retType = 
      match f.RetType with
      | None -> None
      | Some(t) -> Some(processType(t))
    let locals = List.map processVd f.Locals
    let stmts = List.map (processStmt G') f.Body
    new FunDecl(f.Name, formals, retType, locals, stmts, f.IsModel, f.IsPure, f.TrueNames)

  ///Return a new MachineDecl with all named tuples removed. 
  let removeNamedTuplesMachine G (m:MachineDecl) = 
    let funs = 
      let map = ref Map.empty in
        List.iter (fun(f: FunDecl) -> map := Map.add f.Name (if f.RetType.IsSome then f.RetType.Value else Type.Null) !map) m.Functions
      !map 
    let G' = mergeMaps (mergeMaps G m.VarMap) funs
    let globals = List.map processVd m.Globals
    let fList = List.map (removeNamedTuplesFn G') m.Functions 
    new MachineDecl(m.Name, m.StartState, globals, fList, m.States, m.IsMonitor, m.MonitorList, m.QC, m.IsModel, m.HasPush, m.Init, m.Partial)

  ///Return a new ProgramDecl with all named tuples removed.  
  let removeNamedTuplesProgram (prog: ProgramDecl) = 
    let G =           
      let map = ref Map.empty in
        List.iter (fun(f: FunDecl) -> map := Map.add f.Name (if f.RetType.IsSome then f.RetType.Value else Type.Null) !map) prog.StaticFuns
      !map 
    let eList = List.map processEd prog.Events
    let mList = List.map (removeNamedTuplesMachine G) prog.Machines
    let fList = List.map (removeNamedTuplesFn G) prog.StaticFuns
    new ProgramDecl(mList, eList, prog.EventsToMonitors, fList, prog.maxFields, prog.HasDefer, prog.HasIgnore, prog.TypesAsserted)