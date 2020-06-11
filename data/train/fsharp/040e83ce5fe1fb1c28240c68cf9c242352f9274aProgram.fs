namespace UIAutomationSample
open System
open System.Windows.Automation
open System.Diagnostics
open UIAutomationSample.UIControls    

/// WPFで作成したWindowクラスの真似ごと
type UIAutomationSampleForm (root:AutomationElement) =
    let form = root
    member x.RadioButton1 = new RadioButton(root,"radioButton1")
    member x.RadioButton2 = new RadioButton(root,"radioButton2")
    member x.RadioButton3 = new RadioButton(root,"radioButton3")
    member x.ButtonView = new Button(root,"btnView")
    member x.ButtonTest = new Button(root,"btnTest")
    member x.TextBox2 = new TextBox(root, "textBox2")
    member x.CheckBox = new CheckBox(root, "checkBox1")

type AutomationSample() =
    let _path = @"D:\develop\github\FsUIAutomationSample\UIAutomationSampleForm\bin\Debug\UIAutomationSampleForm.exe"
    let _process = Process.Start(_path)
    let getForm() = AutomationElement.FromHandle(_process.MainWindowHandle)
    member x.Run() =
        System.Threading.Thread.Sleep(1000)
        let form = new UIAutomationSampleForm(getForm())
//        
//        // プロパティ設定の自動化テスト
//        form.TextBox2.Text <- "aaa"
//        // 設定したプロパティ値の取得
//        printfn "TextBox2.Text = '%s'" <| form.TextBox2.Text

//        form.ButtonView.Click()
//        form.ButtonTest.Click()

//        form.CheckBox.IsChecked <- not form.CheckBox.IsChecked
//        form.RadioButton1.IsChecked <- true
        form.RadioButton2.Click()

    interface IDisposable with
        member i.Dispose() =
            if not _process.HasExited then
                _process.Kill()
                _process.Dispose()

module Program =
    [<STAThread>]
    [<EntryPoint>]
    let run(_) =
        use sample = new AutomationSample()
        sample.Run()
        stdin.Read() |> ignore
        0

