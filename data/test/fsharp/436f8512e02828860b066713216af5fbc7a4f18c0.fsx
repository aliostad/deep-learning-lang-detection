/// A type that inherits from FSharpFunc type (F# functions)
/// and overrides the Finalize method with custom handler
type FinalizableFunc<'T, 'R>(f, finalizer) = 
  inherit Microsoft.FSharp.Core.FSharpFunc<'T, 'R>()
  override x.Invoke(a) = f a
  override x.Finalize() = finalizer()

/// Create a function with custom finalizer
let finalizable (f:'T -> 'R) handler =
  // F# does not allow direct cast, so we need to box
  let ff = FinalizableFunc<'T, 'R>(f, handler)
  box ff :?> ('T -> 'R)

/// Create finalizable function & call it
let foo () =
  let f = 
    finalizable 
      (fun n -> n + 1) 
      (fun () -> printfn "bye!")
  f 1

/// The function will be collected on GC.Collect call
foo ()
System.GC.Collect()