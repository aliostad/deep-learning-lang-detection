namespace HiMvcDesktopUI

open System.Windows.Controls
open System.Windows
open System.Windows.Media
open System.Windows.Input

type ZoomBorder() as x =
    inherit Border()

    let mutable child:UIElement = null
    let mutable origin = Point()
    let mutable start = Point()

    let getTranslateTransform ( element:UIElement)  = 
        (element.RenderTransform:?>TransformGroup).Children
            |>Seq.find(fun child -> child :? TranslateTransform) :?>TranslateTransform

    let getScaleTransform ( element:UIElement)  = 
        (element.RenderTransform:?>TransformGroup).Children
            |>Seq.find(fun child -> child :? ScaleTransform):?>ScaleTransform
    

    let childMouseWheel sender (e:MouseWheelEventArgs)=
        if not (isNull child) then
            let st = getScaleTransform(child)
            let tt = getTranslateTransform(child)
            let zoom = if e.Delta > 0 then 0.2 else -0.2
            if (e.Delta <= 0) && (st.ScaleX < 0.4 || st.ScaleY < 0.4) then ()
            else
                let relative = e.GetPosition(child)

                let  abosuluteX = relative.X * st.ScaleX + tt.X
                let  abosuluteY = relative.Y * st.ScaleY + tt.Y

                st.ScaleX <- st.ScaleX + zoom
                st.ScaleY <- st.ScaleY + zoom

                tt.X <- abosuluteX - relative.X * st.ScaleX
                tt.Y <- abosuluteY - relative.Y * st.ScaleY

    let childMouseLeftButtonDown sender  ( e:MouseButtonEventArgs)=
        if not (isNull child) then
            let tt = getTranslateTransform(child)
            start <- e.GetPosition(x)
            origin <- Point(tt.X, tt.Y)
            x.Cursor <- Cursors.Hand
            child.CaptureMouse()|>ignore

    let childMouseLeftButtonUp  sender (e:MouseButtonEventArgs) =
        if not (isNull child) then
            child.ReleaseMouseCapture()
            x.Cursor <- Cursors.Arrow

    let childMouseMove sender (e:MouseEventArgs )=
        if not (isNull child) then
            if  child.IsMouseCaptured then
                let tt = getTranslateTransform(child)
                let v = start - e.GetPosition(x)
                tt.X <- origin.X - v.X
                tt.Y <- origin.Y - v.Y

    let reset() =
        // reset zoom
        let st = getScaleTransform(child)
        st.ScaleX <- 1.0
        st.ScaleY <- 1.0

        // reset pan
        let tt = getTranslateTransform(child)
        tt.X <- 0.0
        tt.Y <- 0.0


    let childPreviewMouseRightButtonDown  sender  (e:MouseButtonEventArgs)=
        reset()

    let initialize( element:UIElement) =
        child <- element
        if not (isNull child) then
            let group = TransformGroup()
            let st =  ScaleTransform()
            group.Children.Add(st)
            let tt =  TranslateTransform()
            group.Children.Add(tt)
            child.RenderTransform <- group
            child.RenderTransformOrigin<- new Point(0.0, 0.0)
            x.MouseWheel.AddHandler(MouseWheelEventHandler(childMouseWheel))
            x.MouseLeftButtonDown.AddHandler(new MouseButtonEventHandler(childMouseLeftButtonDown))
            x.MouseLeftButtonUp.AddHandler(new MouseButtonEventHandler(childMouseLeftButtonUp))
            x.MouseMove.AddHandler(new MouseEventHandler(childMouseMove))
            x.PreviewMouseRightButtonDown.AddHandler(new MouseButtonEventHandler(childPreviewMouseRightButtonDown))


    override x.Child 
        with get () = base.Child
        and set (value) = 
            if not (isNull value)&&value <>x.Child then
                initialize value
            base.Child <- value
          
