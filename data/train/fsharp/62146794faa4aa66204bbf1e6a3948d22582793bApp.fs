namespace H2W

module App =
    let main args =
        let fiat = ArgParser.Parse args
        let msgs =
            match fiat.Invalid with
            | Some(err) -> ResponseHandler.ErrorHandler err
            | None ->
                match fiat.NetworkAccess with
                | true ->
                    Client.Req(fiat.Endpoint, fiat.Cred)
                    |> Client.HitEndpoint
                    |> ResponseHandler.HandleResponse fiat.Handler
                | false ->
                    match System.IO.File.Exists fiat.File with
                    | true ->
                        System.IO.File.Delete fiat.File
                        sprintf "Token file '%s'" fiat.File |> Message.ResultMsg "DELETED"
                    | false ->
                        sprintf "Token file '%s' does not exist" fiat.File |> Message.ErrorMsg
        (fiat.Verbose, msgs)

    let Run args =
        main args
        |> Message.Filter
        |> Message.DumpMsgs

    let Test = main
