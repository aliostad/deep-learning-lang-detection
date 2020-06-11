module instance.controls


#load "instance_MainInstance.fsx"
#r "graphics.dll"
open System.Windows.Forms
open System.Drawing



type Control() = class

    static member AttachKeyHandler(m: instance.main.MainInstance) =
        m.MainForm.KeyUp.AddHandler(new KeyEventHandler(fun s e ->
            match e.KeyValue with


            | 76 | 131148 | 65612 ->         // key 'l' -> rotating left
                try 
                    m.FileInstance.RotateRightSelection()
                with
                | _ -> printfn "m.FileInstance.RotateLeftSelection() failed"


            | 82 | 131154 | 65618 ->         // key 'r' -> rotating right
                try
                    m.FileInstance.RotateRightSelection()
                with
                | _ -> printfn "m.FileInstance.RotateRightSelection() failed"


            | 38 ->                          // up -> moving up
                try
                    m.FileInstance.MoveUpSelection()
                with
                | _ -> printfn "m.FileInstance.MoveUpSelection() failed"


            | 40 ->                          // down -> moving down
                try
                    m.FileInstance.MoveDownSelection()
                with
                | _ -> printfn "m.FileInstance.MoveDownSelection() failed"


            | 37 ->                          // left -> moving left
                try
                    m.FileInstance.MoveLeftSelection()
                with
                | _ -> printfn "m.FileInstance.MoveLeftSelection() failed"


            | 39 ->                          // right -> moving right
                try
                    m.FileInstance.MoveRightSelection()
                with
                | _ -> printfn "m.FileInstance.MoveRightSelection() failed"


            | 27 ->                          // escape -> exits the program
                ()


            | 107 | 187 | 131259 | 131179 -> // plus keys -> scale up
                try
                    m.FileInstance.ScaleUpSelection()
                with
                | _ -> printfn "m.FileInstance.ScaleUpSelection() failed"


            | 109 | 189 | 131261 | 131181 -> // minus keys -> scale down
                try
                    m.FileInstance.ScaleDownSelection()
                with
                | _ -> printfn "m.FileInstance.ScaleDownSelection() failed"


            | 67 | 65603 ->                  // key 'c' -> changes color
                ()


            | 73 | 65609 ->                  // key 'i' -> hide/show tooltip
                m.ShowHideToolsMenuItems()
        
            | 83 ->                          // key 's' -> get new window size
                printfn "%A" m.MainForm.Size
                
            | _ ->
                ()
    

            (* UNCOMMENT TO GET THE ENTERED KEY VALUE - FOR TESTING PURPOSES. *)
            printfn "keyvalue: %i ,  keydata: %A" e.KeyValue e.KeyData
    ))




    static member AttachMenuShortcuts() = ()
        // m.MainMenu. ...


    static member  AttachMainFormHandlers(m: instance.main.MainInstance) =
        
        m.MainForm.Closed.AddHandler(new System.EventHandler
            (fun s e -> m.SaveProgramSettings()))

        m.MainForm.Shown.AddHandler(new System.EventHandler
            (fun s e -> m.LoadProgramSettings()))
            
        m.MainForm.Resize.AddHandler(new System.EventHandler
            (fun s e ->
                
                m.MainSize <- (m.MainForm.Size.Width, m.MainForm.Size.Height)
                
                m.MainPanel.Size <- Size(fst m.MainSize - graphics.graphics.sidePanelWidth,
                                         snd m.MainSize)
                
                m.SidePanel.Location <- Point(m.MainPanel.Size.Width, 0)

                m.DrawingPanel.Size <- Size(m.MainPanel.Size.Width,
                                            m.MainPanel.Size.Height - graphics.graphics.msgBoxHeight - graphics.graphics.menuHeight)
                
                m.MessagePanel.Location <- Point(0, m.DrawingPanel.Size.Height)

                m.MessagePanel.Size <- Size(m.MainPanel.Size.Width, graphics.graphics.msgBoxHeight)
            
            ))

end
