module LevelEditor

open System
open System.Drawing
open System.Windows.Forms

open fsphys
open fsphys.geom
open PhysicalObjects
open AnimationObjects
open Utilities
open BulletManager
open ObjectsManager
open TargetsManager
open LevelSave

let scrollButton = imageFromName "scroll.png"
let scrollButtonHover = imageFromName "scrollHover.png"

let zoomIn = imageFromName "zoomIn.png"
let zoomInHover = imageFromName "zoomInHover.png"
let zoomOut = imageFromName "zoomOut.png"
let zoomOutHover = imageFromName "zoomOutHover.png"

let saveIcon = imageFromName "saveIcon.png"
let saveIconHover = imageFromName "saveIconHover.png"

let stopIcon = imageFromName "stopIcon.png"
let stopIconHover = imageFromName "stopIconHover.png"

let startIcon = imageFromName "startIcon.png"
let startIconHover = imageFromName "startIconHover.png"

let deleteBody = imageFromName "deleteBody.png"
let rotateItem = imageFromName "rotateItem.png"
type LevelEditor() as this =
    inherit UserControl()
    let landPos = 615.
    let mutable landWidth = 3000.
    let mutable gameWidth = 3000.

    let mutable maxR = Math.Pow(1000., 2.)*Math.Sin(Math.PI/2.)/300.

    let mutable zoom = 1.f
    let mutable stop = false
    (*Variabile per lo scorrimento orizzontale della finestra di editing*)
    let mutable translation = 0.f

    let mutable clickPos = new Point()

    let mutable lastMousePos = new Point()

    (*Controlli di scorrimento*)
    let mutable scrollRightRect = new Rectangle(this.ClientRectangle.Width - 20, 0, 20, this.ClientRectangle.Height)
    let mutable scrollingRight = false
    let mutable scrollLeftRect = new Rectangle(0, 0, 20, this.ClientRectangle.Height)
    let mutable scrollingLeft = false

    (*Controlli di zoom*)
    let mutable zoomInRect = new Rectangle(5, 5, 50, 50)
    let mutable zoomOutRect = new Rectangle(5, 60, 50, 50)

    (*Controllo gestione proiettile*)
    let mutable bulletManager = new BulletManager(5, 115)

    (*Controllo salvataggio*)
    let mutable saveRect = new Rectangle(5, 280, 50, 50)

    (*Controllo corpi*)
    let mutable clicked = false
    let mutable selected = false
    let mutable fixedPos = vec(0., 0.)
    let mutable clickedId = 0
    let mutable editItemRect = new Rectangle()
    let mutable deleteItemRect = new Rectangle()
    let mutable unvalidPos = false
    let mutable rotatingHandles = new ResizeArray<RectangleF>()
    let mutable rotating = false
    let mutable initialAngle = 0.

    let mutable physics = true
    let mutable stoppedPos = new ResizeArray<vec>()
    let init () =
          
          let p = phys.init <| phys.default_cfg 30.
  
          List.iter (p.add_body>>ignore)
            [
                yield (vec(gameWidth / 2., 615.), 0.), phys.def.body_static [Utilities.box landWidth 50.]
            ]
  
          p

    let mutable p = ref (init ())

    let update () = (!p).update()
    
    let zoomTranslation() = 
       -(zoom - 1.f) *float32 this.ClientRectangle.Height/zoom + float32 this.ClientRectangle.Height - float32 landPos + 25.f - float32(float this.ClientRectangle.Height - landPos + 25.)/zoom
    
    let scaledLocation(p:Point) = 
        new Point(int(float32 p.X/zoom) - int translation, int(float32 p.Y/zoom)- int(zoomTranslation()))
    (*Controllo inserimento ostacoli*)
    let mutable corr = new ResizeArray<int>()

    let mutable objectsManager = new ObjectsManager(5, 170, p, corr)

    let mutable targetsManager = new TargetsManager(5, 225, p, corr)

    let mutable managePhysRect = new Rectangle(5, 335, 50, 50)

    let ObjectsAddHandler = 
        new Handler<Point>(
            fun sender eventargs ->
                if physics = false then
                    stoppedPos.Add(vec(float eventargs.X, float eventargs.Y))
        )

   

    let saveLevel() =
        let mutable maxGameWidth = maxR
        let mutable i = 1
        let mutable s = p.contents.dump.bodies.Count
        while i < s do (*Eliminazione corpi fuori dall'area di gioco e calcolo della massima lunghezza di gioco.*)
            let b = p.contents.dump.bodies.[i]
            if b.pos.x + 400. > maxGameWidth then 
                maxGameWidth <- b.pos.x + 400.
            if b.pos.y > 590. then 
                if corr.[i] = 0 then 
                    objectsManager.RemoveAt(i)
                else
                    targetsManager.RemoveAt(i)

                p.contents.dump.bodies.RemoveAt(i)
                s <- s - 1
            else
                i <- i + 1
        done
        if bulletManager.Count = 0 then
            MessageBox.Show("Devi aggiungere dei proiettili prima di salvare!") |> ignore
        else
            if targetsManager.Count = 0 then 
                MessageBox.Show("Devi aggiungere almeno un obiettivo prima di salvare!") |> ignore
            else
                let a = new LevelSave("livello di prova", maxGameWidth, p, objectsManager.Obstacles, bulletManager.Bullets, targetsManager.Targets, corr)
                if a.Done then MessageBox.Show("Livello salvato con successo") |> ignore

    let updateItemRect(b: body.t, loc:vec) =
        let b = p.contents.dump.bodies.[clickedId]
        let s = b.shapes.[0]
        editItemRect <- 
            match s with
                    | shape.Poly p ->
                    let pts = new ResizeArray<vec>(p.verts)
                    let mutable minX, minY = 56635., 566365.
                    let mutable maxW, maxH = 0., 0.
                    (*Determiniamo il vertice più in alto a sinistra*)
                    rotatingHandles.Clear()
                    for i = 0 to pts.Count - 1 do
                        let point = pts.[i]
                        if point.x < minX then minX <- point.x
                        if point.y < minY then minY <- point.y
                        if point.y > landPos then 
                            unvalidPos <- true
                        rotatingHandles.Add(new RectangleF(float32 point.x - 5.f, float32 point.y - 5.f, 10.f, 10.f))
                                             
                    done
                    for point in pts do
                        if point.x - minX > maxW then maxW <- point.x - minX
                        if point.y - minY > maxH then maxH <- point.y - minY
                    done
                        
                    new Rectangle(int minX, int minY, int maxW, int maxH) 
                        
                 
                    | shape.Circle c -> new Rectangle(int loc.x - int c.radius, int loc.y - int c.radius, int c.radius * 2, int c.radius * 2) 
       
        deleteItemRect <- new Rectangle(editItemRect.X + editItemRect.Width, editItemRect.Y, 20, 20)
    

    do
        objectsManager.ObjectAdded.AddHandler(ObjectsAddHandler)
        targetsManager.ObjectAdded.AddHandler(ObjectsAddHandler)
        corr.Add(-1)
        this.SetStyle(ControlStyles.OptimizedDoubleBuffer ||| ControlStyles.AllPaintingInWmPaint,true)
        (*Funzione per la gestione degli scroller e dello zoom.*)
         
    member this.Run() =
        let Location = scaledLocation(lastMousePos)
        if not stop then
            if clickedId > 0 && selected && rotating && not clicked then
              let angle = initialAngle - Math.Atan2(p.contents.dump.bodies.[clickedId].pos.y - float Location.Y,float Location.X - p.contents.dump.bodies.[clickedId].pos.x)
              p.contents.dump.bodies.[clickedId].ang <- angle

            update()
            if physics = false then
                for i = 0 to p.contents.dump.bodies.Count - 1 do
                    let b = p.contents.dump.bodies.[i]
                    b.pos <- stoppedPos.[i]
                    b.asnap <- 0.
                    b.vel <- vec(0., 0.)
                    b.snap <- vec(0., 0.)
                    b.rot <- 0.
                done 
            if clickedId > 0 then
                
                if clicked then (*Dragging*)
                    updateItemRect(p.contents.dump.bodies.[clickedId], vec(float Location.X, float Location.Y))
                    p.contents.dump.bodies.[clickedId].pos <-vec(float Location.X, float Location.Y)
                    if not physics then stoppedPos.[clickedId] <- vec(float Location.X, float Location.Y)
                if selected && not clicked then
                    updateItemRect(p.contents.dump.bodies.[clickedId], fixedPos)
                    p.contents.dump.bodies.[clickedId].pos <- fixedPos
                    

                if selected then                    
                    p.contents.dump.bodies.[clickedId].vel <- vec(0., 0.)
                    p.contents.dump.bodies.[clickedId].asnap <- 0.
                    p.contents.dump.bodies.[clickedId].snap <- vec(0., 0.)
                    p.contents.dump.bodies.[clickedId].rot <- 0.

       
            if scrollingRight then
                this.Scroll(-10.f)
            if scrollingLeft then
                this.Scroll(10.f)
            if scrollingRight || scrollingLeft then
                if translation < 0.f then
                    zoomInRect <- new Rectangle(25, 5, 50, 50)
                    zoomOutRect <- new Rectangle(25, 60, 50, 50)
                    objectsManager.Position(25, 170)
                    bulletManager.Position(25, 115)
                    targetsManager.Position(25, 225)
                    saveRect <- new Rectangle(25, 280, 50, 50)
                    managePhysRect <- new Rectangle(25, 335, 50, 50)
                else
                    zoomInRect <- new Rectangle(5, 5, 50, 50)
                    zoomOutRect <- new Rectangle(5, 60, 50, 50)
                    saveRect <- new Rectangle(5, 280, 50, 50)
                    managePhysRect <- new Rectangle(5, 335, 50, 50)
                    targetsManager.Position(5, 225)
                    objectsManager.Position(5, 170)
                    bulletManager.Position(5, 115)
        this.Invalidate()
    
    member this.Stop() = stop <- true

    override this.OnResize(e) =
        base.OnResize(e)
        scrollRightRect <- new Rectangle(this.ClientRectangle.Width - 20, 0, 20, this.ClientRectangle.Height)
        scrollLeftRect <- new Rectangle(0, 0, 20, this.ClientRectangle.Height)
        objectsManager.SetZoom(zoom, -(zoom - 1.f) *float32 this.ClientRectangle.Height/zoom + float32 this.ClientRectangle.Height - float32 landPos + 25.f - float32(float this.ClientRectangle.Height - landPos + 25.)/zoom)
        targetsManager.SetZoom(zoom, -(zoom - 1.f) *float32 this.ClientRectangle.Height/zoom + float32 this.ClientRectangle.Height - float32 landPos + 25.f - float32(float this.ClientRectangle.Height - landPos + 25.)/zoom)
        this.Invalidate()

    override this.OnPaint(e) =
        base.OnPaint(e)
        let g = e.Graphics
        skytexture.TranslateTransform(translation, 0.f)
        g.FillRectangle(skytexture, new Rectangle(0, 0, this.ClientRectangle.Width, 349))
        skytexture.ResetTransform()

        hillstexture.TranslateTransform(translation,float32 landPos - 249.f)
        g.FillRectangle(hillstexture, new Rectangle(0,int landPos - 249, this.ClientRectangle.Width, 249))
        hillstexture.ResetTransform()


        skyobjecttexture.TranslateTransform(translation, 0.f)
        g.FillRectangle(skyobjecttexture, new Rectangle(0, 0, this.ClientRectangle.Width, 482))
        skyobjecttexture.ResetTransform()
              
        
        
        g.ScaleTransform(zoom, zoom)
        if zoom <> 1.f then g.TranslateTransform(0.f, zoomTranslation())
        
        g.TranslateTransform(translation, 0.f)

        g.DrawLine(dottedPen, new PointF(float32 maxR,-zoomTranslation()), new PointF(float32 maxR, float32 this.ClientRectangle.Height + zoomTranslation()))


        objectsManager.DrawBodies(g)
        targetsManager.DrawBodies(g)

        if selected && not clicked && clickedId > 0 then 

            let b = p.contents.dump.bodies.[clickedId]
            let s = b.shapes.[0]
            match s with
             | shape.Poly p -> 
                
                for r in rotatingHandles do 
                    g.FillEllipse(Brushes.Gold, r)
                done
             | _ -> ()

            if unvalidPos then g.FillRectangle(wrongBrush,editItemRect)  
            g.DrawImage(deleteBody, deleteItemRect)
        g.ResetTransform()


        dirttexture.TranslateTransform(translation, float32 landPos - 25.f)
        g.FillRectangle(dirttexture, new Rectangle(0, int landPos - 25, this.ClientRectangle.Width, this.ClientRectangle.Height - int landPos + 25))
        dirttexture.ResetTransform()


        grasstexture.TranslateTransform(translation,float32 landPos - 38.f)
        g.FillRectangle(grasstexture, new Rectangle(0, int landPos - 38,  this.ClientRectangle.Width, 16))
        grasstexture.ResetTransform()

        (*Controlli di scorrimento*)
        if translation - float32 this.ClientRectangle.Width / zoom > -(float32 maxR + 380.f) then
            g.FillRectangle(controlBrush, scrollRightRect)
            if scrollingRight then g.DrawImage(scrollButtonHover,new PointF(float32 scrollRightRect.X, float32 this.ClientRectangle.Height/2.f - float32 scrollButtonHover.Height/2.f))
            else g.DrawImage(scrollButton, new PointF(float32 scrollRightRect.X, float32 this.ClientRectangle.Height/2.f - float32 scrollButton.Height/2.f))
         
        if translation < 0.f then 
            g.FillRectangle(controlBrush, scrollLeftRect)
            scrollButton.RotateFlip(RotateFlipType.Rotate180FlipNone)
            scrollButtonHover.RotateFlip(RotateFlipType.Rotate180FlipNone)
            if scrollingLeft then g.DrawImage(scrollButtonHover, new PointF(0.f, float32 this.ClientRectangle.Height/2.f - float32 scrollButtonHover.Height/2.f))
            else g.DrawImage(scrollButton, new PointF(0.f, float32 this.ClientRectangle.Height/2.f - float32 scrollButton.Height/2.f))
            scrollButton.RotateFlip(RotateFlipType.Rotate180FlipNone)
            scrollButtonHover.RotateFlip(RotateFlipType.Rotate180FlipNone)
        (*Controlli di Zoom*)
        if zoomInRect.Contains(lastMousePos) then 
            g.DrawImage(zoomInHover, zoomInRect)
            g.FillRectangle(hoverBrush, new RectangleF(new PointF(float32 lastMousePos.X, float32 lastMousePos.Y - 5.f), new SizeF(100.f, 30.f)))
            g.DrawString(sprintf "Zoom: %.2f" zoom, controlFont, Brushes.White, new PointF(float32 lastMousePos.X + 10.f, float32 lastMousePos.Y))
        else g.DrawImage(zoomIn, zoomInRect)

        if zoomOutRect.Contains(lastMousePos) then 
            g.DrawImage(zoomOutHover, zoomOutRect)
            g.FillRectangle(hoverBrush, new RectangleF(new PointF(float32 lastMousePos.X, float32 lastMousePos.Y - 5.f), new SizeF(100.f, 30.f)))
            g.DrawString(sprintf "Zoom: %.2f" zoom, controlFont, Brushes.White, new PointF(float32 lastMousePos.X + 10.f, float32 lastMousePos.Y))
        else g.DrawImage(zoomOut, zoomOutRect)
        
      

       (*Salvataggio*)
        if saveRect.Contains(lastMousePos) then
            g.DrawImage(saveIconHover, saveRect)
            g.FillRectangle(hoverBrush, new RectangleF(new PointF(float32 lastMousePos.X, float32 lastMousePos.Y - 5.f), new SizeF(100.f, 30.f)))
            g.DrawString("Salva livello", controlFont, Brushes.White, new PointF(float32 lastMousePos.X + 10.f, float32 lastMousePos.Y))
        else g.DrawImage(saveIcon, saveRect)

        if managePhysRect.Contains(lastMousePos) then
            let phimg = if physics then stopIconHover else startIconHover
            g.DrawImage(phimg, managePhysRect)
            g.FillRectangle(hoverBrush, new RectangleF(new PointF(float32 lastMousePos.X, float32 lastMousePos.Y - 5.f), new SizeF(150.f, 30.f)))
            g.DrawString((if physics then "Arresta motore fisico" else "Riavvia motore fisico"), controlFont, Brushes.White, new PointF(float32 lastMousePos.X + 10.f, float32 lastMousePos.Y))
        else
            let phimg = if physics then stopIcon else startIcon
            g.DrawImage(phimg, managePhysRect)
            
        targetsManager.Draw(g)         
        objectsManager.Draw(g)
        bulletManager.Draw(g)


    override this.OnMouseClick(e) =
        base.OnClick(e)
        
        if zoomInRect.Contains(e.Location) then
            zoom <- zoom + 0.1f
            objectsManager.SetZoom(zoom,  zoomTranslation())
        if zoomOutRect.Contains(e.Location) then
            zoom <- zoom - 0.1f
            objectsManager.SetZoom(zoom,  zoomTranslation())
        if saveRect.Contains(e.Location) then
            saveLevel()
        
        if managePhysRect.Contains(e.Location) then
            physics <- not(physics)
            if physics = false then
                stoppedPos.Clear()
                for b in p.contents.dump.bodies do
                    stoppedPos.Add(b.pos)
                done

        objectsManager.Click(e.Location)
        bulletManager.Click(e.Location)
        targetsManager.Click(e.Location)

    override this.OnMouseMove(e) =
        base.OnMouseMove(e)
        lastMousePos <- e.Location
        if scrollRightRect.Contains(e.Location) then (*Lanciamo lo scorrimento verso destra*)
            scrollingRight <- true
            scrollingLeft <- false
        else
            if scrollLeftRect.Contains(e.Location) && translation < 0.f then
                scrollingLeft <- true
                scrollingRight <- false
            else
                scrollingRight <- false
                scrollingLeft <- false
        targetsManager.MouseMove(e.Location)
        objectsManager.MouseMove(e.Location)
        bulletManager.MouseMove(e.Location)

    override this.OnMouseDown(e) =
        base.OnMouseDown(e)
        (*Verifichiamo se stiamo clickando su un corpo*)
        let Location = scaledLocation(e.Location)
        if selected && not clicked && clickedId > 0 && deleteItemRect.Contains(Location) then 
                if corr.[clickedId] = 0 then objectsManager.RemoveAt(clickedId)
                else targetsManager.RemoveAt(clickedId)

                p.contents.dump.bodies.RemoveAt(clickedId) 
                clickedId <- 0
        else
            let mutable j = 0
            while j < rotatingHandles.Count && not rotating do
                let r = rotatingHandles.[j]
                if r.Contains(new PointF(float32 Location.X,float32 Location.Y)) then
                    rotating <- true
                    initialAngle <- Math.Atan2(p.contents.dump.bodies.[clickedId].pos.y - float e.Location.Y,float e.Location.X - p.contents.dump.bodies.[clickedId].pos.x)
                    
                j <- j + 1
            done
            if not rotating then       
                clicked <- false
                let mutable i = 0
                while i < p.contents.dump.bodies.Count && clicked = false do
                    let b : body.t = p.contents.dump.bodies.[i]
                    let s = b.shapes.[0]
                    match s with
                        | shape.Poly p ->
                            if pointInRectangle(new PointF(float32 Location.X, float32 Location.Y), p.verts) then
                                clicked <- true
                                unvalidPos <- false
                                clickedId <- i
                        | shape.Circle c ->
                            let dx = Math.Abs(float Location.X - b.pos.x)
                            let dy = Math.Abs(b.pos.y - float Location.Y)
                            let d = Math.Sqrt(Math.Pow(dx, 2.) + Math.Pow(dy, 2.))
                            if d < c.radius then
                                clicked <- true
                                unvalidPos <- false
                                clickedId <- i
                    i <- i+1
                done
                selected <- clicked 
        objectsManager.MouseDown(e.Location)
        targetsManager.MouseDown(e.Location)

    override this.OnMouseUp(e) =
        base.OnMouseUp(e)
        let Location = scaledLocation(e.Location)
        objectsManager.MouseUp(e.Location)
        targetsManager.MouseUp(e.Location)
        rotating <- false
        if clicked then 
            clicked <- false
            updateItemRect(p.contents.dump.bodies.[clickedId], vec(float Location.X, float Location.Y))
            fixedPos <- vec(float Location.X,float Location.Y)
       
    override thi.OnKeyPress(e) =
        base.OnKeyPress(e)
        physics <- false
        for b in p.contents.dump.bodies do
            stoppedPos.Add(b.pos)
        done

    member this.Scroll(q : float32) =
        translation <- if translation + q <= 0.f then  translation + q else 0.f
        if -translation + 400.f > float32 maxR then translation <- translation - q
        if (- translation + float32 this.ClientRectangle.Width)/zoom > float32(p.contents.dump.bodies.[0].pos.x + landWidth/2.) then
            //MessageBox.Show(sprintf "%f %f %f" translation landWidth gameWidth) |> ignore 
            landWidth <- -float(translation)*2./float zoom
            gameWidth <- -float(translation)*2./float zoom
            p.contents.dump.bodies.RemoveAt(0)
            (!p).add_body((vec(gameWidth / 2., 615.), 0.), phys.def.body_static [Utilities.box landWidth 50.]) |> ignore
            update()
            p.contents.dump.bodies.Insert(0, p.contents.dump.bodies.[p.contents.dump.bodies.Count - 1])
            p.contents.dump.bodies.RemoveAt(p.contents.dump.bodies.Count - 1)
            
      
        objectsManager.SetTranslation(translation)
        targetsManager.SetTranslation(translation)