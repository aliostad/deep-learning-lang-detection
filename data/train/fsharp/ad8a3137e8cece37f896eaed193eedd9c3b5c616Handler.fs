module Handler
open ServiceShared
open NServiceBus
open System
open System.Text.RegularExpressions
type MessageHandler() = 
    interface IHandleMessages<SendJoke> with
        member this.Handle(message:SendJoke) = 
            Console.Clear()
            let numSentences =
                let isSentenceEndChar c = match c with
                                          | '.' | '!' | '?' -> true
                                          | _ -> false
                message.Message |> Seq.filter isSentenceEndChar
                                |> Seq.length
            let words = Regex.Split(message.Message, "\s+")
            let numWords = words.Length

            printfn "%s" message.Message 
            printfn "Joke contains:"
            numSentences  |> printfn "%d sentences"
            numWords      |> printfn "%d words"

