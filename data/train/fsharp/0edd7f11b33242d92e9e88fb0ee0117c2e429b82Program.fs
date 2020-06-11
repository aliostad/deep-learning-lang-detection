module Quiz.Program

open TextToKeyboard
open KeyboardInput
open Common
open FSharp.Data

let askCommand ((answer, answerKeyboardFormat), (ask: string)) =
    ask |> writeline
    ">" |> write
    let givenAnswer = readKeysUntilEnter()
    () |> writeEmptyLine
    if givenAnswer <> answerKeyboardFormat then
        sprintf "expected: ( %s )" answer |> writelineRed
        sprintf "%A" givenAnswer |> writelineRed
        sprintf "%A" answerKeyboardFormat |> writelineRed
    "####################" |> writelinePurple

let getQuizData() =
    let practice = CsvFile.Load("practice.csv")
    practice.Rows |> Seq.map(fun r -> r.[0], r.[1]) |> Array.ofSeq

let processQuizAsk (answer, question) =
    let answerPreProcessed = preProcess answer
    let answerKeyboardFormat = getConsoleKeys [] answerPreProcessed
    (answerPreProcessed, answerKeyboardFormat), question

let getQuiz() = getQuizData() |> Array.map processQuizAsk 

let randomQuizQuestion() =
   let rnd = System.Random()
   let cmds = getQuiz() 
   cmds.[rnd.Next(0, cmds.Length)]
   
[<EntryPoint>]
let main argv =
    Seq.initInfinite ( fun _ -> randomQuizQuestion() )
    |> Seq.iter askCommand
    System.Console.ReadKey() |> ignore
    0

