namespace FSharp.Chapter3

open System
open System.Collections.Generic
open System.ComponentModel
open System.Windows
open System.Windows.Controls
open System.Windows.Data 
open System.Windows.Shapes
open System.Windows.Media;

module tmp = 
    type DependencyProperty with
        member self.Set<'T when 'T :> DependencyObject> (value:obj) (depobj:'T) =
            depobj.SetValue(self,value) ; depobj
        member self.Get<'T when 'T :> DependencyObject> (depobj:'T) =
            depobj.GetValue(self)
        member self.SetBinding<'T when 'T :> FrameworkElement> (binding:Binding) (source:obj) (fraobj:'T) =
            binding.Source <- source
            fraobj.SetBinding(self,binding) |> ignore 
            fraobj
            
    type DependencyPropertyKey with
         member self.Set<'T when 'T :> DependencyObject> (value:obj) (depobj:'T) =
            depobj.SetValue(self,value) ; depobj
            
open tmp

type Button1() = inherit Button()


type ProcessStageHelper() = 
    class
        inherit DependencyObject()
        

        static let processStagePropertyKey   = DependencyProperty.RegisterAttachedReadOnly("ProcessStage", typeof<int>, typeof<ProcessStageHelper>, new PropertyMetadata(1))                                
        static let processStageProperty = processStagePropertyKey.DependencyProperty
        static let processCompletionProperty = 
            DependencyProperty.RegisterAttached(
                "ProcessCompletion",
                typeof<double>, 
                typeof<ProcessStageHelper>,
                new PropertyMetadata(0., PropertyChangedCallback(
                                        fun d e ->
                                             (d :?> ProgressBar) |> processStagePropertyKey.Set  
                                               (match (e.NewValue :?> double) with
                                                | i when i >= 0.  && i <  20. -> 1
                                                | i when i >= 20. && i <  40. -> 2
                                                | i when i >= 40. && i <  60. -> 3
                                                | i when i >= 60. && i <  80. -> 4
                                                | i when i >= 80. && i <= 100. -> 5
                                                | _                           -> 1 ) |> ignore )))

        static member public ProcessStageProperty = processStageProperty
        static member public ProcessStagePropertyKey = processStagePropertyKey
                                                
        static member public ProcessCompletionProperty = processCompletionProperty

        
        member public this.ProcessCompletion
            with get()         = this |> processCompletionProperty.Get :?> double
            and  set(x:double) = this |> processCompletionProperty.Set x |> ignore

        member public this.ProcessStage
            with get()      = this |> processStageProperty.Get :?> int
            and  set(x:int) = this |> processStageProperty.Set x |> ignore         
        
        static member public SetProcessCompletion(bar:ProgressBar, progress:double) = bar |> processCompletionProperty.Set progress |> ignore
        static member public GetProcessCompletion(obj:DependencyObject) = (obj :?> ProgressBar) |> processCompletionProperty.Get :?> double
        
        static member public SetProcessStage(bar:ProgressBar, stage:int) = bar |> processStagePropertyKey.Set stage |> ignore
        static member public GetProcessStage(obj:DependencyObject) = (obj :?> ProgressBar) |> processStageProperty.Get :?> int         
    end







type Arc() = 
    inherit Shape()
    
        static let startAngleProperty = 
            DependencyProperty.Register("StartAngle", typeof<double>, typeof<Arc>,  
                                        FrameworkPropertyMetadata(0., FrameworkPropertyMetadataOptions.AffectsRender))
        static let endAngleProperty = 
            DependencyProperty.Register("EndAngle", typeof<double>,typeof<Arc>, 
                                        FrameworkPropertyMetadata(0., FrameworkPropertyMetadataOptions.AffectsRender))
        
        member this.StartAngle 
            with get()  = this |> startAngleProperty.Get :?> double
            and  set(x:double) = this |> startAngleProperty.Set x |> ignore
            
        member this.EndAngle
            with get()  = this |> endAngleProperty.Get :?> double
            and  set(x:double) = this |> endAngleProperty.Set x |> ignore
              
        member this.PointAtAngle(angle:double) =
            let radAngle = angle*Math.PI/180.
            let xRadius = (this.RenderSize.Width - this.StrokeThickness)/2.
            let yRadius = (this.RenderSize.Height - this.StrokeThickness)/2.
            let x = xRadius + xRadius*Math.Cos(radAngle)
            let y = yRadius - yRadius*Math.Sin(radAngle)
            Point(x,y)
            
        override this.DefiningGeometry =
            let startPoint = this.PointAtAngle(Math.Min(this.StartAngle, this.EndAngle))
            let endPoint = this.PointAtAngle(Math.Max(this.StartAngle, this.EndAngle))
            
            let arcSize = Size(Math.Max(0., (this.RenderSize.Width - this.StrokeThickness)/2.),
                               Math.Max(0., (this.RenderSize.Height - this.StrokeThickness)/2.))
                               
            let isLargeArc = Math.Abs(this.EndAngle - this.StartAngle) > 180.
            let geom = StreamGeometry()
            use context = geom.Open()
            context.BeginFigure(startPoint,false,false)
            context.ArcTo(endPoint, arcSize, 0., isLargeArc, SweepDirection.Counterclockwise, true, false)
            geom.Transform <- TranslateTransform(this.StrokeThickness/2., this.StrokeThickness/2.)
            geom :> Geometry
            
        override this.MeasureOverride(availableSize) = base.MeasureOverride(availableSize)
        override this.ArrangeOverride(finalSize) = base.ArrangeOverride(finalSize)
        

            

type ProgressToAngleConverter() =
    interface IMultiValueConverter with
        member this.Convert(values:obj[], targetType, parameter, culture) =
            let progress = values.[0] :?> double
            let progressBar = values.[1] :?> ProgressBar
            359.999*(progress/(progressBar.Maximum - progressBar.Minimum)) :> obj
        member this.ConvertBack(value, targeTypes, parameter, culture) = raise (NotImplementedException())
