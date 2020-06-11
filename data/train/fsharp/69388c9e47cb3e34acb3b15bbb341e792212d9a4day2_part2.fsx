open System

printfn "Advent of code 2016. Day 2 problem 2"
printfn "http://adventofcode.com/2016/day/2"

let input = System.IO.File.ReadAllLines(__SOURCE_DIRECTORY__+ @"\day2_part1_input.txt");
let input_example_1 = [|""; "RRDDD"; "DURRL"; "LUUUR"|] // 5DB3

let bathroom_procedure (button : char) (procedure : char) =
  match (procedure, button) with
  | ('D', '1') -> '3'
  | ('R', '2') -> '3'
  | ('D', '2') -> '6'
  | ('U', '3') -> '1'
  | ('D', '3') -> '7'
  | ('L', '3') -> '2'
  | ('R', '3') -> '4'
  | ('D', '4') -> '8'
  | ('L', '4') -> '3'
  | ('R', '5') -> '6'
  | ('U', '6') -> '2'
  | ('D', '6') -> 'A'
  | ('L', '6') -> '5'
  | ('R', '6') -> '7'
  | ('U', '7') -> '3'
  | ('D', '7') -> 'B'
  | ('L', '7') -> '6'
  | ('R', '7') -> '8'
  | ('U', '8') -> '4'
  | ('D', '8') -> 'C'
  | ('L', '8') -> '7'
  | ('R', '8') -> '9'
  | ('L', '9') -> '8'
  | ('U', 'A') -> '6'
  | ('R', 'A') -> 'B'
  | ('U', 'B') -> '7'
  | ('D', 'B') -> 'D'
  | ('L', 'B') -> 'A'
  | ('R', 'B') -> 'C'
  | ('U', 'C') -> '8'
  | ('L', 'C') -> 'B'
  | ('U', 'D') -> 'B'
  | _ -> button

let process_procedure (button : char) (procedure : string)  =
  procedure
  |> Seq.toList
  |> List.fold bathroom_procedure button

input
|> Array.scan process_procedure '5'
|> Array.tail
|> System.String