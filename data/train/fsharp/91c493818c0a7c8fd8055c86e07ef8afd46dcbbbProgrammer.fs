module Programmer 

open System
open System.Windows
open System.Windows.Controls
open System.Windows.Data
open System.Windows.Media
open System.Windows.Input
open System.Collections.ObjectModel

[<AutoOpen>]
module private Helpers = 

    open DataModel

    module Chart = 
        let chart = Chart.createNewChart()
        let Ifon, Ksns = Chart.initializeProductChart chart  
        let showIfon (m : EEPROM.ViewModel)  = 
            m.ShowSeriesIfon Ifon.Points
        let showKsns (m : EEPROM.ViewModel)  = 
            m.ShowSeriesKsns Ksns.Points

    let hx = 
        List.zip
            [   yield! [ for x in '0'..'9' -> x] 
                yield! [ for x in 'A'..'F' -> x] 
                yield! [ for x in 'a'..'f' -> x] ]
            [   yield! [   for n in 0..15 -> byte n]
                yield! [   for n in 10..15 -> byte n] ]
        |> Map.ofList


    let tryParseByte x =    
        let len = String.length x
        let (~%%) n = hx.TryFind x.[n]
        if len=1 then %% 0 
        elif len=2 then 
            match %% 0, %% 1 with
            | Some b1, Some b2 ->
                Some( (b1 <<< 4) + b2 )
            | _ -> None
        else None

    let parse x = 
        match tryParseByte x with
        | Some v -> v
        | _ -> 0xffuy

    let showByte (b:byte) = 
        sprintf "%X%X" (( b &&& 0xf0uy) >>> 4) ( b &&& 0x0fuy)

    let mConv<'a> (convto: byte -> 'a) (convfrom : string -> byte) = 
        {   new IValueConverter with
                override __.Convert(x, _, _, _) = 
                    x :?> byte
                    |> convto
                    |> box
                override __.ConvertBack(x, _, _, _) = 
                    x |> string |> convfrom |> box }

        
    let hexConv = mConv showByte parse
    let fore x = 
        let color = if x<> 0xffuy then Colors.Aqua else  Colors.MidleAqua
        SolidColorBrush(color)
            
    let hexForeConv = mConv fore ( fun _ -> failwith "IValueConverter.ConvertBack hexForeConv" )

    let valueProperty n = PropertyPath(sprintf "Item2[%d].Value" n)

    let createCellTemplate n = 
        let t = DataTemplate()
        let tb = FrameworkElementFactory(typeof<TextBlock>)
        t.VisualTree <- tb
        tb.SetBinding
            (   TextBlock.TextProperty, 
                Binding(Path = valueProperty n, 
                        Converter = hexConv ) )
        tb.SetBinding
            (   TextBlock.ForegroundProperty, 
                Binding(Path = valueProperty n, 
                        Converter = hexForeConv ) )
        tb.SetValue(TextBlock.FontFamilyProperty, FontFamily("Consolas"))
        tb.SetValue(TextBlock.MarginProperty, Thickness(3.,3.,3.,3.))
        t

    let createCellEditTemplate n = 
        let t = DataTemplate()
        let tb = FrameworkElementFactory(typeof<TextBox>)
        t.VisualTree <- tb
        tb.SetBinding
            (   TextBox.TextProperty, 
                Binding(Path = valueProperty n, 
                        Mode = BindingMode.TwoWay,
                        NotifyOnTargetUpdated = true,
                        UpdateSourceTrigger  = UpdateSourceTrigger.PropertyChanged,
                        Converter = hexConv ) )
        tb.SetBinding
            (   TextBox.ForegroundProperty, 
                Binding(Path = valueProperty n, 
                        Converter = hexForeConv ) )
        tb.SetValue(TextBox.FontFamilyProperty, FontFamily("Consolas"))            
        tb.AddHandler
            (   TextBox.PreviewTextInputEvent, 
                TextCompositionEventHandler( fun sender e -> 
                    let textbox = sender :?> TextBox
                    let len = textbox.SelectionStart + e.Text.Length
                    e.Handled <- len > 2 ) )
        tb.AddHandler
            (   TextBox.LoadedEvent, 
                RoutedEventHandler( fun sender _ -> 
                    Documents.EditingCommands.ToggleInsert.Execute(null, sender :?> IInputElement ) ) )

        tb.AddHandler
            (   TextBox.PreviewKeyDownEvent, 
                KeyEventHandler( fun sender e -> 
                    let textbox = sender :?> TextBox
                    if e.Key = Key.Space then
                        e.Handled <- true ) )
        tb.AddHandler
            (   CommandManager.PreviewCanExecuteEvent,
                CanExecuteRoutedEventHandler( fun sender e -> 
                    if obj.Equals(e.Command, ApplicationCommands.Paste) then
                        e.CanExecute <- false
                        e.Handled <- true ) )            
        t

    let createColumn n = 
        DataGridTemplateColumn
            (   Header = intToHex 2 n,
                CellTemplate = createCellTemplate n,
                CellEditingTemplate = createCellEditTemplate n)

    let m = 
        let m = EEPROM.ViewModel(DataModel.createFlashArray())

        subscribePropertyChanged m <| fun e ->
            if e.PropertyName="Ifon" then
                Chart.showIfon m
            elif e.PropertyName="Ksns" then
                Chart.showKsns m        
        m

    let tpoints, setBytes = 

        let getPoints = 
            let choose = Seq.toList >> List.choose (function t,Some x -> Some (t,x) | _ -> None)
            let f = 
                Seq.map( fun (p :DataModel.CalculateTermo.Item) -> 
                    (p.T,p.I), (p.T, p.K) )          
                >> Seq.toList
                >> List.unzip
            fun xs ->
                let i,k = f xs
                choose i, choose k

        let temps = [ -20m; -5m; 0m; 5m; 20m; 30m; 35m; 40m; 45m; 50m ]
        let tpoints =  
            ObservableCollection<DataModel.CalculateTermo.Item>
                (   temps            
                    |> List.map( fun t -> { DataModel.CalculateTermo.Item.createNew() with T = t} ) )
        
        let getTemps() = 
            let tpoints = tpoints |> Seq.map( fun y -> y.T,y)
            Set.ofSeq ( Seq.map fst tpoints), Map.ofSeq tpoints
        
        subscribePropertyChanged m <| fun e  ->
            let isIfon = e.PropertyName="Ifon"
            if isIfon || e.PropertyName="Ksns" then 
                let ft = piecewiseLinearApproxi1 <| if isIfon then m.Ifon else m.Ksns
                let ts,ti = getTemps()
                ts |> Set.iter( fun t -> 
                    let y = ft t
                    if isIfon then ti.[t].I <- y else ti.[t].K <- y )
        
        let setBytes (bs : byte []) = 
            m.Bytes1 |> List.iter( fun b ->
                b.Value <- bs.[b.N] )                              
            tpoints.Clear()

            let ifon_t = piecewiseLinearApproxi1 m.Ifon 
            let ksns_t = piecewiseLinearApproxi1 m.Ksns

            temps |> List.iter ( fun t -> 
                DataModel.CalculateTermo.Item.create1 t (ifon_t t) (ksns_t t)
                |> tpoints.Add )
            Chart.showIfon m
            Chart.showKsns m

        let subs _ =
            PartiesView.curentPartyInfo.Party.Products |> Array.iter( fun p ->
                p.SendProgrammerView <- wpfCommnad1 <| fun () ->                    
                    let FIfon_mkA = Alchemy.FIfon_mkA p.InfoExt.Batch p.Product
                    let FKsns = Alchemy.FKsns p.InfoExt.Batch p.Product
                    setBytes p.Product.Flash
                    MainwindowViewMode.state.State <- MainwindowViewMode.ProgrFlash )
        subscribePropertyChanged PartiesView.curentPartyInfo subs
        subs()
        tpoints, setBytes

    let openFile = wpfCommnad1 <| fun () ->     
        let d = new Microsoft.Win32.OpenFileDialog()
        d.InitialDirectory <- exepath
        d.Title <- "Открыть любой файл"
        let r = d.ShowDialog()
        // Process open file dialog box results
        if r.HasValue && r.Value then    
            let f = IO.File.OpenRead d.FileName            
            let bx = DataModel.createFlashArray()
            try
                f.Read(bx,0, min (int f.Length) EEPROM_SIZE ) |> ignore
                setBytes bx
            with e -> 
                UI.Log.Jouranl.addError (sprintf "Не удалось открыть \"прошивку\" из файла %A" d.FileName) e.Message |> ignore

    let saveFile = wpfCommnad1 <| fun () ->     
        let d = new Microsoft.Win32.SaveFileDialog()
        d.InitialDirectory <- exepath
        d.Title <- "Сохранить \"прошивку\" в файл"
        let r = d.ShowDialog()
        // Process open file dialog box results
        if r.HasValue && r.Value then    
            try
                IO.File.WriteAllBytes(d.FileName, m.Source)
            with e -> 
                UI.Log.Jouranl.addError (sprintf "Не удалось сохранить \"прошивку\" в файл %A" d.FileName) e.Message |> ignore
            

  
