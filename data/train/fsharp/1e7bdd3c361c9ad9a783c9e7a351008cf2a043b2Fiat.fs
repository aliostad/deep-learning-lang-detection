namespace H2W

module Fiat =
    open Client
    open System.IO

    type Fiat = {
        Endpoint: string
        Email: string
        Password: string
        Token: string
        File: string
        Cred: Credentials
        Quickstats: bool
        MaxLines: int option
        Handler: string -> Message.T list
        Verbose: bool
        NetworkAccess: bool
        Invalid: Error.T option
    }

    let getToken tokenFile = File.ReadAllLines(tokenFile).[0]
    let getTokenCredFromFile = getToken >> TokenCred

    let DefaultFiat = {
        Endpoint="";
        Email="";
        Password="";
        Token="";
        File=".h2wfsharptoken";
        Cred=(getTokenCredFromFile ".h2wfsharptoken");
        Quickstats=false;
        MaxLines=None;
        Handler=(fun s -> (Message.ResultMsg "" ""));
        Verbose=false;
        NetworkAccess=true;
        Invalid=None
    }

    let withUserCred fiat = {fiat with Cred=UserCred({Email=fiat.Email; Password=fiat.Password})}
    let withTokenFile fiat = {fiat with Cred=(getTokenCredFromFile fiat.File)}
    let withUrl url fiat = {fiat with Endpoint=(h2wUrl url)}
    let withHandler handler fiat = {fiat with Handler=handler}
    let withNoNetwork fiat = {fiat with NetworkAccess=false}
    let withTokenHandler fiat = {fiat with Handler=(ResponseHandler.tokenHandler fiat.File)}
    let withDashboardHandler fiat =
        match fiat.Quickstats with
        | true ->
            withHandler ResponseHandler.quickstatsHandler fiat
        | false ->
            withHandler (ResponseHandler.dashboardHandler fiat.MaxLines) fiat
    let asInvalid error description fiat =
        {fiat with Invalid=Some({Error=error; Description=description})}
