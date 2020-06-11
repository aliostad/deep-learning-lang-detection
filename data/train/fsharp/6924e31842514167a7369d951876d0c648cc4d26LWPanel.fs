module LWPanel

open VWCoordinates
open LWC
open System.Drawing
open System.Drawing.Drawing2D
open System.Windows.Forms

/// The Panel is a container; it can contain Controls in form of LWControls,
/// and manage the event for all of this (simulates event handler calls)
type LWPanel(c:Color) as this =
    inherit LWC()

    let controls = ResizeArray<LWC>()
    let innerBrush = new SolidBrush(c)
    let mutable borderSize = 3.f

    let cloneMouseEvent (c:LWC) (e:MouseEventArgs) =
      let t = new VWCoordinates()
      t.Translate(single c.Location.X, single c.Location.Y)
      t.Multiply(c.transform)
      let p = t.TransformPointVW(e.Location)
      new MouseEventArgs(e.Button, e.Clicks, int p.X, int p.Y, e.Delta)
      
    let correlate (e:MouseEventArgs) (f:LWC->MouseEventArgs->unit) =
      let mutable found = false

      for i in { (controls.Count - 1) .. -1 .. 0 } do
        if not found then
          let c = controls.[i]
          let relativeEvent = cloneMouseEvent c e
          if c.HitTest(PointF(single(relativeEvent.Location.X), single(relativeEvent.Location.Y))) then
            if not c.isMouseHover then 
              c.isMouseHover <- true
              c.OnMouseEnter(System.EventArgs.Empty)
            f c relativeEvent
            found <- true
          else 
            if c.isMouseHover then c.isMouseHover <- false; c.OnMouseLeave(System.EventArgs.Empty)
    

    let mutable captured : LWC option = None
  
    do 
      this.controlType <- PANEL
        
    member val LWMouseEventHandled = false with get, set
    
    member this.LWControls = controls

    member this.BorderSize
        with get() = borderSize
        and set(v) = borderSize <- v

    override this.OnMouseDown e =
      this.LWMouseEventHandled <- false
      correlate e (fun c ev -> captured <- Some(c); c.OnMouseDown(ev); this.LWMouseEventHandled <- c.MouseEventHandled; c.MouseEventHandled <- false)
      base.OnMouseDown e

    override this.OnMouseUp e =
      this.LWMouseEventHandled <- false
      correlate e (fun c ev -> c.OnMouseUp(ev); this.LWMouseEventHandled <- c.MouseEventHandled; c.MouseEventHandled <- false)
      match captured with
        | Some c -> c.OnMouseUp(cloneMouseEvent c e); captured <- None
        | None  -> ()
      base.OnMouseUp e

    override this.OnMouseMove e =
      this.LWMouseEventHandled <- false
      correlate e (fun c ev -> c.OnMouseMove(ev); this.LWMouseEventHandled <- c.MouseEventHandled; c.MouseEventHandled <- false)
      match captured with
        | Some c -> c.OnMouseMove(cloneMouseEvent c e)
        | None  -> ()
      base.OnMouseMove e
      
    override this.OnKeyDown e =
      for i in { (controls.Count - 1) .. -1 .. 0 } do
          let c = controls.[i]
          c.OnKeyDown(e)

    override this.OnPaint(e) =
      let g = e.Graphics

      let pBorder, pBorder2 = new Pen(Color.DarkGray, Width = borderSize), new Pen(Color.Black, Width = borderSize / 4.f)

      
      g.FillRectangle(innerBrush, 0.f, 0.f, this.Size.Width - borderSize, this.Size.Height - borderSize)
      g.DrawRectangle(pBorder, borderSize / 2.f, borderSize / 2.f, this.Size.Width - borderSize, this.Size.Height - borderSize)
      g.DrawRectangle(pBorder2, 0.f, 0.f, this.Size.Width, this.Size.Height)
      g.DrawRectangle(pBorder2, borderSize, borderSize, this.Size.Width - 2.f * borderSize, this.Size.Height - 2.f * borderSize)
      

      controls |> Seq.iter (fun c ->

        let s = g.Save()

        let t = g.Transform.Clone()
        t.Multiply(c.transform.WV)
        g.Transform <- t
        g.TranslateTransform(c.Location.X, c.Location.Y)
        
        let clip = g.Clip.Clone()
        clip.Intersect(RectangleF(0.f, 0.f, c.Size.Width + 1.f, c.Size.Height + 1.f))
        g.Clip <- clip
        let r = g.ClipBounds

        let evt = new PaintEventArgs(g, new Rectangle(int(r.Left), int(r.Top), int(r.Width), int(r.Height)))
        c.OnPaint evt
        g.Restore(s)
      )

    
    override this.HitTest p =
      (RectangleF(PointF(), this.Size)).Contains(p)


