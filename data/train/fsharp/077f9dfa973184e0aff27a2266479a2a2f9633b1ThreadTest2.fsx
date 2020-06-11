open System
open System.Threading

(*
The CLR assigns each thread its own memory stack so that local variables are kept separate. In the next example, we define a method with a local variable, then call the method simultaneously on the main thread and a newly created thread:
*)
let Go () =
    // declare local variable cycles
    for cycles in [0..4] do
        printf "?"

(new Thread(Go)).Start()
Go ()

(*
 A separate copy of the cycles variable is created on each thread's memory stack, and so the output is, predictably, ten question marks. 
*)