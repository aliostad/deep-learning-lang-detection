module Dak.View.Products

open System
open System.Windows.Forms
open System.Drawing
open System.Collections.Generic
open System.ComponentModel

open Dak.MainWindow
open Dak

[<AutoOpen>]
module private Helpers =

    type C = DataGridViewColumn
    type CheckBoxColumn = MyWinForms.GridViewCheckBoxColumn
    type TextColumn = DataGridViewTextBoxColumn
    let party = Dak.AppData.party
    let (~%%) x = x :> C    
    
module GridProductColumns = 
    let private txtcol prop hd = 
        %% new TextColumn(DataPropertyName = prop, HeaderText = hd, Width = 50, ReadOnly = true,
                            AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells, 
                            MinimumWidth = 60)
    let conn = 
        %% new TextColumn(DataPropertyName = "Connection", HeaderText = "Наличие связи", 
                            Width = 200, ReadOnly = true,
                            AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells, 
                            MinimumWidth = 60)

    let extpopup = 
        %% new TextColumn(ReadOnly = true, AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells )
        

    let main = [   
        %% new CheckBoxColumn(DataPropertyName = "On", AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells) 
        
        %% new TextColumn(DataPropertyName = "Addr", HeaderText = "Сетевой адрес",
                            AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells) 
        %% new TextColumn(DataPropertyName = "Serial", HeaderText = "Заводской номер",
                            AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells)                      
        conn
        ]

    let conc = txtcol "MilConc"  "Конц."
    let curr = txtcol "CurrentStr" "Ток"
    let porog1 = txtcol "Porog1Str" "П1"
    let porog2 = txtcol "Porog2Str" "П2"
    let stend = 
        [   curr
            porog1
            porog2  ]

    let milvars =
        [   for var in MilVar.values.Tail ->
                txtcol (MilVar.prop var) (MilVar.name var)
        ]

    let updExtpopupcol = 
        let mutable hitTest : DataGridView.HitTestInfo = null
        let mutable origForeColor = Color.Black
        let mutable origBackColor = Color.White
        let resetHittest() = 
            if hitTest <> null && hitTest.RowIndex > -1 && hitTest.RowIndex < gridProducts.RowCount then
                let style = gridProducts.Rows.[hitTest.RowIndex].Cells.[extpopup.Index].Style
                style.ForeColor <- origForeColor
                style.BackColor <- origBackColor 
                style.Font <- null
                hitTest <- null

        fun _ ->
            let mousePos = Cursor.Position
            let clientPos = gridProducts.PointToClient mousePos
            let nextHitTest = gridProducts.HitTest( clientPos.X, clientPos.Y)
            let n = extpopup.Index
            let rows = gridProducts.Rows
            if n =  nextHitTest.ColumnIndex then
                resetHittest()
                if nextHitTest.RowIndex > -1 && nextHitTest.RowIndex < gridProducts.RowCount then 
                    let style = rows.[nextHitTest.RowIndex].Cells.[n].Style
                    origForeColor <- style.ForeColor
                    origBackColor <- style.BackColor
                    style.ForeColor <- Color.Blue
                    style.BackColor <- Color.LightSteelBlue
                    style.Font <- new Font(form.Font, FontStyle.Bold)                
                    hitTest <- nextHitTest
                    gridProducts.Cursor <- Cursors.Hand            
            else
                gridProducts.Cursor <- Cursors.Default
                resetHittest()

    let init = 
        gridProducts.Columns.AddColumns <|  main @ [conc] @ stend @ milvars @[extpopup]
        gridProducts.MouseMove.Add  updExtpopupcol
        gridProducts.DataBindingComplete.Add <| fun _ -> 
            for n = 0 to gridProducts.RowCount -  1 do
                gridProducts.Rows.[n].Cells.[extpopup.Index].Value <- "∙∙∙"
            
        fun () -> ()

    let updateVisibilityByConfig() =
        let vis var = Set.contains var Config.App.config.View.InterrogateMilVars
        conc.Visible <- vis MilVar.conc
        for var,col in List.zip MilVar.values.Tail milvars do
            col.Visible <- vis var
        for col in stend do
            col.Visible <- Config.App.config.View.InterrogateStend6026

