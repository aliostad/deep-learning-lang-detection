module MainControls
open System.Windows.Forms
open System.Drawing
open LWC
open MenuButtons
open Pentagramma

type MainControls() as this = 
    inherit LWContainer()

    let menu = new MenuButtons(Location=PointF(0.f, 0.f), Size=SizeF(600.f, 50.f))
    let penta = new Pentagrammi(Location=PointF(0.f, 0.f))    
    let mutable mouseDownScroll = false
    let mutable startScroll = Point()
    let mutable copypaste = false
    let mutable copy_note = null

    do
        this.DoubleBuffered <- true
        menu.SetParent(this)
        penta.SetParent(this)
        this.LWControls.Add(menu)
        this.LWControls.Add(penta)
    
    let newPoint p = 
        let prev = startScroll
        startScroll <- p
        //calcolo solo la differenza sull'asse Y in quanto voglio
        //uno scroll verticale
        Point(0, prev.Y - startScroll.Y)

    override this.OnPaint e =  
        this.LWControls |> Seq.iter( fun c ->
            let s = e.Graphics.Save()
            e.Graphics.TranslateTransform(c.Location.X, c.Location.Y)
            c.OnPaint e
            e.Graphics.Restore(s)
        )
        base.OnPaint(e)

    override this.OnMouseDown e = 
        let oldOption = menu.OptionSelected
        let clickedPoint = PointF(float32 e.Location.X,float32 e.Location.Y)
        if menu.HitTest clickedPoint then
            menu.OnMouseDown e

        match menu.OptionSelected with
        | Menu.AddPentagram -> 
            penta.AddPentagram
            menu.OptionSelected <- oldOption
        | Menu.AddNote -> 
            if oldOption = menu.OptionSelected then
                penta.addNoteIfClick clickedPoint
                
        | Menu.scroll ->
            mouseDownScroll <- true
            startScroll <- e.Location
        | Menu.none -> ()
        | Menu.copyAndPaste ->
            if not(copypaste) && penta.checkHitTestPent clickedPoint then
                copypaste <- true
                copy_note <- penta.copy clickedPoint
            else
                if copypaste && penta.checkHitTestPent clickedPoint then
                    penta.paste copy_note clickedPoint
                    copypaste <- false
            
        | Menu.delete -> 
            penta.removeNoteIfClick clickedPoint

        this.Invalidate()

    override this.OnMouseMove e =
        match menu.OptionSelected with
        | Menu.scroll ->
            if mouseDownScroll then 
                let offset = newPoint(e.Location)
                penta.W2v.Translate(float32 -offset.X, float32 -offset.Y, Drawing2D.MatrixOrder.Append)
                penta.V2w.Translate(float32 offset.X, float32 offset.Y)
        | _ -> ()

        this.Invalidate()

    override this.OnMouseUp e = 
        if mouseDownScroll then
            mouseDownScroll <- false