namespace TestCaseManager.XwtUI.Widgets

open Xwt
open Common

type MainWindow() as mw =
    inherit Window()

    let _mainMenu = new MainMenu()
    let _mainContent = new MainContent()

    do
        mw.Width <- Settings.WindowWidth
        mw.Height <- Settings.WindowHeight

        mw.MainMenu <- _mainMenu
        mw.Content <- _mainContent

        // Event handlers registration: MAIN MENU
        _mainMenu.OnFileOpenClicked.Add(mw.FileOpenClickedHandler)
        _mainMenu.OnFileSaveClicked.Add(mw.FileSaveClickedHandler)
        // Event handlers registration: MAIN WINDOW
        mw.CloseRequested.Add(mw.CloseRequestedHandler)

    member private x.CloseRequestedHandler(args) =
        // Stores window position and geometry for later usage.
        Settings.WindowWidth <- x.Width
        Settings.WindowHeight <- x.Height
            
        args.AllowClose <- true
        Application.Exit()

    member private x.FileOpenClickedHandler(args) =
        printfn "OPEN %s" <| _mainContent.Panel1.Content.ToString()
        _mainContent.TestCaseEditor.LoadTestCase()

    member private x.FileSaveClickedHandler(args) =
        printfn "SAVE %s" <| _mainContent.Panel1.Content.ToString()
        _mainContent.TestCaseEditor.StoreTestCase()