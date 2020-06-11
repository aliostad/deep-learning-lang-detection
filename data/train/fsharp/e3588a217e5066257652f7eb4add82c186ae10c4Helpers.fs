namespace KingmakerFox.ExtensionMethods

module Helpers =

    open System
    open System.Diagnostics
    open System.Diagnostics.CodeAnalysis
    open Newtonsoft.Json

    [<ExcludeFromCodeCoverage>]
    let ConsoleSetup() =
        System.Console.BackgroundColor <- ConsoleColor.DarkGreen
        System.Console.ForegroundColor <- ConsoleColor.White
        System.Console.WindowWidth <- 160

    let BytesToString (b: byte[]) =
        let result = System.Text.Encoding.ASCII.GetString(b)
        result

    [<ExcludeFromCodeCoverage>]
    let ProcessTime (sw:Stopwatch) =
        let processTime =
            sw.Elapsed.Hours.ToString("00") + ":" +
            sw.Elapsed.Minutes.ToString("00") + ":" +
            sw.Elapsed.Seconds.ToString("00") + ":" +
            sw.Elapsed.Milliseconds.ToString("000")
        processTime

    let JsonSerialize x =
        let result = JsonConvert.SerializeObject(x)
        result

    let JsonDeserialize x =
        let result = JsonConvert.DeserializeObject(x)
        result
