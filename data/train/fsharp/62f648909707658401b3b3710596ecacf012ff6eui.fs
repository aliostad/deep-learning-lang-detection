[<CoDa.Code>]
module Ui

open System
open System.Collections.Generic
open System.Text.RegularExpressions

open System.Drawing
open System.Windows.Forms

open CoDa
open CoDa.Runtime
open Editor.Facts
open Editor.Types
open Resource.Util

let private FormTitle = "FSCoda Edit"
let private DefaultSize = new Size(800,600)
let private PaddingSpace = 3

let private MenuFileText = "&File"
let private MenuEditText = "&Edit"
let private MenuFormatText = "F&ormat"
let private MenuModeText = "&Mode"

let private MinFontSize = 8
let private MaxFontSize = 72

let private NoTitleFile = "notitle"   

let private SaveFileDialogTitle = "Save ..."
let private OpenFileDialogTitle = "Open ..."

let private MessageBoxQuestionMessage = "Do you want to save the changes?"
let private MessageBoxTitle = "Question"

let private toolStripDict = new Dictionary<string, ToolStripItem list>()

type FileHandler = { mutable fileName : string ; mutable modified : bool } 

let private fileHandler = {fileName = NoTitleFile; modified = false } 

let private initFileHandler () =
  fileHandler.fileName <- NoTitleFile
  fileHandler.modified <- false

let private Menus () =   // dlet with basic behaviour
  let mlist = [ MenuFileText, Actions.FileActions ;        // Basic behaviour   
                MenuEditText, Actions.EditActions ;
                MenuModeText, Actions.ModeActions ; ] |- True
  
  let mlist = mlist @ [MenuFormatText, Actions.FormatActions] |- execution_mode("rtf")
  mlist


  // START EVENT HANDLERS

let private checkedUtil (b : bool) (e : ToolStripItem list) = 
  let f_aux (e : ToolStripItem) = 
    match e with
      | :? ToolStripMenuItem as m -> m.Checked <- b
      | :? ToolStripButton as i -> i.Checked <- b
      | _ -> failwith "checkedUtil: "
  e |> List.iter (f_aux)


let private enabledUtil (b : bool) (e : ToolStripItem list) =
  e |> List.iter (fun e -> e.Enabled <- b)

let private cutHandler (edit : RichTextBox) =
  edit.Cut()
  toolStripDict.[Actions.PasteText] |> enabledUtil true

let private copyHandler (edit : RichTextBox) =
  edit.Copy()
  toolStripDict.[Actions.PasteText] |> enabledUtil true

let private pasteHandler (edit : RichTextBox) =
  edit.Paste()
  fileHandler.modified <- true

let private fontStyleHandler (style : FontStyle) (rt : RichTextBox) =
  let oldFontStyle = rt.SelectionFont
  if oldFontStyle <> null then
    fileHandler.modified <- true
    rt.SelectionFont <- new Font(oldFontStyle, oldFontStyle.Style ^^^ style)

let private checkItems (toUncheckKey : string list) =
  toUncheckKey |>
  List.iter (fun s -> toolStripDict.[s] |> checkedUtil false )

let private fontAlignmentHandler (toUncheckKey : string list) (alignment : HorizontalAlignment) (rt : RichTextBox) =
  fileHandler.modified <- true
  rt.SelectionAlignment <- alignment
  checkItems toUncheckKey    // 

let private leftHandler (rt : RichTextBox)=
  toolStripDict.[Actions.LeftText] |> checkedUtil true
  fontAlignmentHandler [Actions.CenterText ; Actions.RightText] HorizontalAlignment.Left rt

let private rightHandler (rt : RichTextBox)=
  toolStripDict.[Actions.RightText] |> checkedUtil true
  fontAlignmentHandler [Actions.CenterText ; Actions.LeftText] HorizontalAlignment.Right rt

let private centerHandler (rt : RichTextBox) =
  toolStripDict.[Actions.CenterText] |> checkedUtil true      
  fontAlignmentHandler [Actions.RightText ; Actions.LeftText] HorizontalAlignment.Center rt

 
let private configureFileDialog (d : FileDialog) title =  //  dlet
  let fileDialogFilter = ctx?filter |- file_dialog_filter(ctx?filter)
  let fileDialogFileExt = ctx?ext |- file_dialog_file_ext(ctx?ext)
  d.Filter <-  fileDialogFilter 
  d.DefaultExt <- fileDialogFileExt 
  d.FilterIndex <- 1
  d.Title <- title