[<PropertyChanged.ImplementPropertyChanged>]
type ProcessInfo = 
    {   mutable IsOpen : bool
        mutable Progress : int
        mutable N : int
        mutable Is64 : bool
        mutable Text : string  }
    member x.N1  with get() = x.N+1 and set v = x.N <- (v-1)

    member x.Max = EEPROM.addysCount
    member x.Begin() =
        x.Progress <- 0
        x.IsOpen <- true
    member x.End() =
        x.IsOpen <- false


let processInfo = 
    {   IsOpen  = false
        Progress  = 0
        Text = "" 
        N = 0
        Is64 = false }
    

let read() =     
    let bytes = DataModel.createFlashArray()
    processInfo.Begin()
    let r = EEPROM.addys |> List.fold( fun r (addy1,addy2) -> 
        match r with 
        | None when Thread2.isKeepRunning() ->
            processInfo.Text <- sprintf "Cчитывание \"прошивки\" %d, %d, %x-%x..." (processInfo.N+1) (if processInfo.Is64 then 64 else 16) addy1 addy2 
            let len = addy2-addy1+1
            let r = Prog.read processInfo.N addy1 len processInfo.Is64
            processInfo.Progress <- processInfo.Progress + len
            match r with 
            | Right readedBytes -> 
                for n in addy1..addy2 do
                    bytes.[n] <- readedBytes.[n-addy1]
            | _ -> ()
            r |> leftSome
        | r -> r ) None
    processInfo.End()
    match r with
    | Some _ -> ()
    | _ -> safe <| fun () ->
        setBytes bytes
    r

