module Input

open CoroutineMonad
open SFML.Window
//change the input to work with SFML

type InputBehavior<'a> = List<Keyboard.Key* 'a -> 'a>

let collection = [1;2;3;4;5]

for x in collection do printfn"%A" x

let CheckKB (key:Keyboard.Key) (change:'s -> 's) =
  fun (w:'w) (s:'s) ->
    if Keyboard.IsKeyPressed(key) then
      Done((), (change s))
    else
      Done((), s)

let ProcessInput (elem:'a) (ib:InputBehavior<'a>)=
  cs{
    for item in ib do CheckKB item
    return ()
  }

(*
let processInput (behavior : InputBehavior<'a>) =
    fun elem ->
        let KBinput = List.ofArray <| Keyboard.GetState().GetPressedKeys()
        List.fold (fun elem key ->
                       match (behavior.TryFind <| key) with
                       | Some func -> func elem dt
                       | None -> elem) elem KBinput*)