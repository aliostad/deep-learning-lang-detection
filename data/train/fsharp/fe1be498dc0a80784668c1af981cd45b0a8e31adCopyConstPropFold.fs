module CopyConstPropFold

(*
    (* An optimisation takes a program and returns a new program. *)
    val optimiseProgram : Fasto.KnownTypes.Prog -> Fasto.KnownTypes.Prog
*)

open AbSyn

(* A propagatee is something that we can propagate - either a variable
   name or a constant value. *)
type Propagatee =
    ConstProp of Value
  | VarProp   of string

type VarTable = SymTab.SymTab<Propagatee>

let rec copyConstPropFoldExp (vtable : VarTable)
                             (e      : TypedExp) =
    match e with
        (* Copy propagation is handled entirely in the following three
        cases for variables, array indexing, and let-bindings. *)
        | Var (name, pos) ->
            match SymTab.lookup name vtable with
                | Some (ConstProp v) -> Constant (v,pos)
                | Some (VarProp v) -> Var (v,pos)
                | _ -> Var (name, pos)
             (*TODO project task 3:
                Should probably look in the symbol table to see if
                a binding corresponding to the current variable `name`
                exists and if so, it should replace the current expression
                with the binded variable or constant.
            *)
        | Index (name, e, t, pos) ->
            let e' = copyConstPropFoldExp vtable e           
            match e' with
                | _ -> Index (name, e', t, pos)
            (* TODO project task 3:
                Should probably do the same as the `Var` case, for
                the array name, and optimize the index expression `e` as well.
            *)        
        | Let (Dec (name, e, decpos), body, pos) ->
            let e' = copyConstPropFoldExp vtable e
            match e' with
                | Var (n, pos) ->
                    let vtable' = SymTab.bind name (VarProp n) vtable
                    let body' = copyConstPropFoldExp vtable' body
                    Let (Dec (name, e', decpos), body', pos)
                    (* TODO project task 3:
                        Hint: I have discovered a variable-copy statement `let x = a`.
                              I should probably record it in the `vtable` by
                              associating `x` with a variable-propagatee binding,
                              and optimize the `body` of the let.
                    *)
                | Constant (x, pos) ->
                    let vtable' = SymTab.bind name (ConstProp x) vtable
                    let body' = copyConstPropFoldExp vtable' body
                    Let (Dec (name, e', decpos), body', pos)
                    (* TODO project task 3:
                        Hint: I have discovered a constant-copy statement `let x = 5`.
                              I should probably record it in the `vtable` by
                              associating `x` with a constant-propagatee binding,
                              and optimize the `body` of the let.
                    *)
                | Let (Dec (name, e, decpos), body, pos) ->
                    let e1 = Let (Dec (name, e, decpos), body, pos)
                    let e2 = copyConstPropFoldExp vtable e1                  
                    Let (Dec (name, e2, decpos), body, pos)  
                    (* TODO project task 3:
                        Hint: this has the structure
                                `let y = (let x = e1 in e2) in e3`
                        Problem is, in this form, `e2` may simplify
                        to a variable or constant, but I will miss
                        identifying the resulting variable/constant-copy
                        statement on `y`.
                        A potential solution is to optimize directly the
                        restructured, semantically-equivalent expression:
                                `let x = e1 in let y = e2 in e3`
                    *)
                | _ -> (* Fallthrough - for everything else, do nothing *)
                    let body' = copyConstPropFoldExp vtable body
                    Let (Dec (name, e', decpos), body', pos)
        | Times (x, y, pos) ->
            (* TODO project task 3: implement as many safe algebraic
                simplifications as you can think of. You may inspire 
                yourself from the case of `Plus`. For example:*)
                
            //cases handled: (0,_)(_,0)(1,_)(_,1)(int,int)
            let e1' = copyConstPropFoldExp vtable x
            let e2' = copyConstPropFoldExp vtable y
            match (e1', e2') with
                | (Constant (IntVal x, _), Constant (IntVal y, _)) ->
                    Constant (IntVal (x * y), pos)
                | (Constant (IntVal 0, _), _) -> Constant (IntVal 0, pos)
                | (_, Constant (IntVal 0, _)) -> Constant (IntVal 0, pos)
                | _ -> Times (e1', e2', pos)
        | And (e1, e2, pos) ->
            (* TODO project task 3: see above. you may inspire yourself from `Or` *)
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            match (e1', e2') with
                | (Constant (BoolVal a, _), Constant (BoolVal b, _)) ->
                    Constant (BoolVal (a && b), pos)
                | _ -> And (e1', e2', pos)
        | Constant (x,pos) -> Constant (x,pos)
        | StringLit (x,pos) -> StringLit (x,pos)
        | ArrayLit (es, t, pos) ->
            ArrayLit (List.map (copyConstPropFoldExp vtable) es, t, pos)
        | Plus (e1, e2, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            match (e1', e2') with
                | (Constant (IntVal x, _), Constant (IntVal y, _)) ->
                    Constant (IntVal (x + y), pos)
                | (Constant (IntVal 0, _), _) -> e2'
                | (_, Constant (IntVal 0, _)) -> e1'
                | _ -> Plus (e1', e2', pos)
        | Minus (e1, e2, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            //cases handled: (0,_)(_,0)(int,int)
            match (e1', e2') with
                | (Constant (IntVal x, _), Constant (IntVal y, _)) ->
                    Constant (IntVal (x - y), pos)
                | (_, Constant (IntVal 0, _)) -> e1'
                | (Constant (IntVal 0, _),_) -> e2'
                | _ -> Minus (e1', e2', pos)
        | Equal (e1, e2, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            //cases handled: (char,char)(int,int)
            match (e1', e2') with
                | (Constant (IntVal v1, _), Constant (IntVal v2, _)) ->
                    Constant (BoolVal (v1 = v2), pos)
                | (Constant (CharVal v1, _), Constant (CharVal v2, _)) ->
                    Constant (BoolVal (v1 = v2), pos)
                | _ ->
                    if e1' = e2'
                    then Constant (BoolVal true, pos)
                    else Equal (e1', e2', pos)
        | Less (e1, e2, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            match (e1', e2') with
                | (Constant (IntVal v1, _), Constant (IntVal v2, _)) ->
                    Constant (BoolVal (v1 < v2), pos)
                | _ ->
                    if e1' = e2'
                    then Constant (BoolVal false, pos)
                    else Less (e1', e2', pos)
        | If (e1, e2, e3, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            match e1' with
                | Constant (BoolVal b, _) ->
                    if b
                    then copyConstPropFoldExp vtable e2
                    else copyConstPropFoldExp vtable e3
                | _ ->
                    If (e1',
                        copyConstPropFoldExp vtable e2,
                        copyConstPropFoldExp vtable e3,
                        pos)
        | Apply (fname, es, pos) ->
            Apply (fname, List.map (copyConstPropFoldExp vtable) es, pos)
        | Iota (e, pos) ->
            Iota (copyConstPropFoldExp vtable e, pos)
        | Map (farg, e, t1, t2, pos) ->
            Map (copyConstPropFoldFunArg vtable farg,
                 copyConstPropFoldExp vtable e,
                 t1, t2, pos)
        | Reduce (farg, e1, e2, t, pos) ->
            Reduce (copyConstPropFoldFunArg vtable farg,
                    copyConstPropFoldExp vtable e1,
                    copyConstPropFoldExp vtable e2,
                    t, pos)
        | Range (e1, e2, e3, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            let e3' = copyConstPropFoldExp vtable e3
            Range (e1', e2', e3', pos)         
        | Replicate (n, e, t, pos) ->
            Replicate (copyConstPropFoldExp vtable n,
                       copyConstPropFoldExp vtable e,
                       t, pos)
        | Scan (farg, e1, e2, t, pos) ->
            Scan (copyConstPropFoldFunArg vtable farg,
                    copyConstPropFoldExp vtable e1,
                    copyConstPropFoldExp vtable e2,
                    t, pos)
        | Divide (e1, e2, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            //cases handled: (0,_)(int,int)
            match (e1', e2') with
                | (Constant (IntVal 0, _), _) -> Constant (IntVal 0, pos)
                | (Constant (IntVal x, _), Constant (IntVal y, _)) ->
                    Constant (IntVal (x / y), pos)
                | _ -> Divide (e1', e2', pos)
        | Or (e1, e2, pos) ->
            let e1' = copyConstPropFoldExp vtable e1
            let e2' = copyConstPropFoldExp vtable e2
            match (e1', e2') with
                | (Constant (BoolVal a, _), Constant (BoolVal b, _)) ->
                    Constant (BoolVal (a || b), pos)
                | _ -> Or (e1', e2', pos)
        | Not (e, pos) ->
            let e' = copyConstPropFoldExp vtable e
            match e' with
                | Constant (BoolVal a, _) -> Constant (BoolVal (not a), pos)
                | _ -> Not (e', pos)
        | Negate (e, pos) ->
            let e' = copyConstPropFoldExp vtable e
            match e' with
                | Constant (IntVal x, _) -> Constant (IntVal (-x), pos)
                | _ -> Negate (e', pos)
        | Read (t, pos) -> Read (t, pos)
        | Write (e, t, pos) -> Write (copyConstPropFoldExp vtable e, t, pos)

and copyConstPropFoldFunArg (vtable : VarTable)
                            (farg   : TypedFunArg) =
    match farg with
        | FunName fname -> FunName fname
        | Lambda (rettype, paramls, body, pos) ->
            (* Remove any bindings with the same names as the parameters. *)
            let paramNames = (List.map (fun (Param (name, _)) -> name) paramls)
            let vtable'    = SymTab.removeMany paramNames vtable
            Lambda (rettype, paramls, copyConstPropFoldExp vtable' body, pos)

let copyConstPropFoldFunDec = function
    | FunDec (fname, rettype, paramls, body, loc) ->
        let body' = copyConstPropFoldExp (SymTab.empty ()) body
        FunDec (fname, rettype, paramls, body', loc)

let optimiseProgram (prog : TypedProg) =
    List.map copyConstPropFoldFunDec prog