let private saveFileAs (rt : RichTextBox) =
  let saveDlg = new SaveFileDialog()
  let streamType = ctx?streamType |- stream_type(ctx?streamType)   // dlet
  configureFileDialog saveDlg SaveFileDialogTitle

  match saveDlg.ShowDialog() with
    | DialogResult.OK -> rt.SaveFile(saveDlg.FileName, streamType)
    | _ -> ()

let private saveFile (rt : RichTextBox) =
  if fileHandler.fileName.Equals(NoTitleFile) then
    saveFileAs rt
  else
    let streamType = ctx?streamType |- stream_type(ctx?streamType) // dlet
    rt.SaveFile(fileHandler.fileName, streamType)

let private loadFile (rt : RichTextBox) =
  let openDlg = new OpenFileDialog()

  configureFileDialog openDlg OpenFileDialogTitle

  match openDlg.ShowDialog() with
    | DialogResult.OK when not (String.IsNullOrEmpty(openDlg.FileName) &&  
                                String.IsNullOrWhiteSpace(openDlg.FileName)) ->
               let streamType = ctx?streamType |- stream_type(ctx?streamType) // dlet
               rt.LoadFile(openDlg.FileName, streamType )
               fileHandler.fileName <- openDlg.FileName
               fileHandler.modified <- false
    | _ -> ()

