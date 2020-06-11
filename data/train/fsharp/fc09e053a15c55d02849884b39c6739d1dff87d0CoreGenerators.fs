[<AutoOpen>]
module EasyNetQ.ProcessManager.Tests.CoreGenerators

open EasyNetQ.ProcessManager
open FsCheck

type CoreGenerators =
    static member CorrelationId() =
        Arb.convert (fun (NonEmptyString s) -> CorrelationId s) (fun (CorrelationId c) -> NonEmptyString c) <| Arb.Default.NonEmptyString()
    static member StepName() =
        Arb.convert (fun (NonEmptyString s) -> StepName s) (fun (StepName c) -> NonEmptyString c) <| Arb.Default.NonEmptyString()
    static member TimeSpan() =
        Gen.choose(1000, 100000)
        |> Gen.map (System.TimeSpan.FromMilliseconds << float)
        |> Arb.fromGen

