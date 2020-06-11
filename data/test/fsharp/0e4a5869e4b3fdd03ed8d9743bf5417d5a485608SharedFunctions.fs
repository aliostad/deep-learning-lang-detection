[<AutoOpen>]
module fmud.SharedFunctions
    open System

    type Result<'TSuccess,'TFailure> = 
        | Success of 'TSuccess
        | Failure of 'TFailure

    let bind switchFunction twoTrackInput = 
        match twoTrackInput with
        | Success s -> switchFunction s
        | Failure f -> Failure f

    let anyWithSideEffects<'a> (f:'a -> bool) (s:seq<'a>) =
        let mutable ret = false
        for x in s do
            ret <- ret || f(x)
        ret

    let (@+) (set:Set<string>) (s:string) =
        let mutable copy = set;
        for each in s.Split(' ') do
            copy <- copy.Add each
        copy

    let  (@-) (set:Set<string>) (s:string) =
        let mutable copy = set;
        for each in s.Split(' ') do
            copy <- copy.Remove each
        copy

    let capitalise (str:string) =
        String.Concat(str.Substring(0, 1).ToUpper(), str.Substring(1))