let setBytes = setBytes

let write() =     
    processInfo.Begin()
    let r = EEPROM.addys |> List.fold( fun r (addy1,addy2) -> 
        match r with 
        | None when Thread2.isKeepRunning() ->
            processInfo.Text <- sprintf "Запись \"прошивки\" %d, %d, %x-%x..." (processInfo.N+1) (if processInfo.Is64 then 64 else 16) addy1 addy2 
            let len = addy2-addy1+1
            let r = Prog.write processInfo.N m.Source.[addy1..addy2] addy1 processInfo.Is64
            processInfo.Progress <- processInfo.Progress + len            
            r 
        | r -> r ) None
    processInfo.End()
    r       

    

let initialize(mainWindow : UI.MainWindow, dataContext : Dynamic) =     
    [0..15] |> List.iter( createColumn >> mainWindow.DataGridFlashBytes.Columns.Add)
    let d = Dynamic()
    dataContext.["OpenFileFlash"] <- openFile
    dataContext.["SaveFileFlash"] <- saveFile
    dataContext.["Programmer"] <- d
    d.["Model"] <- m
    d.["TermoCalcItems"] <- tpoints
    d.["ProcessInfo"] <- processInfo
    

    mainWindow.ChartFlashBytesPlaceholder.Child <- Chart.chart