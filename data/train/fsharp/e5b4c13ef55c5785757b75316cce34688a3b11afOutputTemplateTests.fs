module OutputTemplateTests

open Expecto
open Serilog
open System

[<Tests>]
let tests =

  use testApi = new TestApi()

  let uri = testApi.Start()

  let logger = LoggerConfiguration().MinimumLevel.Verbose().WriteTo.Scalyr("token", "host", "app", Nullable 1, TimeSpan.FromMilliseconds 100. |> Nullable, scalyrUri = uri, outputTemplate = "{Level} {Message}").CreateLogger()

  logger.Verbose("HELLO")

  testApi.Continue.WaitOne(1000) |> ignore

  let verboseLog = testApi.Received.[0]

  testCase "message attr is set" <| fun _ -> Expect.equal (verboseLog |> getFirstEvent |> getAttrs |> getValue "message") "Verbose HELLO" ""
