open System

printfn "Advent of code 2016. Day 2 problem 1"
printfn "http://adventofcode.com/2016/day/2"

let input = System.IO.File.ReadAllLines(__SOURCE_DIRECTORY__+ @"\day2_part1_input.txt");
let input_example_1 = [|"ULL"; "RRDDD"; "LURDL"; "UUUUD"|] // 1985

let bathroom_procedure (button : int) (procedure : char) =
  match (procedure, button) with
  | ('R', 1) -> 2
  | ('D', 1) -> 4
  | ('R', 2) -> 3
  | ('D', 2) -> 5
  | ('L', 2) -> 1
  | ('D', 3) -> 6
  | ('L', 3) -> 2
  | ('U', 4) -> 1
  | ('D', 4) -> 7
  | ('R', 4) -> 5
  | ('U', 5) -> 2
  | ('D', 5) -> 8
  | ('L', 5) -> 4
  | ('R', 5) -> 6
  | ('U', 6) -> 3
  | ('D', 6) -> 9
  | ('L', 6) -> 5
  | ('U', 7) -> 4
  | ('R', 7) -> 8
  | ('U', 8) -> 5
  | ('L', 8) -> 7
  | ('R', 8) -> 9
  | ('U', 9) -> 6
  | ('L', 9) -> 8
  | _ -> button

let process_procedure (button : int) (procedure : string)  =
  procedure
  |> Seq.toList
  |> List.fold bathroom_procedure button

input
|> Array.scan process_procedure 5
|> Array.tail
