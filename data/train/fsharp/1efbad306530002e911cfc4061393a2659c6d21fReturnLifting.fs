namespace FSCL.Compiler.Processors

open FSCL.Compiler
open System.Collections.Generic
open System.Reflection
open System.Reflection.Emit
open Microsoft.FSharp.Quotations
open System

type ReturnLifting() =       
    let rec LiftReturn (expr:Expr, retV:Quotations.Var, potentialReturn, engine:TransformationStep) =
        match expr with
        | Patterns.Let(v, value, body) ->
            let pv = engine.Process(value)
            let pb = engine.Process(body)
            match pb with
            | Patterns.Var(var) ->
                let (retV, args) = engine.CompilerData("KERNEL_RETURN_TYPE").Value :?> (Var * Expr list)
                if var.Name = retV.Name then
                    Expr.Let(v, pv, Expr.Value(()))
                else
                    Expr.Let(v, pv, Expr.Var(var))
            | _ ->
                Expr.Let(v, value, LiftReturn(body, retV, true, engine))
        | Patterns.Sequential(e1, e2) ->
            let pe1 = engine.Process(e1)
            let pe2 = engine.Process(e2)
            Expr.Sequential(LiftReturn(pe1, retV, false, engine), LiftReturn(pe2, retV, true, engine))
        | ExprShape.ShapeLambda(v, e) ->
            let e1 = engine.Process(e)
            match e1 with
            | Patterns.Var(var) ->
                if var.Name = retV.Name then
                    Expr.Lambda(v, Expr.Value(()))
                else
                    Expr.Lambda(v, e1)
            | _ ->
                Expr.Lambda(v, LiftReturn(e, retV, true, engine))
        | ExprShape.ShapeVar(var) ->
            if var.Name = retV.Name && potentialReturn then   
                Expr.Value(())
            else         
                expr
        | ExprShape.ShapeCombination(o, args) ->
            let processed = List.map (fun e -> engine.Process(e)) args
            ExprShape.RebuildShapeCombination(o, List.map (fun el -> LiftReturn(el, retV, false, engine)) processed)
            
    interface TransformationProcessor with
        member this.Handle(expr, engine:TransformationStep) =
            if engine.CompilerData("KERNEL_RETURN_TYPE").IsNone then
                Unhandled
            else
                let retV, _ = engine.CompilerData("KERNEL_RETURN_TYPE").Value :?> (Var * Expr list)
                NewExpr(LiftReturn(expr, retV, true, engine))

