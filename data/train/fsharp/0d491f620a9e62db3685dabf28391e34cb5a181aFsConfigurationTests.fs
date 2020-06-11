module FsConfigurationTests

open FSharp.Configuration
open FluentAssertions
open NUnit.Framework
open System.IO

type Config = YamlConfig<"Config.yaml">
type Order = YamlConfig<"Order.yaml">
type Process = YamlConfig<"Process.yaml">
type Country = YamlConfig<"Country.yaml">

let dll = System.Reflection.Assembly.GetCallingAssembly().Location
let path = System.IO.FileInfo(dll).Directory.FullName

[<Test>]
let shouldReadConfig() =
    let config = Config()
    config.DB.ConnectionString.Should().Be("Data Source=server1;Initial Catalog=Database1;Integrated Security=SSPI;", "_") |> ignore

[<Test>]
let shouldReadOrder() =
    let config = Order()
    config.customer.family.Should().Be("Gale", "_") |> ignore


[<Test>]
let shouldReadProcess() =
    let __ = "_";
    let config = Process()
    config.Load(Path.Combine(path,"Process.yaml"))
    config.ps.[0].``process``.Should().Be("A, B, C", __) |> ignore
    config.ps.[1].step.Count.Should().Be(2, __) |> ignore

[<Test>]
let shouldReadContry() =
    let config = Country()
    config.Load(Path.Combine(path,"Country.yaml"))
    config.content_prices.[0].country.Should().Be("AU", "_") |> ignore
    config.content_prices.[1].country.Should().Be("AT", "_") |> ignore

