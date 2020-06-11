namespace FSCL.Compiler

open System
open System.Reflection
open System.Collections.Generic
open Microsoft.FSharp.Quotations

type TransformationProcessor =    
    abstract member Handle : Expr * TransformationStep -> TransformationResult

and TransformationResult =
    | NewExpr of Expr
    | Unhandled

and TransformationStep() = 
    inherit CompilerStep<Expr, Expr>()

    member val TransformationProcessors = new List<TransformationProcessor>() with get

    member this.Process(expression: Expr) =
        // At first, check generic processors (for complex constructs)
        let mutable index = 0
        let mutable output = Unhandled        
        while output = Unhandled && (index < this.TransformationProcessors.Count) do
            output <- this.TransformationProcessors.[index].Handle(expression, this)
            index <- index + 1
        match output with
        | Unhandled ->
            match expression with
            | ExprShape.ShapeVar(v) ->
                Expr.Var(v)
            | ExprShape.ShapeLambda(v, e) ->
                let r = this.Process(e)
                Expr.Lambda(v, r)
            | ExprShape.ShapeCombination(o, args) ->
                let filtered = List.map (fun el -> this.Process(el)) args
                // Process the expression
                let newExpr = ExprShape.RebuildShapeCombination(o, filtered)
                newExpr
        | NewExpr(e) ->
            e
            
               
    override this.Run(body:Expr) =
        this.Process(body)
        


