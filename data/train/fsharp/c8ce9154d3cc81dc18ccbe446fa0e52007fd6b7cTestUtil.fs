namespace ComputationExpressions.Tests

// copy from https://github.com/BasisLib/Basis.Core/blob/f48ed463699ae0235aa58623d0f46c754a6f7326/Basis.Core.Tests/TestUtils.fs

type Disposable<'T>(x: 'T) =
  let mutable f: unit -> unit = fun () -> ()
  member this.Value = x
  member this.F with set v = f <- v
  interface System.IDisposable with
    member this.Dispose() =
      f ()

[<AutoOpen>]
module TestSyntax =

  open Persimmon

  type TestBuilder with
    member this.TryWith(f, h) = try f () with e -> h e
    member this.TryFinally(f, g) = try f () finally g ()
