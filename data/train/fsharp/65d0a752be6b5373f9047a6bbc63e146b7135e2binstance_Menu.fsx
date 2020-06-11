module instance.menu

#load "instance_MainInstance.fsx"
#r "graphics.dll"
open System.Windows.Forms


type Menu = class

    // generate a horizontal line
    static member internal hline() = new MenuItem("-")


    // menu item 'Files'
    static member private Menu_Files(m: instance.main.MainInstance) =
        let files_new = new MenuItem("&New")
        let files_open = new MenuItem("&Open")
        let files_save = new MenuItem("&Save")
        let files_save_as = new MenuItem("Save As")
        let files_settings = new MenuItem("S&ettings")
        let files_close_file = new MenuItem("&Close File")
        let files_exit = new MenuItem("E&xit")

        // setting up key commands and shortcuts
        files_new.Shortcut <- Shortcut.CtrlN
        files_open.Shortcut <- Shortcut.CtrlO
        files_save.Shortcut <- Shortcut.CtrlS
        files_save_as.Shortcut <- Shortcut.CtrlShiftS
        files_settings.Shortcut <- Shortcut.CtrlE
        files_exit.Shortcut <- Shortcut.CtrlX

        // defining program actions from the input MainInstance
        files_new.Click.AddHandler(new System.EventHandler
            (fun s e -> m.CreateNewFileInstance()))

        files_open.Click.AddHandler(new System.EventHandler
            (fun s e -> m.LoadFileInstance()))

        files_save.Click.AddHandler(new System.EventHandler
            (fun s e -> m.SaveFileInstance()))

        files_save_as.Click.AddHandler(new System.EventHandler
            (fun s e -> m.SaveAsFileInstance()))

        files_settings.Click.AddHandler(new System.EventHandler
            (fun s e -> m.PrintAllSettings()))

        files_close_file.Click.AddHandler(new System.EventHandler
            (fun s e -> m.CloseCurrentFileInstance()))

        files_exit.Click.AddHandler(new System.EventHandler
            (fun s e -> m.ExitProgram()))

        // collecting the menu items and returning the menu
        new MenuItem("&Files",
            [|
                files_new;
                files_open;
                files_save;
                files_save_as;
                Menu.hline();
                files_settings;
                Menu.hline();
                files_close_file;
                files_exit
            |])
      

    // menu item 'Edit'
    static member private Menu_Edit(m: instance.main.MainInstance) =
        let edit_undo = new MenuItem("&Undo")
        let edit_redo = new MenuItem("&Redo")
        let edit_delete = new MenuItem("&Delete")
        let edit_delete_all = new MenuItem("Delete All")

        // setting up key commands and shortcuts

        // defining program actions from the input MainInstance

        // collecting the menu items and returning the menu
        new MenuItem("&Edit",
            [|
                edit_undo;
                edit_redo;
                edit_delete;
                edit_delete_all
            |])


    // menu item 'Tools'
    static member private Menu_Tools(m: instance.main.MainInstance) =
        let tools_move = new MenuItem("&Move")
        let tools_rotate = new MenuItem("&Rotate")
        let tools_scale = new MenuItem("&Scale")
        let tools_change_color = new MenuItem("&Change Color")

        // setting up key commands and shortcuts

        // defining program actions from the input MainInstance


        // collecting the menu items and returning the menu
        new MenuItem("&Tools",
            [|
                tools_move;
                tools_rotate;
                tools_scale;
                tools_change_color
            |])


    // menu item 'Help'
    static member private Menu_Help(m: instance.main.MainInstance) =
        let help_about = new MenuItem("&About")
        let help_show_documentation = new MenuItem("Show &Documentation")
        
        // setting up key commands and shortcuts
        help_show_documentation.Shortcut <- Shortcut.F1

        // defining program actions from the input MainInstance
        help_about.Click.AddHandler(new System.EventHandler
            (fun s e ->
                if not (m.IsOpenChildForm) then
                    let win = graphics.dialogs.createHelpAboutDialog()
                    win.Closed.AddHandler(new System.EventHandler
                        (fun s e ->
                            m.IsOpenChildForm <- false
                            try win.Dispose() with | _ -> ()
                        ))
                    m.IsOpenChildForm <- true
                    win.Show()
            ))

        // collecting the menu items and returning the menu
        new MenuItem("&Help",
            [|
                help_about;
                help_show_documentation
            |])

             
    // create the entire main menu strip
    static member CreateMenu(m: instance.main.MainInstance) =
        new MainMenu
            [| 
                Menu.Menu_Files(m);
                Menu.Menu_Edit(m);
                Menu.Menu_Tools(m);
                Menu.Menu_Help(m)
            |]   

end
