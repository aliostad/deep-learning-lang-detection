module test
(*
open Workflow

[<EntryPoint>]
let main args =
    let state =
        Map.empty
        |> create "register"
        |> create "pass"
        |> create "fail"
        |> add "register" (Response "pass")
        |> add "register" (Dependent "fail")
        |> add "register" (Exclusion "register")
        |> add "register" (Dependent "pass")
        |> add "pass" (Exclusion "fail")
        |> add "pass" (Exclusion "pass")
        |> add "fail" (Exclusion "pass")
        |> add "fail" (Exclusion "fail")
    showProcess state

    let s1 =
        match tryExecute "register" state with
        | Some s -> s
        | _ -> failwith "Aww"
    showProcess s1

    let s2 =
        match tryExecute "pass" s1 with
        | Some s -> s
        | _ -> failwith "Aww"
    showProcess s2

    let s3 =
        match tryExecute "fail" s1 with
        | Some s -> s
        | _ -> failwith "Aww"
    showProcess s3

    0*)