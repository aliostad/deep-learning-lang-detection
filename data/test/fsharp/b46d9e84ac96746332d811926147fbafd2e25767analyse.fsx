#load "./../common.fsx"
#load "./../Day12/shared.fsx"
#load "./solution.fsx"

open Common 
open Shared
open Solution


let getState (str: string) = 
  let [a;b;c;d] = str.TrimEnd(']').TrimStart('[') |> String.split ';' |> Seq.map(Int.parse) |> List.ofSeq
  [ A, a; B, b; C, d; D, d] |> Map.ofList

let hasMultipleOfA (mapA : Map<_,_>, mapB :Map<_,_>) = 
  let aA = mapA.[A]
  let aB = mapB.[A]
  aA <> 0 
  && aB % aA = 0 
  && (aB / aA) > 1 
  && (mapA.[B] = mapB.[B] 
  && mapA.[C] = mapB.[C] 
  && mapA.[D] = mapB.[D])

// Parse State from saved file
let x = 
  System.IO.File.ReadLines(__SOURCE_DIRECTORY__ + "./lOut")
  |> Seq.mapi(fun i s -> (i, getState s))
  |> Seq.toList

(*
Try to identify states in which A is multiplied by a factor
*)
let y = 
  x
  |> List.allPairs
  |> Seq.filter(fun ((i, mA), (j, mB)) -> i < j)
  |> Seq.filter(fun ((i, mA), (j, mB)) -> hasMultipleOfA (mA, mB))
  |> Seq.take 1
  |> Seq.toList

(*
  cpy b c
  inc a
  dec c
  jnz c -2

  This set of instructions adds a copy of b to what is in A

  cpy b c     |
  inc a       |
  dec c       |
  jnz c -2    | Adds a copy of what is in B to A
  dec d
  jnz d -5

  This set of instructions add a copy of b to whatever is in A, d times

*)

let program (initialState : ProgramStateEx) = 
  Seq.unfold(fun ((instructionState : InstructionState, (registerState, ptr)), counter) ->
    match instructionState.TryFind ptr with
    | None -> None
    | Some instruction -> 
        let newState = InstructionEx.execute instruction (instructionState, (registerState, ptr))
        let (_, (registers, _)) = newState
        let message = sprintf "%A, Instruction: %A" ( registerState |> Map.toList |> List.map snd) instruction
        Some ((counter, registerState, instruction), (newState, counter + 1))
    ) (initialState, 0)
  |> Seq.map(fun (_, s, i) -> i)
  |> Seq.take 10
  |> Seq.iter(printfn "%A")