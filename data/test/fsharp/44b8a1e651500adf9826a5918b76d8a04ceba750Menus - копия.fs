module Ankat.View.Menus

open System
open System.Windows.Forms
open System.Drawing
open System.Collections.Generic
open System.ComponentModel
open System.ComponentModel.DataAnnotations

open MyWinForms.TopDialog
open MainWindow
open Ankat.ViewModel.Operations
open Thread2
open Ankat
open Ankat.PartyWorks
open Ankat.View
open Pneumo

[<AutoOpen>]
module private Helpers =
    type P = Ankat.ViewModel.Product     
    let party = AppContent.party
    let popupDialog = MyWinForms.PopupDialog.create
    type Dlg = MyWinForms.PopupDialog.Options
    let none _ = None
    let form = MainWindow.form


    let getSelectedProducts() = 
        seq{ for x in gridProducts.SelectedCells -> x.RowIndex, x.OwningRow }
        |> Map.ofSeq
        |> Map.toList
        |> List.map( fun (_,x) -> x.DataBoundItem :?> P )

    let simpleMenu = MyWinForms.Utils.buttonsPopupMenu (new Font("Consolas", 12.f)) ( Some 300 ) 

    let popupConfig = MyWinForms.Utils.popupConfig


let popupNumberDialog<'a>     
    prompt title tryParse work 
    (btn : Button) 
    (parentPopup : MyWinForms.Popup) =
    let tb = new TextBox(Width = 290, Text = "")                    
    let dialog,validate  = 
        popupDialog 
            { Dlg.def() with 
                Text = Some prompt
                ButtonAcceptText = "Применить" 
                Title = title
                Width = 300
                Content = tb }
            ( fun () -> 
                tryParse tb.Text)
            ( fun (value : 'a) ->  
                parentPopup.Hide()
                work value ) 
    tb.TextChanged.Add <| fun _ -> validate()                        
    dialog.Show btn

let modbusToolsPopup = 
    [   yield "Установка адреса", (fun _ _ -> setAddr())
        yield!
            Command.valuesList
            |> List.filter( (<>) CmdSetAddr ) 
            |> List.map( fun cmd -> 
                (sprintf "MDBUS: %s" cmd.What), 
                    popupNumberDialog 
                        (sprintf "Введите значение аргумента команды %A" cmd.What)
                        cmd.What
                        String.tryParseDecimal
                        (fun value -> sendCommand (cmd,value) ) ) ]
    |> simpleMenu
    

let pneumoToolsPopup = 
    
    [   yield! Pneumo.Clapan.valuesList |> List.map ( fun gas -> 
            gas.What, fun _ _   -> 
                PartyWorks.Pneumoblock.switch gas )
        yield "Выкл.", fun _ _ -> 
            PartyWorks.Pneumoblock.close()  ]
    |> simpleMenu
    
let termoToolsPopup = 

    let setpoint = 
        popupNumberDialog 
            "Введите значение уставки термокамеры"
            "Задать уставку термокамеры"
            String.tryParseDecimal
            PartyWorks.TermoChamber.setSetpoint
    [   yield "Старт", fun _ _ -> PartyWorks.TermoChamber.start()
        yield "Стоп", fun _ _ -> PartyWorks.TermoChamber.stop()
        yield "Уставка", setpoint   ]
    |> simpleMenu
    

let private initPgsEdit  =
    let updPanelHeight(p:Panel) =
        p.Height <-
            List.fold (+) 0 [ for c in p.Controls do if c.Visible then yield c.Height ]

    let visClapans() = 
        let t = party.getProductType()                
        [   yield Gas1
            yield S1Gas2
            match t.Sensor with
            | IsCO2Sensor true -> yield S1Gas2CO2
            | _ -> ()
            yield S1Gas3
            match t.Sensor2 with
            | Some _ -> 
                yield S2Gas2
                yield S2Gas3 
            | _ -> () ]
        |> Set.ofList

    let addClapan p clapan =
        let x = new TextBox( Parent = p, Dock = DockStyle.Top )
        //let p1 = new Panel(Parent = p, Dock = DockStyle.Top, Height = 1 )

        let p3 = new Label(Parent = p, Dock = DockStyle.Top, AutoSize = true,
                            Text = Pneumo.Clapan.what clapan )
        //let p2 = new Panel(Parent = p, Dock = DockStyle.Top, Height = 1 )
        let upd() = 
            x.Text <- party.GetPgs clapan |> string

        let rec textChangedHandler = EventHandler( fun _ _ ->
            Runtime.PropertyChanged.removeAction party pgsPropertyChangedHandler        
            let t = party.getProductType()
            let pgs = 
                String.tryParseDecimal x.Text
                |> Option.getWith( ProductType.getPgsConc t clapan )
            Runtime.PropertyChanged.addHandler party pgsPropertyChangedHandler 
            )
        and pgsPropertyChangedHandler = PropertyChangedEventHandler(fun _ evt -> 
            if evt.PropertyName = Prop.pgs clapan then
                x.TextChanged.RemoveHandler textChangedHandler
                upd()
                x.TextChanged.AddHandler textChangedHandler
            )

        upd()
        Runtime.PropertyChanged.addHandler party pgsPropertyChangedHandler
        x.TextChanged.AddHandler textChangedHandler        
        Runtime.PropertyChanged.add party <| fun evt -> 
            if evt.PropertyName = "ProductType" then
                let vis = Set.contains clapan (visClapans())
                x.Visible <- vis
                //p1.Visible <- vis
                //p2.Visible <- vis
                p3.Visible <- vis
                updPanelHeight p

    let pgsPlaceholder = new Panel(Parent = TabsheetParty.BottomTab, Dock = DockStyle.Top)
    Clapan.valuesList |> List.rev |> List.iter (addClapan pgsPlaceholder)

    let rec h = EventHandler(fun _ _ -> 
        updPanelHeight pgsPlaceholder
        form.Activated.RemoveHandler h
        )
    form.Shown.AddHandler h
    fun () -> ()
  
let private initComboBoxProdType = 
    let x = myCombobox()
    x.Dock <- DockStyle.Top 
    x.Parent <- TabsheetParty.BottomTab
    let types = ProductType.values

    types |> List.iter(ProductType.what >> x.Items.Add >> ignore )

    let upd() = 
        let h,_ = party.Party
        
        x.SelectedIndex <- 
            ProductType.values 
            |> List.tryFindIndex ( (=) h.ProductType ) 
            |> Option.getWith (-1)
        
    let rec selectedIndexChangedHandler = EventHandler( fun _ _ ->
        Runtime.PropertyChanged.removeAction party productTypePropertyChangedHandler        
        let n = x.SelectedIndex
        let t = if n < 0 || n > types.Length - 1 then ProductType.first else types.[n]
        let h,xs = party.Party
        party.Party <- {h with ProductType = t}, xs
        Runtime.PropertyChanged.addHandler party productTypePropertyChangedHandler 
        )

    and productTypePropertyChangedHandler = PropertyChangedEventHandler(fun _ evt -> 
        if evt.PropertyName = "ProductType" then
            x.SelectedIndexChanged.RemoveHandler selectedIndexChangedHandler
            upd()
            x.SelectedIndexChanged.AddHandler selectedIndexChangedHandler
        )
    upd()
    Runtime.PropertyChanged.addHandler party productTypePropertyChangedHandler
    x.SelectedIndexChanged.AddHandler selectedIndexChangedHandler

    let _ = new Panel(Parent = TabsheetParty.BottomTab, Dock = DockStyle.Top, Height = 1 )
    
    let _ = new Label(Parent = TabsheetParty.BottomTab, Dock = DockStyle.Top, AutoSize = true,
                      Text = "Исполнение")
    let _ = new Panel(Parent = TabsheetParty.BottomTab, Dock = DockStyle.Top, Height = 1 )

    Thread2.IsRunningChangedEvent.addHandler <| fun (_,isRunning) ->
        x.Enabled <- not isRunning 

    fun () -> ()

let private initButtons1 = 
    let buttons1placeholder = 
        new Panel
            (   Parent = TabsheetParty.BottomTab, Dock = DockStyle.Top, Height = 89 )

    let imgbtn1 left top key tooltip f = 
        let x = 
            new Button( Parent = buttons1placeholder, Left = left, Top = top,
                        ImageKey = key, Width = 40, Height = 40,
                        FlatStyle = FlatStyle.Flat,
                        ImageList = Widgets.Icons.instance.imageList1)
        MainWindow.setTooltip x tooltip
        x.Click.Add <| fun _ ->  
            f x
        x

    let imgbtn left top key tooltip f = imgbtn1 left top key tooltip f 

    let btnOpenParty = imgbtn 3 3 "open" "Открыть ранее сохранённую партию" OpenPartyDialog.showDialog
    let btnNewParty = imgbtn 46 3 "add" "Создать новую партию" PartyProductsDialogs.createNewParty

    let btnAddProd = imgbtn 3 46 "additem" "Добавить в партию новые приборы" PartyProductsDialogs.addProducts
    let btnDelProd = 
        let b = imgbtn1 46 46 "removeitem" "Удалить выбранные приборы из партии" PartyProductsDialogs.deleteProducts
        b.Visible <- false
        let g = gridProducts
        g.SelectionChanged.Add <| fun _ ->
            b.Visible <- g.SelectedCells.Count > 0 
        b

    Thread2.IsRunningChangedEvent.addHandler <| fun (_,isRunning) ->
        [btnOpenParty; btnNewParty; btnAddProd; btnDelProd ]
        |> Seq.iter(fun b -> b.Enabled <- not isRunning )

    let _ = imgbtn 89 3 "todo" "Выбрать опрашиваемые параметры" ( fun b ->
        let popup = 
            MyWinForms.Utils.popupConfig 
                "Опрашиваемые параметры" 
                (ViewModel.SelectPhysVars()) 
                PropertySort.Alphabetical
        popup.Closed.Add( fun _ ->
           View.Products.updatePhysVarsGridColsVisibility()  )
        popup.Show b )    

    fun () -> ()

open Ankat.View.TopBar

let initialize =
    let buttonRun = new Button( Parent = TopBar.thread1ButtonsBar, Dock = DockStyle.Left, AutoSize = true,
                                ImageKey = "run",
                                Text = (sprintf "%A" Thread2.scenary.Value.FullName),
                                ImageAlign = ContentAlignment.MiddleLeft,
                                TextImageRelation = TextImageRelation.ImageBeforeText,
                                TextAlign = ContentAlignment.MiddleCenter,
                                FlatStyle = FlatStyle.Flat,
                                ImageList = Widgets.Icons.instance.imageList1)
    TopBar.thread1ButtonsBar.Controls.Add <| new Panel(Dock = DockStyle.Left, Width = 3)
    MainWindow.setTooltip buttonRun ("Выполнить " + buttonRun.Text)
    buttonRun.Click.Add <| fun _ ->  
        Thread2.run NeedStopHardware Thread2.scenary.Value
    Thread2.scenary.AddChanged <| fun (_,x) ->
        buttonRun.Text <- sprintf "%A" x.FullName
        MainWindow.setTooltip buttonRun ("Выполнить " + buttonRun.Text)
        buttonRun.AutoSize <- false
        buttonRun.AutoSize <- true

    let (<==) (text,tooltip) f = 
        let b = new Button( Parent = TopBar.thread1ButtonsBar, Dock = DockStyle.Left, 
                            FlatStyle = FlatStyle.Flat,
                            Text = text, AutoSize = true )
        b.Click.Add <| fun _ ->  
            f b    
        MainWindow.setTooltip b tooltip
        TopBar.thread1ButtonsBar.Controls.Add <| new Panel(Dock = DockStyle.Left, Width = 3)

    let imgBtn (key,tooltip) f = 
        let b = new Button( Parent = TopBar.thread1ButtonsBar, Dock = DockStyle.Left, 
                            ImageList = Widgets.Icons.instance.imageList1,
                            FlatStyle = FlatStyle.Flat, ImageKey = key,
                            Width = 40, Height = 40,
                            AutoSize = true )
        b.Click.Add <| fun _ ->  
            f b    
        MainWindow.setTooltip b tooltip
        TopBar.thread1ButtonsBar.Controls.Add <| new Panel(Dock = DockStyle.Left, Width = 3)
        
        
    imgBtn ( "loop","Опрос выбранных параметров приборов партии" ) <| fun _ ->
        runInterrogate()
    
    imgBtn ("network", "Управление приборами по Modbus") <| fun x ->
        modbusToolsPopup.Show x

    imgBtn ("pneumo", "Управление пневмоблоком") <| fun x ->
        pneumoToolsPopup.Show x   

    imgBtn  ("termochamber", "Управление термокамерой") <| fun x ->
        termoToolsPopup.Show x   

    Thread2.addKeepRunningHandler <| fun (_,isKeepRunning) -> 
        form.PerformThreadSafeAction <| fun () ->
            modbusToolsPopup.Content.Enabled <- not isKeepRunning
            pneumoToolsPopup.Content.Enabled <- not isKeepRunning
            termoToolsPopup.Content.Enabled <- not isKeepRunning

    do
        let x = 
            new Button( Parent = TopBar.thread1ButtonsBar, Dock = DockStyle.Left, AutoSize = true,
                        ImageKey = "script", Width = 40, Height = 40,
                        FlatStyle = FlatStyle.Flat,
                        ImageList = Widgets.Icons.instance.imageList1)
        MainWindow.setTooltip x "Выбрать сценарий настройки"
        x.Click.Add <| fun _ ->  
            SelectScenaryDialog.showSelectScenaryDialog x
        TopBar.thread1ButtonsBar.Controls.Add <| new Panel(Dock = DockStyle.Left, Width = 3)

    initPgsEdit()
    initComboBoxProdType()
    initButtons1()
    
    

    let buttonSettings = 
        new Button( Parent = right, Height = 40, Width = 40, Visible = true,
                    ImageList = Widgets.Icons.instance.imageList1,
                    FlatStyle = FlatStyle.Flat,
                    Dock = DockStyle.Right, ImageKey = "settings")
    right.Controls.Add <| new Panel(Dock = DockStyle.Right, Width = 3)
    setTooltip buttonSettings "Параметры приложения" 

    buttonSettings.Click.Add <| fun _ ->            
        let popup = 
            MyWinForms.Utils.popupConfig 
                "Параметры" 
                (AppConfigView())
                PropertySort.NoSort
        popup.Font <- form.Font        
        popup.Show(buttonSettings)

        
    Thread2.scenary.Set (production())

    fun () -> ()