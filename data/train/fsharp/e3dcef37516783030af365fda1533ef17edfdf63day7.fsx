open System
open System.IO



let input = File.ReadAllLines (@"..\data\day07.txt")

type SyntaxTokens =
  | AND
  | OR 
  | LSHIFT
  | RSHIFT
  | NOT
  | ARROW
  | Value of int
  | Operator of string

let processToken token =
  match token with
  | "NOT" -> NOT 
  | "AND" -> AND
  | "OR" -> OR
  | "LSHIFT" -> LSHIFT
  | "RSHIFT" -> RSHIFT
  | "->" -> ARROW    
  | operator -> 
      match Int32.TryParse (operator) with
      | true, value ->  Value value
      | false , _ ->Operator operator

let eval(circuit ) =
  match circuit with
  | x::xs when (x :? Value)  ->  
  | x::y:: xs when x :? Value and  

let circuit (instructions: string) =
  let procLine (x:string) =        
    let line = x.Split(' ') |> Seq.map(fun x -> processToken x)
    line     

  instructions.Split ('\n')
  |> Seq.map(fun x-> procLine x)

  

  
