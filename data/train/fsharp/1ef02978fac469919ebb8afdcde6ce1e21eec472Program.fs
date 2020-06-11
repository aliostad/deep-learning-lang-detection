open System
open System.Windows.Forms
open Gma.System.MouseKeyHook
open Gma.System.MouseKeyHook.Implementation
open System.Drawing

let fuck1 () =
    let hook = Hook.GlobalEvents()

    let keyHandler = KeyEventHandler(fun sender e ->
        if e.KeyCode = Keys.F1 then
            e.SuppressKeyPress <- true
            printfn "Showing jump UI"
    )

    hook.KeyDown.AddHandler keyHandler

    AppDomain.CurrentDomain.ProcessExit.Add <| fun e ->
        hook.KeyDown.RemoveHandler keyHandler
        hook.Dispose()
        printfn "Bye-bye"
    printfn "Listening to your fucking keyboard..."

    let form = new Form()
    form.Closed.Add <| fun e -> Environment.Exit(0)
    form.ShowDialog() |> ignore

let fuck2 () =
    let windowWidth = 1024
    let widhtHeight = 768
    let cellsHorizontal = 10
    let cellsVertical = 10
    let bottomBarHeight = 20
    let dotNameColor = Brushes.DarkGray
    let matchedDotNameColor = Brushes.Blue

    let charSequence = System.Text.StringBuilder()

    let form = new Form()
    form.Width <- windowWidth
    form.Height <- widhtHeight
    form.Closed.Add <| fun e -> Environment.Exit(0)

    let drawShit () =
        let crect = form.ClientRectangle

        use g = form.CreateGraphics()
        use font = new Font("Consolas", 10.0f)
        use boldFont = new Font("Consolas", 10.0f, FontStyle.Bold)
        let pen = Pens.Green
        let cellWidth = crect.Width / cellsHorizontal
        let cellHeight = crect.Height / cellsVertical

        let dots = ResizeArray()
        dots.Add "fuck"
        let mutable dotCount = 0

        let rec makeDots fromX fromY =
            dotCount <- dotCount + 1
            let dotName = dotCount.ToString()

            g.DrawRectangle(pen, fromX, fromY, 2, 2)
            let input = charSequence.ToString()
            let firstNonMatchingIndex = Seq.tryFind (fun i -> i >= dotName.Length || input.[i] <> dotName.[i]) <| seq {0..input.Length - 1}
            let matchedPrefixLen = match firstNonMatchingIndex with
                                   | None -> input.Length
                                   | Some x -> x

            // g.FillRectangle(Brushes.Yellow, fromX, fromY, 10, 10)
            g.DrawString(dotName, font, dotNameColor, (float32 fromX), (float32 fromY))
            g.DrawString(dotName.Substring(0, matchedPrefixLen), boldFont, matchedDotNameColor, (float32 fromX), (float32 fromY))

            let mutable nextX = fromX + cellWidth
            let mutable nextY = fromY
            if nextX > crect.Width - 1 then
                nextX <- 0
                nextY <- nextY + cellHeight
            if nextY <= widhtHeight - 1 then
                makeDots nextX nextY

        makeDots 0 0
        // printfn "dotCount = %A" dotCount

        g.FillRectangle(Brushes.DarkSlateGray, 0, crect.Height - bottomBarHeight, crect.Width, bottomBarHeight)
        g.DrawString(charSequence.ToString(), font, Brushes.White, 0.0f, float32 (crect.Height - bottomBarHeight))

    form.Paint.Add <| fun e ->
        drawShit ()

    let hook = Hook.GlobalEvents()

    let keyHandler = KeyEventHandler(fun sender e ->
        if e.KeyValue >= (int '0') && e.KeyValue <= (int '9') then
            // printfn "zzzz %A" (char e.KeyValue)
            charSequence.Append((char e.KeyValue)) |> ignore
        drawShit ()
        if e.KeyCode = Keys.F1 then
            e.SuppressKeyPress <- true
            printfn "Showing jump UI"
    )

    hook.KeyDown.AddHandler keyHandler

    AppDomain.CurrentDomain.ProcessExit.Add <| fun e ->
        hook.KeyDown.RemoveHandler keyHandler
        hook.Dispose()
        printfn "Bye-bye"
    printfn "Listening to your fucking keyboard..."

    form.ShowDialog() |> ignore

[<EntryPoint>]
let main argv =
    fuck2 ()
    0 // Exit code


