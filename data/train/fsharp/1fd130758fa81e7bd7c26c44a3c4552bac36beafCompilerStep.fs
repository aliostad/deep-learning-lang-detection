namespace FSCL.Compiler

open System
open System.Reflection
open System.Collections.Generic
open Microsoft.FSharp.Quotations

type CompilerGlobalState = Dictionary<string, obj>

type CompilerStepBase() =
    let compilerData = CompilerGlobalState()

    member this.SetCompilerGlobalState(t:CompilerGlobalState) =
        compilerData.Clear()
        for pair in t do
            compilerData.Add(pair.Key, pair.Value)

    member this.AddCompilerData(s, d) =
        if compilerData.ContainsKey(s) then
            compilerData.[s] <- d
        else
            compilerData.Add(s, d)

    member this.RemoveCompilerData(s) =
        if compilerData.ContainsKey(s) then
            compilerData.Remove(s) |> ignore

    member this.CompilerData(s) =
        if compilerData.ContainsKey(s) then
            Some(compilerData.[s])
        else
            None

    member this.CompilerDataCopy
        with get() =
            new CompilerGlobalState(compilerData)

[<AbstractClass>]
type CompilerStep<'T,'U>() =
    inherit CompilerStepBase()

    abstract member Run: 'T -> 'U

    static member (-->) (s1:CompilerStep<'T,'U>, s2:CompilerStep<'U,'W>) =
        new SequentialCompilerStep<'T,'U,'W>(s1, s2)

    static member (+) (s1:CompilerStep<'T,'U>, s2:CompilerStep<'S,'U>) =
        new ChoiceCompilerStep<'T,'S,'U>(s1, s2)


and SequentialCompilerStep<'T,'U,'W>(s1:CompilerStep<'T,'U>, s2:CompilerStep<'U,'W>) =
    inherit CompilerStep<'T,'W>()
    override this.Run(el) =
        let result1 = el |> s1.Run
        s2.SetCompilerGlobalState(s1.CompilerDataCopy)
        let result2 = s2.Run(result1)
        this.SetCompilerGlobalState(s2.CompilerDataCopy)
        result2

and ChoiceCompilerStep<'T,'U,'W> (s1:CompilerStep<'T,'W>, s2:CompilerStep<'U,'W>) =
    inherit CompilerStep<'T option * 'U option,'W>()
    override this.Run((e1,e2)) =
        if e1.IsSome then
            let result = s1.Run(e1.Value)
            this.SetCompilerGlobalState(s1.CompilerDataCopy)
            result
        else
            let result = s2.Run(e2.Value)
            this.SetCompilerGlobalState(s2.CompilerDataCopy)
            result
    
