module Speedtest.Logger.Console.Configuration

open System
open System.IO
open Microsoft.Extensions.Configuration
open Microsoft.Extensions.Configuration.Json
open Microsoft.Extensions.Configuration.Binder

open Speedtest.Logger.Speedtester

type Config = {
    Sites: Url list
    ApiUrl: string
}

let config =
    let c =
        ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json")
            .Build()

    {
        Sites = c.GetSection("test-sites").Get<string[]>() |> List.ofArray |> List.map (Url)
        ApiUrl = c.GetValue<string>("speedtest-api")
    }