
module ConsoleApp
    open System

    let dontUnderstand () =
        Console.WriteLine("I don't understand your choice.")
        Console.WriteLine("Can you try again ?")
        true

    let printResult (res:string) = 
        Console.WriteLine(res)
        true

    let execTest (key:ConsoleKeyInfo) =
        Console.WriteLine(System.Environment.NewLine)
        match key.KeyChar with
        | 'a' -> PrimitiveObsession.testPrimitiveObsession () |> printResult
        | 'b' -> CopyOnWrite.testCopyOnWrite () |> printResult
        | 'q' -> false
        |  _  -> dontUnderstand ()

    let rec printMenu () =
        Console.WriteLine(System.Environment.NewLine)
        Console.WriteLine("Choose your test:")
        Console.WriteLine(" -> primitive obsession test (hit a)")
        Console.WriteLine(" -> copy on write test (hit b)")
        Console.WriteLine(" -> quit (hit q)")
        Console.WriteLine(System.Environment.NewLine)
        if (Console.ReadKey() |> execTest) then printMenu()