let private askForSave rt =
  if fileHandler.modified  && (  MessageBox.Show(MessageBoxQuestionMessage, MessageBoxTitle, MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes ) then
    saveFile rt      

let private colorKeyworkds (rt : RichTextBox) (text : string) (offset : int) =
  let tokens = ctx?tks |- tokens(ctx?tks)         // dlet
  let rex = new Regex(tokens)
  let mc = Seq.cast (rex.Matches(text))
  mc |> Seq.iter (fun (m: Match) -> 
                  let startIndex = m.Index + offset
                  let endIndex = m.Length - 1
                  rt.SelectionStart <- startIndex
                  rt.SelectionLength <- m.Length
                  rt.SelectionColor <- Color.Blue
                  )      

let private resetRichTextBoxAttr (rt : RichTextBox) =
  let currentPos = rt.SelectionStart
  let currentLength = rt.SelectionLength
  rt.SelectAll ()
  rt.SelectionAlignment <- HorizontalAlignment.Left
  rt.SelectionColor <- Color.Black
  rt.SelectionFont <- rt.Font
  rt.SelectionStart <- currentPos
  rt.SelectionLength <- currentLength

let private loadHandler (rt : RichTextBox) =    // dlet with basic behaviour
  let colorFile () =
    resetRichTextBoxAttr rt
    let currentPos = rt.SelectionStart
    let currentLength = rt.SelectionLength
    colorKeyworkds rt rt.Text 0
    rt.SelectionStart <- currentPos
    rt.SelectionLength <- currentLength
    
  let f_body = ( askForSave rt ; loadFile rt ) |- True     // dlet: basic behaviour 
    
  let f_body = ( f_body ; colorFile ()) |- execution_mode("programming")  // dlet
  
  f_body
    

  
let private newHandler (rt : RichTextBox) =
  askForSave rt
  rt.Clear()
  initFileHandler ()

let private undoHandler (rt : RichTextBox) =
  rt.Undo ()

let private redoHandler (rt : RichTextBox) =
  rt.Redo ()

let syntaxHighlighter (edit : RichTextBox) =
  let currentPos = edit.SelectionStart
  let currentLength = edit.SelectionLength
    
  if (Array.length edit.Lines) > 0 then
    let lineNumber = edit.GetLineFromCharIndex(currentPos)
    let line = Array.get edit.Lines lineNumber
    let lineStart = edit.GetFirstCharIndexFromLine(lineNumber)
    let lineEnd = (String.length line)

    edit.SelectionStart <- lineStart
    edit.SelectionLength <- lineEnd
    edit.SelectionColor <- Color.Black
    
    colorKeyworkds edit line lineStart
    
    edit.SelectionStart <- currentPos
    edit.SelectionLength <- currentLength
    edit.SelectionColor <- Color.Black
  else
    ()

let private textChanged (rt : RichTextBox) = // dlet 
  let def_behaviour () =
    fileHandler.modified <- true
    toolStripDict.[Actions.UndoText] |> enabledUtil rt.CanUndo
    toolStripDict.[Actions.RedoText] |> enabledUtil rt.CanRedo
        
  let f_body = def_behaviour () |- True    // Basic behaviour 

  let f_body  = (f_body ; syntaxHighlighter rt) |- execution_mode("programming")
    
  f_body

let private defaultFont : Font ref = ref(null) // dummy value

let changeMode new_mode =     // Behavioural variation 
  match ctx with
    | _ when !- execution_mode(ctx?mode) -> retract <| execution_mode_(ctx?mode)
                                            tell <| execution_mode_(new_mode)
    | _ -> failwith "changeMode"    // 

let private rtfmodeHandler (rt : RichTextBox) =
  toolStripDict.[Actions.RTFEditorText] |> checkedUtil true  
  checkItems [Actions.PEditorText ; Actions.TEditorText]
  changeMode "rtf"
  rt.Font <- !defaultFont
  resetRichTextBoxAttr rt

let private textmodeHandler (rt : RichTextBox) =
  toolStripDict.[Actions.TEditorText] |> checkedUtil true
  checkItems [Actions.PEditorText ; Actions.RTFEditorText]
  changeMode "text"
  rt.Font <- new Font(FontFamily.GenericMonospace, 11.0f)
  resetRichTextBoxAttr rt

let private progmodeHandler (rt : RichTextBox) =
  toolStripDict.[Actions.PEditorText] |> checkedUtil true
  checkItems [Actions.RTFEditorText ; Actions.TEditorText]
  changeMode "programming"
  rt.Font <- new Font(FontFamily.GenericMonospace, 14.0f)
  resetRichTextBoxAttr rt
  let currentPos = rt.SelectionStart
  let currentLength = rt.SelectionLength
  colorKeyworkds rt rt.Text 0
  rt.SelectionStart <- currentPos
  rt.SelectionLength <- currentLength
  // END EVENT HANDLERS

let private mainMenu ()  =
  let menuFromActions (name, actions) = 
    let menuStrip = new ToolStripMenuItem(Text=name)
    let transform (a : Actions.t) = 
      let m =
        match a.image with
          | Some(i) -> new ToolStripMenuItem(a.text, i)
          | _ -> new ToolStripMenuItem(a.text)

      m.Enabled <- a.enable
      m.CheckOnClick <- a.toggle
      toolStripDict.Add(a.text, [m])
      m

    actions |>
    List.map transform  |>
    List.iter (fun item -> menuStrip.DropDown.Items.Add(item) |> ignore)
    menuStrip

  let m = new MenuStrip(Dock=DockStyle.Top)

  Menus () |>   // Menus is adaptive
  List.map menuFromActions |>
  List.iter (fun item -> m.Items.Add(item) |> ignore)

  m

let private mainToolBar (edit : RichTextBox) =
  let fontFamilyComboBox =
    let cbox = new ComboBox()

    FontFamily.Families |> Array.iter (fun ff -> cbox.Items.Add(ff.Name) |> ignore)
    cbox.SelectedItem <-  edit.Font.Name
    cbox

  let fontSizeComboBox =
    let cbox = new ComboBox()
    [MinFontSize .. MaxFontSize] |> List.iter (fun size -> cbox.Items.Add(size) |> ignore)
    cbox.SelectedItem <- int(edit.Font.SizeInPoints) 
    cbox

  let toolbarFromAction actions = 
    let toolbar = new ToolStrip()
    let transform (a : Actions.t) = 
      let m =
        match a.image with
          | Some(i) -> new ToolStripButton(i)
          | _ -> new ToolStripButton(a.text)
      m.ToolTipText <- a.text
      m.Enabled <- a.enable    
      m.CheckOnClick <- a.toggle
      let old = toolStripDict.[a.text]
      toolStripDict.Remove(a.text) |> ignore
      toolStripDict.Add(a.text, (m :> ToolStripItem)::old)
      m

    actions |> List.map transform |> List.iter (fun item -> toolbar.Items.Add(item) |> ignore)
    
    toolbar

  let setFont (edit : RichTextBox) (cmbFontName : ComboBox) (cmbFontSize : ComboBox) =
    let oldFont = edit.SelectionFont
    let nSize = if String.IsNullOrWhiteSpace(cmbFontSize.Text) then 8.0f else float32 cmbFontSize.Text
    let style, charset = if oldFont <> null then oldFont.Style, oldFont.GdiCharSet else FontStyle.Regular, 0uy
    edit.SelectionFont <- new Font(cmbFontName.Text, nSize, style, GraphicsUnit.Point, charset)

  let fontsToolStrip () =
    let tst = new ToolStrip ()
    let ctlHostFFamily = new ToolStripControlHost(fontFamilyComboBox)
    let ctlHostFSize = new ToolStripControlHost(fontSizeComboBox)
    fontFamilyComboBox.SelectedIndexChanged <~~ (fun _ _ -> setFont edit fontFamilyComboBox fontSizeComboBox)
    fontSizeComboBox.SelectedIndexChanged <~~ (fun _ _ -> setFont edit fontFamilyComboBox fontSizeComboBox)
    tst.Items.Add(ctlHostFFamily) |> ignore
    tst.Items.Add(ctlHostFSize) |> ignore
    tst
    
  let p = new FlowLayoutPanel(Dock = DockStyle.Top)

  Menus () |> // Menus is adaptive
  List.map (snd >> toolbarFromAction) |>
  List.iter (fun item -> p.Controls.Add(item) |> ignore)

  match ctx with           // Behavioural variation
    | _ when !- execution_mode("rtf") -> p.Controls.Add(fontsToolStrip ())
    | _ -> ()
  p.AutoSize <- true
  p

 
let private editTextBox () =
  let rt = new RichTextBox(AutoSize = true, Dock = DockStyle.Fill, TabStop = false)
  rt.TextChanged <~~ (fun _ _ -> textChanged rt) 
  rt

let private mainPanel (rt : RichTextBox) =
  let p = new Panel(Dock = DockStyle.Fill)
  p.Padding <- new Padding(PaddingSpace)
  p.Controls.Add(rt)
  p


let rec setMenuToolBar (f : Form) (edit : RichTextBox) =
  f.Controls.Clear ()
  toolStripDict.Clear ()
  let menuStrip = mainMenu ()
  let toolbarStrip = mainToolBar edit
  f.MainMenuStrip <- menuStrip

  f.Controls.Add(mainPanel edit) |> ignore
  f.Controls.Add(toolbarStrip) |> ignore
  f.Controls.Add(menuStrip) |> ignore

  toolStripDict.[Actions.NewText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> newHandler edit))


  toolStripDict.[Actions.OpenText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> loadHandler edit))
  toolStripDict.[Actions.SaveText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> saveFile edit ; fileHandler.modified <- false))
  toolStripDict.[Actions.SaveAsText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> saveFileAs edit))
  toolStripDict.[Actions.ExitText] |> List.iter (fun e -> e.Click <~~ (fun _ _ ->  Application.Exit ())) 

  toolStripDict.[Actions.CutText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> cutHandler edit))
  toolStripDict.[Actions.CopyText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> copyHandler edit))
  toolStripDict.[Actions.PasteText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> pasteHandler edit))
  toolStripDict.[Actions.UndoText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> undoHandler edit))
  toolStripDict.[Actions.RedoText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> redoHandler edit))


  toolStripDict.[Actions.RTFEditorText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> rtfmodeHandler edit ; setMenuToolBar f edit))
  toolStripDict.[Actions.PEditorText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> progmodeHandler edit ; setMenuToolBar f edit))
  toolStripDict.[Actions.TEditorText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> textmodeHandler edit ; setMenuToolBar f edit))

  // dlet 
  let current =  Actions.PEditorText |- execution_mode("programming")
  let current = Actions.RTFEditorText |- execution_mode("rtf")
  let current = Actions.TEditorText |- execution_mode("text")
  
  toolStripDict.[current] |> checkedUtil true

  match ctx with          // Behavioural variation
   | _ when !- execution_mode("rtf") ->  
      toolStripDict.[Actions.BoldText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> fontStyleHandler FontStyle.Bold edit))
      toolStripDict.[Actions.ItalicText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> fontStyleHandler FontStyle.Italic edit ))
      toolStripDict.[Actions.UnderlineText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> fontStyleHandler FontStyle.Underline edit))

      toolStripDict.[Actions.CenterText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> centerHandler edit))
      toolStripDict.[Actions.LeftText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> leftHandler edit))
      toolStripDict.[Actions.RightText] |> List.iter (fun e -> e.Click <~~ (fun _ _ -> rightHandler edit))
   | _ -> ()   


let mainForm () =
  let f = new Form(Text = FormTitle, MinimumSize = DefaultSize)
  let edit = editTextBox ()
  defaultFont := (edit.Font.Clone () :?> Font)

  setMenuToolBar f edit
  
  f.FormClosing <!~  ( fun _ _ -> askForSave edit)
  
  f