let initialize = 
    
    GridProductColumns.init()
    gridProducts.DataSource <- party.Products    
    GridProductColumns.updateVisibilityByConfig()
    gridProducts.CellFormatting.Add <| fun e ->
        if e.ColumnIndex = GridProductColumns.conn.Index then
            let text, fore, back =
                match e.Value :?> Result<string,string> option with
                | Some (Ok _) -> "Связь", Color.Black, Color.White
                | Some (Err _) -> "Ошибка", Color.Red, Color.LightGray
                | _ -> "", Color.Black, Color.White
            e.Value <- text
            let row = gridProducts.Rows.[e.RowIndex]
            let cell = row.Cells.[e.ColumnIndex]
            cell.Style.ForeColor <- fore
            cell.Style.BackColor <- back
            
        
    gridCoefs.CellParsing.Add <| fun e ->
        if e.ColumnIndex < 3 then () else
        let col = gridCoefs.Columns.[e.ColumnIndex] :?> DataGridViewTextBoxColumn
        let row = gridCoefs.Rows.[e.RowIndex]
        let cell = row.Cells.[e.ColumnIndex]
        let kef = Coef.values.[e.RowIndex]
        let product = ViewModel.ProductViewModel.OfCoefColumn col
        let value = if e.Value=null then "" else e.Value.ToString()
        product.SetCoefStr kef value

    let textboxSelectedCoefs = new RichTextBox( Parent = TabsheetCoefs.BottomTab, Dock = DockStyle.Fill,
                                                BorderStyle = BorderStyle.None,
                                                Text = Config.App.config.View.SelectedCoefs )

    let addsep n = 
        TabsheetCoefs.BottomTab.Controls.Add
            ( new Panel(Dock = DockStyle.Top, Height = n) )

    addsep 3    
    let btnSelectCoef = new Button( Parent = TabsheetCoefs.BottomTab, Dock = DockStyle.Top, 
                                    Text = "Выбрать", Height = 30, FlatStyle = FlatStyle.Flat,
                                    TextAlign = ContentAlignment.MiddleLeft)
    

    addsep 3    
    let btnUnselectCoef = new Button( Parent = TabsheetCoefs.BottomTab, Dock = DockStyle.Top, 
                                      Text = "Снять выбор", Height = 30, FlatStyle = FlatStyle.Flat,
                                      TextAlign = ContentAlignment.MiddleLeft)
    
    addsep 15
    let b = new Button( Parent = TabsheetCoefs.BottomTab, Dock = DockStyle.Top, 
                        Text = "Записать", Height = 30, FlatStyle = FlatStyle.Flat,
                        TextAlign = ContentAlignment.MiddleLeft)
    b.Click.AddHandler(fun _ _ ->
        Operations.Run.Kefs.write() )

    Thread2.IsRunningChangedEvent.addHandler <| fun (_,isRunning) ->
        b.Enabled <- not isRunning

    addsep 3
    let b = new Button( Parent = TabsheetCoefs.BottomTab, Dock = DockStyle.Top, 
                        Text = "Считать", Height = 30, FlatStyle = FlatStyle.Flat,
                        TextAlign = ContentAlignment.MiddleLeft)
    b.Click.AddHandler(fun _ _ ->
        Operations.Run.Kefs.read() )
    Thread2.IsRunningChangedEvent.addHandler <| fun (_,isRunning) ->
        b.Enabled <- not isRunning

    addsep 15   

    let getSelectedCoefsValue() =  
        let x = Config.App.config.View      
        SelectedCoefsRows.get()
        |> IntRanges.setToList
        |> Seq.toStr " " (fun (n,m) -> 
            if n=m then n.ToString() else sprintf "%d-%d" n m )

    let updCheckRows() = 
        let selectedKefs = 
            getSelectedCoefsValue()
            |> IntRanges.parseSet
            |> IntRanges.formatSet
        textboxSelectedCoefs.Text <- selectedKefs
        Config.App.config.View.SelectedCoefs <- selectedKefs


    let rec textChangedHandler = EventHandler(fun _ _ -> 
        gridCoefs.CellValueChanged.RemoveHandler cellValueChanged
        let x = Config.App.config.View
        let xs =
            IntRanges.parseSet textboxSelectedCoefs.Text         
        MainWindow.SelectedCoefsRows.set xs
        x.SelectedCoefs <- IntRanges.formatSet xs
        gridCoefs.CellValueChanged.AddHandler cellValueChanged )

    
    and cellValueChanged = DataGridViewCellEventHandler(fun _ evt -> 
        if evt.ColumnIndex <> 0 then () else
        textboxSelectedCoefs.TextChanged.RemoveHandler textChangedHandler
        updCheckRows()
        textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler )

    gridCoefs.CellValueChanged.AddHandler cellValueChanged
    textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler
    textboxSelectedCoefs.Leave.AddHandler (fun _ _ -> 
        textboxSelectedCoefs.TextChanged.RemoveHandler textChangedHandler
        textboxSelectedCoefs.Text <- getSelectedCoefsValue()
        textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler
        )

    let f x =   
        gridCoefs.SelectedCells
        |> Seq.cast<DataGridViewCell>
        |> Seq.iter(fun cell -> 
            gridCoefs.Rows.[cell.RowIndex].Cells.[0].Value <- x )

    btnSelectCoef.Click.AddHandler(fun _ _ ->        
        f true ) 

    btnUnselectCoef.Click.AddHandler(fun _ _ ->        
        f false ) 

    let col = gridCoefs.Columns.[0] :?> MyWinForms.GridViewCheckBoxColumn
    let cell = col.HeaderCell :?> MyWinForms.DatagridViewCheckBoxHeaderCell
    
    cell.add_BeforCheckBoxChanged( MyWinForms.CheckBoxClickedHandler(fun index _ -> 
        gridCoefs.CellValueChanged.RemoveHandler cellValueChanged
        textboxSelectedCoefs.TextChanged.RemoveHandler textChangedHandler  ) )

    cell.add_AfterCheckBoxChanged( MyWinForms.CheckBoxClickedHandler(fun index _ -> 
        updCheckRows()
        gridCoefs.CellValueChanged.AddHandler cellValueChanged
        textboxSelectedCoefs.TextChanged.AddHandler textChangedHandler ) )
        
    gridProducts.CellClick.Add <| fun e -> 
        if e.ColumnIndex <> GridProductColumns.extpopup.Index then () else
        //let column = gridProducts.Columns.[e.ColumnIndex]
        let row = gridProducts.Rows.[e.RowIndex]
        let product = row.DataBoundItem  :?> ViewModel.ProductViewModel

        let mutable onclose = fun _ -> ()
        let popup = 
            MyWinForms.Utils.popupConfig 
                product.What
                product
                ( fun p g -> 
                    p.Width <- 600
                    g.PropertySort <- PropertySort.Alphabetical 
                    let ac : Attribute[] = [| MyWinForms.Utils.MyBrowseableAttribute() |]                    
                    g.BrowsableAttributes <- AttributeCollection ac
                    g.PropertySort <- PropertySort.Categorized 
                    g.CollapseAllGridItems()
                    let h = Runtime.PropertyChanged.addAction product <| fun _ _ -> 
                        g.SelectedObject <- product
                    onclose <- fun _ -> 
                        Runtime.PropertyChanged.removeAction product h
                    
                )
        popup.Closed.Add onclose
        
        gridProducts.GetCellDisplayRectangle(e.ColumnIndex, e.RowIndex, false).Location
        |> gridProducts.PointToScreen
        |> popup.Show

    fun () -> ()