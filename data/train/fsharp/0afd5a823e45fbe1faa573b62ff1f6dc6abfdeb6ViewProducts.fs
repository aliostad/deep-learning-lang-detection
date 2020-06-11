module Ankat.View.Products

open System
open System.Windows.Forms
open System.Drawing
open System.Collections.Generic

open MainWindow
open Ankat

[<AutoOpen>]
module private Helpers =

    type C = DataGridViewColumn
    type CheckBoxColumn = MyWinForms.GridViewCheckBoxColumn
    type TextColumn = DataGridViewTextBoxColumn
    let party = Ankat.AppContent.party
    let (~%%) x = x :> C

module Columns =
    type CbBox = MyWinForms.FlatComboBox
    let main = [   
        %% new CheckBoxColumn(DataPropertyName = "IsChecked", Width = 50) 
        %% new TextColumn(DataPropertyName = "SerialNumber", HeaderText = "№", Width = 80)   ]
    
    let serialPortColumn = 

        let ports() = System.IO.Ports.SerialPort.GetPortNames()
        let serialPortColumn = new TextColumn(DataPropertyName = "Port", HeaderText = "Порт", 
                                                Width = 80 )

        let (|P|_|) (columnIndex:int, rowIndex:int)=
            if obj.ReferenceEquals( gridProducts.Columns.[columnIndex], serialPortColumn) then
                let row = gridProducts.Rows.[rowIndex]
                match row.DataBoundItem with
                | :? ViewModel.Product as p ->
                    Some (row.Cells.[columnIndex],p)
                | _ -> None
            else None

        gridProducts.CellFormatting.Add(fun e -> 
            match e.ColumnIndex, e.RowIndex with
            | P (cell,p) ->     
                
                match ports() |> Array.tryFind( (=) p.Port ) with
                | None -> 
                    e.CellStyle.ForeColor <- Color.Red
                    e.CellStyle.BackColor <- Color.LightGray
                | _ -> 
                    e.CellStyle.ForeColor <- Color.Navy
            | _ -> ()  )

        gridProducts.CellClick.Add(fun e -> 
            match e.ColumnIndex, e.RowIndex with
            | P (cell,p) ->
                let ports = ports()
                let cb = myListbox()
                cb.Height <- ports.Length * cb.ItemHeight + 3                
                ports |> Array.iter ( cb.Items.Add >> ignore )
                cb.SelectedIndex <-
                    ports |> Array.tryFindIndex( (=) p.Port )
                    |> Option.getWith (-1)
                cb.SelectedIndexChanged.Add( fun _ ->
                    p.Port <- cb.Text )
                let pt = 
                    let r = gridProducts.GetCellDisplayRectangle(e.ColumnIndex, e.RowIndex, true);
                    gridProducts.PointToScreen( Point(r.Left, r.Bottom) )
                let popup = new MyWinForms.Popup(cb)
                popup.Closed.Add(fun _ -> gridProducts.EndEdit() |> ignore )                
                popup.Show(pt.X, pt.Y)
            | _ -> () )

        serialPortColumn

    
    let physVars = PhysVar.valuesList |> List.map(fun physvar -> 
        %% new TextColumn
                (   DataPropertyName = Prop.physVar physvar, 
                    HeaderText = PhysVar.what physvar,
                    ReadOnly = true) )

    let columnConnection = 
        %% new TextColumn(DataPropertyName = "Connection", HeaderText = "Связь", Width = 80) 

    let interrogate =    
        %% serialPortColumn ::
        %% columnConnection ::
        physVars

let updateCoefsGridRowsVisibility _ =   
    let v = AppConfig.config.View
    let visCoefs = IntRanges.parseSet v.VisibleCoefs 
    v.VisibleCoefs <- IntRanges.formatSet visCoefs

    gridKefs.Rows 
    |> Seq.cast<DataGridViewRow>
    |> Seq.iter(fun row -> 
        row.Visible <- visCoefs.Contains (MainWindow.getCoefOfRow row).Order )

let updatePhysVarsGridColsVisibility() =
    List.zip PhysVar.valuesList Columns.physVars
    |> List.iter(fun (var,col) -> 
        col.Visible <- Set.contains var AppConfig.config.View.VisiblePhysVars )

