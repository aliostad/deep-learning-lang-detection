module NorthHorizon.RxCop.Ops

open System
open System.Collections
open System.Reactive.Linq
open Microsoft.FxCop.Sdk

let resourceFile = "Rules"
let resourceAsm = System.Reflection.Assembly.GetCallingAssembly()

let getTypeNode (t : Type) =
    AssemblyNode
        .GetAssembly(t.Assembly.Location)
        .GetType(Identifier.For(t.Namespace), Identifier.For(t.Name))

let getInterfaceNode (t : Type) =
    match getTypeNode t with
    | :? InterfaceNode as i -> i
    | _ -> failwith "Given type is not an interface"

let getGeneric (m : Method) = if m.Template <> null then m.Template else m

let getName (m : Method) = (getGeneric m).Name.Name

let rec processMethodCalls (rule : IRule) (processor : MethodCall -> Option<Problem>) (mbr : Member) : ProblemCollection =
    let problems = new ProblemCollection(rule)
    
    let rec processMbrs mbrs = Seq.iter processMbr mbrs
    and processMbr (mbr : Member) =
        let rec processStmts stmts = Seq.iter processStmt stmts
        and  processStmt (stmt : Statement) =
            let rec processExprs exprs = Seq.iter processExpr exprs  
            and processExpr (expr : Expression) = 
                match expr with
                | :? UnaryExpression as ur ->
                    processExpr ur.Operand
                | :? BinaryExpression as br -> 
                    processExpr br.Operand1
                    processExpr br.Operand2
                | :? TernaryExpression as tr ->
                    processExpr tr.Operand1
                    processExpr tr.Operand2
                    processExpr tr.Operand3
                | :? NaryExpression as nr ->
                    processExprs nr.Operands
                    match nr with
                    | :? MethodCall as mc -> 
                        match processor mc with
                        | Some p -> problems.Add(p)
                        | None -> ()
                    | _ -> ()
                | _ -> ()

            match stmt with
            | :? AssignmentStatement as astmt ->
                processExpr astmt.Source
                processExpr astmt.Target
            | :? Block as b -> 
                processStmts b.Statements
            | :? Branch as b ->
                processExpr b.Condition
                processStmt b.Target
            | :? ExpressionStatement as es ->
                processExpr es.Expression
            | :? TryNode as tn ->
                processStmt tn.Block
                processStmts tn.Catchers
                processStmt tn.Finally
                processStmt tn.FaultHandler
            | :? CatchNode as cn ->
                processStmt cn.Block
                processStmt cn.Filter
                processExpr cn.Variable
            | :? FinallyNode as fn ->
                processStmt fn.Block
            | :? FaultHandler as fh ->
                processStmt fh.Block
            | :? Filter as f ->
                processExpr f.Expression
                processStmt f.Block
            | :? EndFilter as ef ->
                processExpr ef.Value
            | :? SwitchInstruction as si ->
                processExpr si.Expression
                processStmts si.Targets
            | :? ThrowNode as tn ->
                processExpr tn.Expression
            | _ -> ()

        match mbr with
        | :? Method as x ->
            processStmts x.Body.Statements
        | :? PropertyNode as pn ->
            processMbr pn.Getter
            processMbr pn.Setter
        | _ -> ()

    processMbr mbr
    problems