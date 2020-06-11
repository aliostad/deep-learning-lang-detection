module Art

open System
open System.Drawing
open System.Drawing.Drawing2D
open System.Windows.Forms

let dankBrush = new SolidBrush(Color.FromArgb(0xFFB9BB75))

let rec dankBackgroundHelper (g:Graphics) (x:int) (y:int) (num:int) (brush:Brush) : unit =
  if num <= 0 then
    ()
  else
    g.FillRectangle
      (brush
      ,x
      ,y
      ,8
      ,8)
    dankBackgroundHelper (g) (x) (y + 8) (num - 1) (brush)

let rec dankBackground (g:Graphics) (x:int)  (y:int) (num:int) (brush:Brush) : unit =
  if num <= 0 then
    ()
  else
    dankBackgroundHelper (g) (x) (y) (num) (brush)
    dankBackgroundHelper (g) (x + 8) (y) (num) (brush)
    dankBackground (g) (x + 16) (y) (num - 1) (brush)

let rec dankGnomeGuySquares (g:Graphics) (num) (x:int) (y:int) (scale:int) : unit =
  if num <= 0 then
    ()
  else
    g.FillRectangle
      (dankBrush
      ,x
      ,y
      ,(8 * scale)
      ,(8 * scale))
    dankGnomeGuySquares (g) (num - 1) (x + 8) (y) (scale)

let rec dankGnomeGuyBody (g:Graphics) (num:int) (con:int) (x:int) (y:int) (scale:int) : unit =
  if num <= 0 then
    ()
  else
    dankGnomeGuySquares (g) (con - num) (x) (y) (scale)
    dankGnomeGuyBody (g) (num - 1) (con) (x - 4) (y + 8) (scale)

let rec dankGnomeGuyHead (g:Graphics) (num:int) (con:int) (x:int) (y:int) (scale:int) : unit =
  if num <= 0 then
    ()
  else
    dankGnomeGuySquares (g) (con - num) (x) (y) (scale)
    dankGnomeGuyHead (g) (num - 1) (con) (x - 4) (y + 8) (scale)

let rec dankGnomeGuyFace (g:Graphics) (num:int) (x:int) (y:int) (scale:int) : unit =
  if num <= 0 then
    ()
  else
    dankGnomeGuySquares (g) (num) (x) (y) (scale)
    dankGnomeGuySquares (g) (num) (x) (y + 8) (scale)
    dankGnomeGuyFace (g) (num - 1) (x + 4) (y + 16) (scale)

let rec dankGnomeGuyOther (g:Graphics) : unit =
  ()

let dankComputerMonitor (g:Graphics) : unit =
  g.FillPolygon
    (Brushes.DarkGray
    ,[| new Point(250, 530)
      ; new Point(250, 710)
      ; new Point(440, 650)
      ; new Point(440, 530)
      |])
  g.FillPolygon
    (Brushes.DarkGray
    ,[| new Point(300, 600)
      ; new Point(300, 800)
      ; new Point(390, 800)
      ; new Point(390, 600)
    |])

let dankText (g:Graphics) : unit =
  g.DrawString
    ("DANK MEMES"
    ,new Font("Arial", 40.0f)
    ,Brushes.White
    ,200.0f
    ,20.0f)


let art _ : unit =
  let dankForm = new Form()
  let dankPixelSize = 8
  dankForm.Width <- 800
  dankForm.Height <- 800
  dankForm.BackColor <- Color.Black

  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankBackground dank.Graphics 0 0 70 Brushes.Blue))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankBackground dank.Graphics 0 0 60 Brushes.Orange))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankBackground dank.Graphics 0 0 50 Brushes.Purple))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankBackground dank.Graphics 0 0 40 Brushes.Red))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankBackground dank.Graphics 0 0 30 Brushes.SaddleBrown))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankBackground dank.Graphics 0 0 20 Brushes.Silver))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankBackground dank.Graphics 0 0 10 Brushes.Aquamarine))

  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankGnomeGuyHead dank.Graphics 30 30 150 400 1))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankGnomeGuyFace dank.Graphics 25 50 630 1))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankGnomeGuyBody dank.Graphics 30 30 150 533 1))

  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankGnomeGuyHead dank.Graphics 30 30 150 400 2))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankGnomeGuyFace dank.Graphics 25 50 630 2))
  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankGnomeGuyBody dank.Graphics 30 30 150 533 2))

  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankComputerMonitor dank.Graphics))

  dankForm.Paint.AddHandler
    (PaintEventHandler (fun _ dank -> dankText dank.Graphics))

  Application.Run (dankForm)

[<EntryPoint>]
let main _ : int =
  art ()
  0