let initialize = 
    gridProducts.DataSource <- party.Products
    
    gridProducts.DataError.Add(fun ev -> 
        Logging.error """gridProducts.DataError 
ColumnIndex : %d
RowIndex : %d
Context : %A 
Exception : %A %A""" 
            ev.ColumnIndex ev.RowIndex ev.Context  ev.Exception ev.Exception.StackTrace
        )
    
    gridKefs.CellParsing.Add <| fun e ->
        if e.ColumnIndex < 3 then () else
        let col = gridKefs.Columns.[e.ColumnIndex]
        let row = gridKefs.Rows.[e.RowIndex]
        let cell = row.Cells.[e.ColumnIndex]
        let kef = Ankat.Coef.coefs.[e.RowIndex]
        let product = col.Tag :?> Ankat.ViewModel.Product1
        let value = if e.Value=null then "" else e.Value.ToString()
        product.setKefUi kef value

    let textboxSelectedCoefs = new RichTextBox( Parent = TabsheetKefs.BottomTab, Dock = DockStyle.Fill,
                                                BorderStyle = BorderStyle.None,
                                                Text = AppConfig.config.View.SelectedCoefs )

    let addsep n = 
        TabsheetKefs.BottomTab.Controls.Add
            ( new Panel(Dock = DockStyle.Top, Height = n) )

    addsep 3    
    let btnSelectCoef = new Button( Parent = TabsheetKefs.BottomTab, Dock = DockStyle.Top, 
                                    Text = "Выбрать", Height = 30, FlatStyle = FlatStyle.Flat,
                                    TextAlign = ContentAlignment.MiddleLeft)
    

    addsep 3    
    let btnUnselectCoef = new Button( Parent = TabsheetKefs.BottomTab, Dock = DockStyle.Top, 
                                      Text = "Снять выбор", Height = 30, FlatStyle = FlatStyle.Flat,
                                      TextAlign = ContentAlignment.MiddleLeft)
    
    addsep 15
    let b = new Button( Parent = TabsheetKefs.BottomTab, Dock = DockStyle.Top, 
                        Text = "Записать", Height = 30, FlatStyle = FlatStyle.Flat,
                        TextAlign = ContentAlignment.MiddleLeft)
    b.Click.AddHandler(fun _ _ ->
        PartyWorks.Kefs.write() )

    Thread2.IsRunningChangedEvent.addHandler <| fun (_,isRunning) ->
        b.Enabled <- not isRunning

    addsep 3
    let b = new Button( Parent = TabsheetKefs.BottomTab, Dock = DockStyle.Top, 
                        Text = "Считать", Height = 30, FlatStyle = FlatStyle.Flat,
                        TextAlign = ContentAlignment.MiddleLeft)
    b.Click.AddHandler(fun _ _ ->
        PartyWorks.Kefs.read() )
    Thread2.IsRunningChangedEvent.addHandler <| fun (_,isRunning) ->
        b.Enabled <- not isRunning

    addsep 15   

    let getSelectedCoefsValue() =  
        let x = AppConfig.config.View      
        Set.intersect 
            (MainWindow.SelectedCoefsRows.get())
            (IntRanges.parseSet x.VisibleCoefs)
        |> Set.filter (Coef.tryGetByOrder >> Option.isSome )
        |> IntRanges.setToList
        |> Seq.toStr " " (fun (n,m) -> 
            if n=m then n.ToString() else sprintf "%d-%d" n m )

    let updCheckRows() = 
        let selectedKefs = 
            getSelectedCoefsValue()
            |> IntRanges.parseSet
            |> IntRanges.formatSet
        textboxSelectedCoefs.Text <- selectedKefs
        AppConfig.config.View.SelectedCoefs <- selectedKefs


    let rec textChangedHandler = EventHandler(fun _ _ -> 
        gridKefs.CellValueChanged.RemoveHandler cellValueChanged
        let x = AppConfig.config.View
        let xs =
            Set.intersect 
                (IntRanges.parseSet textboxSelectedCoefs.Text )
                (IntRanges.parseSet x.VisibleCoefs)
            |> Set.filter (Coef.tryGetByOrder >> Option.isSome )
        MainWindow.SelectedCoefsRows.set xs
        x.SelectedCoefs <- IntRanges.formatSet xs
        gridKefs.CellValueChanged.AddHandler cellValueChanged )

    
    and cellValueChanged = DataGridViewCellEventHandler(fun _ evt -> 
        if evt.ColumnIndex <> 0 then () else
        textboxSelectedCoefs.TextChanged.RemoveHandler textChangedHandler
        updCheckRows()
        textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler )

    gridKefs.CellValueChanged.AddHandler cellValueChanged
    textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler
    textboxSelectedCoefs.Leave.AddHandler (fun _ _ -> 
        textboxSelectedCoefs.TextChanged.RemoveHandler textChangedHandler
        textboxSelectedCoefs.Text <- getSelectedCoefsValue()
        textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler
        )

    let f x =   
        gridKefs.SelectedCells
        |> Seq.cast<DataGridViewCell>
        |> Seq.iter(fun cell -> 
            gridKefs.Rows.[cell.RowIndex].Cells.[0].Value <- x )

    btnSelectCoef.Click.AddHandler(fun _ _ ->        
        f true ) 

    btnUnselectCoef.Click.AddHandler(fun _ _ ->        
        f false ) 

    updateCoefsGridRowsVisibility()
    updatePhysVarsGridColsVisibility()

    let col = gridKefs.Columns.[0] :?> MyWinForms.GridViewCheckBoxColumn
    let cell = col.HeaderCell :?> MyWinForms.DatagridViewCheckBoxHeaderCell
    
    cell.add_BeforCheckBoxChanged( MyWinForms.CheckBoxClickedHandler(fun index _ -> 
        gridKefs.CellValueChanged.RemoveHandler cellValueChanged
        textboxSelectedCoefs.TextChanged.RemoveHandler textChangedHandler  ) )

    cell.add_AfterCheckBoxChanged( MyWinForms.CheckBoxClickedHandler(fun index _ -> 
        updCheckRows()
        gridKefs.CellValueChanged.AddHandler cellValueChanged
        textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler ) )
    
    fun () -> ()