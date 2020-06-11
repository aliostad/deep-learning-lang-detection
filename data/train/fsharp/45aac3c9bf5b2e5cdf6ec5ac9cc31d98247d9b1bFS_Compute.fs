// * **********************************************************************************************
// * Copyright (c) Edmondo Pentangelo. 
// *
// * This source code is subject to terms and conditions of the Microsoft Public License. 
// * A copy of the license can be found in the License.html file at the root of this distribution. 
// * By using this source code in any fashion, you are agreeing to be bound by the terms of the 
// * Microsoft Public License.
// *
// * You must not remove this notice, or any other, from this software.
// * **********************************************************************************************

#light

open FS_AbstractSyntaxTree;
open FS_Utils;
open System.Collections.Generic;
open SymbolicDifferentiation.Core.Computation;

//Sequential
let processBinaryOpArgs f x y = (seq[(f x);(f y)])
let processFuncArgs f args = (Seq.map (fun arg -> f(arg)) args)

//Parallel
let Parallel asyncs = (Seq.of_array((Async.Run(Async.Parallel(asyncs)))))
let Execute x = x |> Array.of_seq |> Seq.of_array
let parallelProcessBinaryOpArgs f x y = (Parallel(seq[async { return Execute(f x) }; async { return Execute(f y) }]))
let parallelProcessFuncArgs f args = (Parallel(Seq.map (fun arg -> async { return Execute(f arg) }) args))


let private ExtractArguments args = 
    let ExtractArgument arg = match arg with
                              | Variable x -> x
                              | _ -> failwith "Only variable arguments are allowed in functions definitions"
    Seq.map ExtractArgument args


let seq_map3 f x y z = Seq.zip3 x y z |> Seq.map (fun (a,b,c) -> f a b c)

//Compute
let rec private Create (exp, seqMapXY, seqMapArgs, functions) = 
    let Process exp = Create(exp, seqMapXY, seqMapArgs, functions)
    let ProcessFun exp funs = Create(exp, seqMapXY, seqMapArgs, ComputationResult.MergeDictionaries(functions, funs))
    match exp with
    | Number n ->                         seq[n]
    | Variable x ->                       seq { yield! functions.Item(x) (seq[]) }
    | Binary(GreaterThan,x,y) ->          functions.Item("GreaterThan") (seqMapXY Process x y)
    | Binary(LessThan,x,y) ->             functions.Item("LessThan") (seqMapXY Process x y)
    | Binary(Add,x, y) ->                 functions.Item("Add") (seqMapXY Process x y)
    | Binary(Sub,x, y) ->                 functions.Item("Sub") (seqMapXY Process x y)
    | Binary(Mul,x, y) ->                 functions.Item("Mul") (seqMapXY Process x y)
    | Binary(Div,x, y) ->                 functions.Item("Div") (seqMapXY Process x y)
    | Binary(Pow,x, n) ->                 functions.Item("Pow") (seq[(Process x);(Process n)])
    | FunApp(name, args) ->        functions.Item(name)  (seqMapArgs Process args)
    | FunDecl(name, args, body) -> ComputationResult.CreateFunction(name, (ExtractArguments args), (ProcessFun body))
    | Cond(condit, succ, fail) ->  seq_map3 
                                        (fun (c:KeyValuePair<string, Atom>) s f -> 
                                                if (c.Value.Equals(true)) then s else f) 
                                        (Process condit) 
                                        (Process succ) 
                                        (Process fail)     
                                                
    
type Ret(exps, functions, seqMapXY, seqMapArgs) =
    member x.Execute() = 
            // Process Expressions and accumulate results
            let rec ProcessExps ((e: 'a seq), f) = 
                           match (List.of_seq e) with
                           | h :: t -> 
                                let result = ComputationResult.CreateDictionary(seq[Create(h, seqMapXY, seqMapArgs, f)])
                                let mergedResult = ComputationResult.MergeDictionaries(f, ComputationResult.ToFastFunc(result))
                                ProcessExps(t, mergedResult)
                           | [] -> f;                      
            ProcessExps(exps, functions)
                           

let Build = fun (exps, functions) ->  Ret((Seq.map (fun exp -> (ToFs exp)) exps), functions, processBinaryOpArgs, processFuncArgs)

let BuildParallel = fun (exps, functions) ->  Ret((Seq.map (fun exp -> (ToFs exp)) exps), functions, parallelProcessBinaryOpArgs, parallelProcessFuncArgs)