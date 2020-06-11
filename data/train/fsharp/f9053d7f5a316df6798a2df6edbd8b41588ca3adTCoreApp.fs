namespace TCore

module TCoreApp =
    open TCore.TCoreGui
    open TCore.TCoreSoft

    // Invoked from gui on stepping
    let stepHandler () = 
        // Run the command in the command field
        // A command such as 'ldc 3' 
        TCoreSoft.ves (tCmd.Text)
        // PC increment
        TCoreGui.pc <- TCoreGui.pc + 1 
        guiUpdate()

    // Application entrypoint
    [<EntryPoint>]
    let main args =
        guiInit()
        // Register stephandler in gui
        TCoreGui.setStephandler(stepHandler)
        TCoreGui.startGui()
        0