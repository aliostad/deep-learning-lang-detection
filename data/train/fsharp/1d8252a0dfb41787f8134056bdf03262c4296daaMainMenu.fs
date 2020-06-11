namespace TestCaseManager.XwtUI.Widgets

open Xwt

type MainMenu() as mm =
    inherit Menu()

    let _onFileOpenClicked = new Event<_>()
    let _onFileSaveClicked = new Event<_>()
    do
        mm.BuildFileMenu()
        mm.BuildEditMenu()
    
    [<CLIEvent>]
    member x.OnFileOpenClicked = _onFileOpenClicked.Publish

    [<CLIEvent>]
    member x.OnFileSaveClicked = _onFileSaveClicked.Publish

    member private x.BuildFileMenu() =
        let build(menu: MenuItem) =
            x.AddSubMenu(menu, "_Open...", x.FileOpenClickedHandler)
            x.AddSubMenu(menu, "_Save", x.FileSaveClickedHandler)

        x.BuildTopMenu("_File", build)

    member private x.BuildEditMenu() =
        let edit = new MenuItem("_Edit")
        edit.SubMenu <- new Menu()

        let undoEntry = new MenuItem("_Undo")
        edit.SubMenu.Items.Add(undoEntry)

        let redoEntry = new MenuItem("_Redo")
        edit.SubMenu.Items.Add(redoEntry)

        x.Items.Add(edit)

    member private x.BuildTopMenu(menuName, build) =
        let menu = new MenuItem(menuName)
        menu.SubMenu <- new Menu()
        build(menu)
        x.Items.Add(menu)

    member private x.AddSubMenu(menu, subMenuName, clickedHandler) =
        let subMenu = new MenuItem(subMenuName)
        menu.SubMenu.Items.Add(subMenu)
        subMenu.Clicked.Add(clickedHandler)

    member private x.FileOpenClickedHandler args =
        _onFileOpenClicked.Trigger(x, 1)

    member private x.FileSaveClickedHandler args =
        _onFileSaveClicked.Trigger(x, 1)