module BulletManager

open System
open System.Drawing

open fsphys
open fsphys.geom

open Utilities
open PhysicalObjects

let manageBullets = imageFromName "manageBullets.png"
let manageBulletsHover = imageFromName "manageBulletsHover.png"
let manageBulletsSelected = imageFromName "manageBulletsSelected.png"
let unusedBullet = imageFromName "unusedBullet.png"


type BulletManager(x: int, y : int) =
    let mutable stop = false
    let mutable posX = x
    let mutable posY = y
    let mutable manageBulletRect = new Rectangle(5, 115, 50, 50)
    let mutable manageBulletClicked = false
    let mutable lastMousePos = new Point()
    let mutable clickPos = new Point()
    let mutable controlRect = new Rectangle(new Point(posX + 55, posY), new Size(300, 200))
    (*Oggetti del controllo*)
    let bulletRects = new ResizeArray<Rectangle>()    
    (*Oggetti del gioco*)
    let bullets = new ResizeArray<Bullet>()

    let initBulletRects() =
        bulletRects.Clear()
        for j = 1 to 3 do
            for i = 0 to 3 do
                bulletRects.Add(new Rectangle(new Point(controlRect.X + 15 + i * 70, controlRect.Y + 50*j), new Size(60, 40)))

    do
       initBulletRects()
    
    member this.Bullets with get() = bullets

    member this.Count with get() = bullets.Count

    member this.Draw(g:Graphics) = 
        if manageBulletClicked then 
            g.DrawImage(manageBulletsSelected, new Point(posX, posY))
            g.FillRectangle(controlBrush, controlRect)
            g.DrawString("Gestione Proiettili", bigFont, Brushes.Black, new PointF(float32 controlRect.X + 5.f, float32 controlRect.Y + 5.f))
            for i = 0 to bulletRects.Count - 1 do
                if i >= bullets.Count then g.DrawImage(unusedBullet, new PointF(float32 bulletRects.[i].X + 10.f, float32 bulletRects.[i].Y))
                else bullets.[i].DrawInUse(g, new PointF(float32 bulletRects.[i].X + float32 bulletRects.[i].Width/2.f, float32 bulletRects.[i].Y + float32 bulletRects.[i].Height / 2.f))

            done
        else 
        if manageBulletRect.Contains(lastMousePos) then
            g.DrawImage(manageBulletsHover, new Point(posX, posY))
            g.FillRectangle(hoverBrush, new Rectangle(lastMousePos, new Size(150, 30)))
            g.DrawString("Gestione Proiettili", controlFont, Brushes.White, new PointF(float32 lastMousePos.X + 15.f,float32 lastMousePos.Y + 5.f)) 
        else
            g.DrawImage(manageBullets, new Point(posX, posY))
    
    member this.MouseMove(loc:Point) = 
        lastMousePos <- loc

    member this.Click(loc:Point) =
        clickPos <- loc
        if manageBulletClicked = true && not(controlRect.Contains(loc)) then
            manageBulletClicked <- false
        if manageBulletRect.Contains(loc) then
            manageBulletClicked <- not(manageBulletClicked)

        if manageBulletClicked then
            (*Eliminazione proiettili*)
            for i = 0 to bullets.Count - 2 do
                if bulletRects.[i].Contains(loc) then
                    let t = bullets.[i].Type
                    bullets.RemoveAt(i)
                    if t = 0 then bullets.Insert(i, new ExplosiveBullet())
                    else bullets.Insert(i, new NormalBullet())
            done
            if bullets.Count >= 1 && bulletRects.[bullets.Count - 1].Contains(loc) then
                let t = bullets.[bullets.Count - 1].Type
                let c = bullets.Count - 1
                bullets.RemoveAt(bullets.Count - 1)
                if t = 0 then bullets.Insert(c, new ExplosiveBullet())
            else
                if bullets.Count < bulletRects.Count && bulletRects.[bullets.Count].Contains(loc) then
                    bullets.Add(new NormalBullet())


    member this.Position(x:int, y:int) =
        posX <- x
        posY <- y
        manageBulletRect <- new Rectangle(new Point(x, y), new Size(50, 50))
        controlRect <- new Rectangle(new Point(posX + 55, posY), new Size(300, 200))
        initBulletRects()
