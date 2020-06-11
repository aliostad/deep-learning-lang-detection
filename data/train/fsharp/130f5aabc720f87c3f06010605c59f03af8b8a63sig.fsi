

module CentralServer
val private initKey : string
val private readCredentials :
  dataStream:System.IO.Stream -> (string * string) option
val private credentialsFromResponse :
  log:(string -> unit) ->
    resp:System.Net.HttpWebResponse -> (string * string) option
val private writeArray :
  byteArray:byte [] -> dataStream:System.IO.Stream -> unit
type WebRequest with
  member WriteContent : postData:string -> unit
type WebRequest with
  member GetHttpResponseAsync : unit -> Async<System.Net.HttpWebResponse>
val private requestTo : url:string -> System.Net.HttpWebRequest
val private getServer :
  content:string -> log:(string -> unit) -> Async<(string * string) option>
val GetFfaServer : ((string -> unit) -> Async<(string * string) option>)
val GetExperimentalServer :
  ((string -> unit) -> Async<(string * string) option>)
val GetTeamsServer : ((string -> unit) -> Async<(string * string) option>)
val BeginConnecting :
  server:string * key:string -> log:(string -> unit) -> WebSocketSharp.WebSocket

module Commands
type Command =
  | Spawn of string
  | Spectate
  | Split
  | Eject
  | MoveTo of double * double
val CommandsSink : webSocket:WebSocketSharp.WebSocket -> _arg1:Command -> unit

module Events
type BallId = uint32
type Eating =
  {Eater: BallId;
   Eaten: BallId;}
type BallData =
  {Id: BallId;
   Pos: System.Windows.Point;
   Size: int16;
   Color: System.Windows.Media.Color;
   IsVirus: bool;}
type BallUpdate = BallData * string
type ServerEvent =
  | UpdateBalls of Eating [] * BallUpdate [] * BallId []
  | UpdateCamera of float32 * float32 * float32
  | NewId of BallId
  | UpdateViewPort of System.Windows.Rect
  | UpdateLeaders of (uint32 * string) []
  | Unknown of byte
  | DestroyAllBalls
  | DestroyLessStuff
  | SetSomeVariables
  | TeamUpdate
  | NoIdea
  | ExperienceUpdate
  | Forward
  | LogOut
  | GameOver
type BinaryReader with
  member ReadUnicodeString : unit -> string
type BinaryReader with
  member ReadAsciiString : unit -> string
val private seek : reader:System.IO.BinaryReader -> pos:uint32 -> unit
val private readEatings : reader:System.IO.BinaryReader -> Eating []
val private readOptions : reader:System.IO.BinaryReader -> bool
val private readPoint : reader:System.IO.BinaryReader -> System.Windows.Point
val private readColor :
  reader:System.IO.BinaryReader -> System.Windows.Media.Color
val private ballData :
  reader:System.IO.BinaryReader -> ballId:BallId -> BallData
val private ballUpdate :
  reader:System.IO.BinaryReader -> ballId:BallId -> BallData * string
val private readUpdates :
  reader:System.IO.BinaryReader -> (BallData * string) []
val private readDisappearances : reader:System.IO.BinaryReader -> uint32 []
val private readTick :
  reader:System.IO.BinaryReader ->
    Eating [] * (BallData * string) [] * uint32 []
val private readCamera :
  reader:System.IO.BinaryReader -> float32 * float32 * float32
val private readLeaders : reader:System.IO.BinaryReader -> (uint32 * string) []
val private readViewPort : reader:System.IO.BinaryReader -> System.Windows.Rect
val private readMessage : reader:System.IO.BinaryReader -> ServerEvent
val private readMessageFromBuffer : buffer:byte [] -> ServerEvent
val EventsFeed :
  webSocket:WebSocketSharp.WebSocket ->
    record:(byte [] -> unit) -> (unit -> Async<ServerEvent>)

module GameModel
type Ball =
  {IsMine: bool;
   Data: Events.BallData;
   Name: string;}
  with
    member Color : System.Windows.Media.Color
    member Id : Events.BallId
    member IsFood : bool
    member IsVirus : bool
    member Pos : System.Windows.Point
    member Size : int16
  end
type MetaBall =
  | Real of Ball
  | Header of bool
type IBalls =
  interface
    abstract member All : seq<Ball>
    abstract member My : seq<Ball>
  end
type GameEvent =
  | Appears of Ball
  | Eats of Ball * Ball
  | Removes of Ball
  | AfterTick of IBalls
  | ViewPort of System.Windows.Rect
  | Leaders of string []
  | Error of string
type GameState =
  class
    interface IBalls
    new : unit -> GameState
    member CreateMe : id:Events.BallId -> unit
    member DestroyAll : unit -> seq<GameEvent>
    member
      Update : eatings:Events.Eating [] * updates:Events.BallUpdate [] *
               deletes:Events.BallId [] -> seq<GameEvent>
    member All : System.Collections.Generic.Dictionary<uint32,MetaBall>
  end
val dispatch : gameState:GameState -> _arg1:Events.ServerEvent -> seq<GameEvent>

module Ui
type Color with
  member GetDarker : unit -> System.Windows.Media.Color
type Color with
  member IsDark : unit -> bool
type FrameworkElement with
  member CenterOnCanvas : v:System.Windows.Vector -> unit
type FrameworkElement with
  member PlaceOnCanvas : r:System.Windows.Rect -> unit
type BallUi =
  class
    new : unit -> BallUi
    member Hide : unit -> unit
    member Show : unit -> unit
    member Update : ball:GameModel.Ball * zIndex:int * mySize:float -> unit
    member Ellipse : System.Windows.Shapes.Ellipse
    member TextBlock : System.Windows.Controls.TextBlock
  end

module GameControl
type Control =
  class
    inherit FsXaml.XamlContainer
    new : unit -> Control + 1 overload
    member Accessor : FsXaml.XamlFileAccessor
    member ActualHeight : float
    member ActualWidth : float
    member AllowDrop : bool with get, set
    member AncestorChangeInProgress : bool with get, set
    member Animatable_IsResourceInvalidationNecessary : bool with get, set
    member AreAnyTouchesCaptured : bool
    member AreAnyTouchesCapturedWithin : bool
    member AreAnyTouchesDirectlyOver : bool
    member AreAnyTouchesOver : bool
    member AreTransformsClean : bool with get, set
    member ArrangeDirty : bool with get, set
    member ArrangeInProgress : bool with get, set
    val ArrangeRequest : System.Windows.ContextLayoutManager.LayoutQueue.Request
    member Back : System.Windows.Shapes.Rectangle
    member Background : System.Windows.Media.Brush with get, set
    member BindingGroup : System.Windows.Data.BindingGroup with get, set
    member BitmapEffect : System.Windows.Media.Effects.BitmapEffect with get, set
    member BitmapEffectEmulationDisabled : bool with get, set
    member BitmapEffectInput : System.Windows.Media.Effects.BitmapEffectInput with get, set
    member BorderBrush : System.Windows.Media.Brush with get, set
    member BorderThickness : System.Windows.Thickness with get, set
    member BypassLayoutPolicies : bool with get, set
    member CacheMode : System.Windows.Media.CacheMode with get, set
    member CacheModeChangedHandler : System.EventHandler
    member CanBeInheritanceContext : bool with get, set
    member Clip : System.Windows.Media.Geometry with get, set
    member ClipChangedHandler : System.EventHandler
    member ClipToBounds : bool with get, set
    member ClipToBoundsCache : bool with get, set
    member CommandBindings : System.Windows.Input.CommandBindingCollection
    member CommandBindingsInternal : System.Windows.Input.CommandBindingCollection
    member Content : obj with get, set
    member ContentIsItem : bool with get, set
    member ContentIsNotLogical : bool with get, set
    member ContentStringFormat : string with get, set
    member ContentTemplate : System.Windows.DataTemplate with get, set
    member ContentTemplateSelector : System.Windows.Controls.DataTemplateSelector with get, set
    member ContentsChangedHandler : System.EventHandler
    member ContextMenu : System.Windows.Controls.ContextMenu with get, set
    event ContextMenuClosing : System.Windows.Controls.ContextMenuEventHandler
    event ContextMenuOpening : System.Windows.Controls.ContextMenuEventHandler
    member Cursor : System.Windows.Input.Cursor with get, set
    member DTypeThemeStyleKey : System.Windows.DependencyObjectType
    member DataContext : obj with get, set
    event DataContextChanged : System.Windows.DependencyPropertyChangedEventHandler
    member DefaultStyleKey : obj with get, set
    member DependencyObjectType : System.Windows.DependencyObjectType
    member DesiredSize : System.Windows.Size
    member Dispatcher : System.Windows.Threading.Dispatcher
    event DragEnter : System.Windows.DragEventHandler
    event DragLeave : System.Windows.DragEventHandler
    event DragOver : System.Windows.DragEventHandler
    event Drop : System.Windows.DragEventHandler
    member Effect : System.Windows.Media.Effects.Effect with get, set
    member EffectChangedHandler : System.EventHandler
    member EffectiveValues : System.Windows.EffectiveValueEntry []
    member EffectiveValuesCount : uint32 with get, set
    member EffectiveValuesInitialSize : int
    member EventHandlersStore : System.Windows.EventHandlersStore
    member FlowDirection : System.Windows.FlowDirection with get, set
    member FocusVisualStyle : System.Windows.Style with get, set
    member Focusable : bool with get, set
    event FocusableChanged : System.Windows.DependencyPropertyChangedEventHandler
    member FontFamily : System.Windows.Media.FontFamily with get, set
    member FontSize : float with get, set
    member FontStretch : System.Windows.FontStretch with get, set
    member FontStyle : System.Windows.FontStyle with get, set
    member FontWeight : System.Windows.FontWeight with get, set
    member ForceCursor : bool with get, set
    member Foreground : System.Windows.Media.Brush with get, set
    member Freezable_Frozen : bool with get, set
    member Freezable_HasMultipleInheritanceContexts : bool with get, set
    member Freezable_UsingContextList : bool with get, set
    member Freezable_UsingHandlerList : bool with get, set
    member Freezable_UsingSingletonContext : bool with get, set
    member Freezable_UsingSingletonHandler : bool with get, set
    event GiveFeedback : System.Windows.GiveFeedbackEventHandler
    event GotFocus : System.Windows.RoutedEventHandler
    event GotKeyboardFocus : System.Windows.Input.KeyboardFocusChangedEventHandler
    event GotMouseCapture : System.Windows.Input.MouseEventHandler
    event GotStylusCapture : System.Windows.Input.StylusEventHandler
    event GotTouchCapture : System.EventHandler<System.Windows.Input.TouchEventArgs>
    member GuidelinesChangedHandler : System.EventHandler
    member HandlesScrolling : bool
    member HasAnimatedProperties : bool
    member HasAutomationPeer : bool with get, set
    member HasContent : bool
    member HasEffectiveKeyboardFocus : bool
    member HasFefLoadedChangeHandler : bool
    member HasImplicitStyleFromResources : bool with get, set
    member HasLocalStyle : bool with get, set
    member HasLogicalChildren : bool with get, set
    member HasMultipleInheritanceContexts : bool
    member HasNumberSubstitutionChanged : bool with get, set
    member HasResourceReference : bool with get, set
    member HasResources : bool
    member HasStyleChanged : bool with get, set
    member HasStyleEverBeenFetched : bool with get, set
    member HasStyleInvalidated : bool with get, set
    member HasTemplateChanged : bool with get, set
    member HasTemplateGeneratedSubTree : bool with get, set
    member HasThemeStyleEverBeenFetched : bool with get, set
    member HasVisualChildren : bool
    member Height : float with get, set
    member HorizontalAlignment : System.Windows.HorizontalAlignment with get, set
    member HorizontalContentAlignment : System.Windows.HorizontalAlignment with get, set
    member IAnimatable_HasAnimatedProperties : bool with get, set
    member InVisibilityCollapsedTree : bool with get, set
    member InheritableEffectiveValuesCount : uint32 with get, set
    member InheritableProperties : MS.Utility.FrugalObjectList<System.Windows.DependencyProperty> with get, set
    member InheritanceBehavior : System.Windows.InheritanceBehavior with get, set
    member InheritanceContext : System.Windows.DependencyObject
    event InheritanceContextChanged : System.EventHandler
    member InheritanceParent : System.Windows.DependencyObject
    event InheritedPropertyChanged : MS.Internal.InheritedPropertyChangedEventHandler
    event Initialized : System.EventHandler
    member InputBindings : System.Windows.Input.InputBindingCollection
    member InputBindingsInternal : System.Windows.Input.InputBindingCollection
    member InputScope : System.Windows.Input.InputScope with get, set
    member InternalVisual2DOr3DChildrenCount : int
    member InternalVisualChildrenCount : int
    member InternalVisualParent : System.Windows.DependencyObject
    member IsArrangeValid : bool
    member IsEnabled : bool with get, set
    event IsEnabledChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsEnabledCore : bool
    member IsFocused : bool
    member IsHitTestVisible : bool with get, set
    event IsHitTestVisibleChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsInheritanceContextSealed : bool with get, set
    member IsInitialized : bool
    member IsInputMethodEnabled : bool
    member IsKeyboardFocusWithin : bool
    event IsKeyboardFocusWithinChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsKeyboardFocused : bool
    event IsKeyboardFocusedChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsLoaded : bool
    member IsLoadedCache : bool with get, set
    member IsLogicalChildrenIterationInProgress : bool with get, set
    member IsManipulationEnabled : bool with get, set
    member IsMeasureValid : bool
    member IsMouseCaptureWithin : bool
    event IsMouseCaptureWithinChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsMouseCaptured : bool
    event IsMouseCapturedChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsMouseDirectlyOver : bool
    event IsMouseDirectlyOverChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsMouseOver : bool
    member IsParentAnFE : bool with get, set
    member IsRequestingExpression : bool with get, set
    member IsRightToLeft : bool with get, set
    member IsRootElement : bool with get, set
    member IsSealed : bool
    member IsSelfInheritanceParent : bool
    member IsStyleSetFromGenerator : bool with get, set
    member IsStyleUpdateInProgress : bool with get, set
    member IsStylusCaptureWithin : bool
    event IsStylusCaptureWithinChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsStylusCaptured : bool
    event IsStylusCapturedChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsStylusDirectlyOver : bool
    event IsStylusDirectlyOverChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsStylusOver : bool
    member IsTabStop : bool with get, set
    member IsTemplateRoot : bool
    member IsTemplatedParentAnFE : bool with get, set
    member IsThemeStyleUpdateInProgress : bool with get, set
    member IsVisible : bool
    event IsVisibleChanged : System.Windows.DependencyPropertyChangedEventHandler
    member IsVisualChildrenIterationInProgress : bool with get, set
    event KeyDown : System.Windows.Input.KeyEventHandler
    event KeyUp : System.Windows.Input.KeyEventHandler
    member Language : System.Windows.Markup.XmlLanguage with get, set
    member LayoutTransform : System.Windows.Media.Transform with get, set
    event LayoutUpdated : System.EventHandler
    member Leadersboard : System.Windows.Controls.ItemsControl
    event Loaded : System.Windows.RoutedEventHandler
    member LoadedPending : obj []
    member LogicalChildren : System.Collections.IEnumerator
    event LostFocus : System.Windows.RoutedEventHandler
    event LostKeyboardFocus : System.Windows.Input.KeyboardFocusChangedEventHandler
    event LostMouseCapture : System.Windows.Input.MouseEventHandler
    event LostStylusCapture : System.Windows.Input.StylusEventHandler
    event LostTouchCapture : System.EventHandler<System.Windows.Input.TouchEventArgs>
    member MainCanvas : System.Windows.Controls.Canvas
    event ManipulationBoundaryFeedback : System.EventHandler<System.Windows.Input.ManipulationBoundaryFeedbackEventArgs>
    event ManipulationCompleted : System.EventHandler<System.Windows.Input.ManipulationCompletedEventArgs>
    event ManipulationDelta : System.EventHandler<System.Windows.Input.ManipulationDeltaEventArgs>
    event ManipulationInertiaStarting : System.EventHandler<System.Windows.Input.ManipulationInertiaStartingEventArgs>
    event ManipulationStarted : System.EventHandler<System.Windows.Input.ManipulationStartedEventArgs>
    event ManipulationStarting : System.EventHandler<System.Windows.Input.ManipulationStartingEventArgs>
    member Margin : System.Windows.Thickness with get, set
    member MaxHeight : float with get, set
    member MaxWidth : float with get, set
    member MeasureDirty : bool with get, set
    member MeasureDuringArrange : bool with get, set
    member MeasureInProgress : bool with get, set
    val MeasureRequest : System.Windows.ContextLayoutManager.LayoutQueue.Request
    member MinHeight : float with get, set
    member MinWidth : float with get, set
    event MouseDoubleClick : System.Windows.Input.MouseButtonEventHandler
    event MouseDown : System.Windows.Input.MouseButtonEventHandler
    event MouseEnter : System.Windows.Input.MouseEventHandler
    event MouseLeave : System.Windows.Input.MouseEventHandler
    event MouseLeftButtonDown : System.Windows.Input.MouseButtonEventHandler
    event MouseLeftButtonUp : System.Windows.Input.MouseButtonEventHandler
    event MouseMove : System.Windows.Input.MouseEventHandler
    event MouseRightButtonDown : System.Windows.Input.MouseButtonEventHandler
    event MouseRightButtonUp : System.Windows.Input.MouseButtonEventHandler
    event MouseUp : System.Windows.Input.MouseButtonEventHandler
    event MouseWheel : System.Windows.Input.MouseWheelEventHandler
    member Name : string with get, set
    member NeverArranged : bool with get, set
    member NeverMeasured : bool with get, set
    member Opacity : float with get, set
    member OpacityMask : System.Windows.Media.Brush with get, set
    member OpacityMaskChangedHandler : System.EventHandler
    member OverridesDefaultStyle : bool with get, set
    member Padding : System.Windows.Thickness with get, set
    member Parent : System.Windows.DependencyObject
    member PersistId : int
    member PotentiallyHasMentees : bool with get, set
    event PreviewDragEnter : System.Windows.DragEventHandler
    event PreviewDragLeave : System.Windows.DragEventHandler
    event PreviewDragOver : System.Windows.DragEventHandler
    event PreviewDrop : System.Windows.DragEventHandler
    event PreviewGiveFeedback : System.Windows.GiveFeedbackEventHandler
    event PreviewGotKeyboardFocus : System.Windows.Input.KeyboardFocusChangedEventHandler
    event PreviewKeyDown : System.Windows.Input.KeyEventHandler
    event PreviewKeyUp : System.Windows.Input.KeyEventHandler
    event PreviewLostKeyboardFocus : System.Windows.Input.KeyboardFocusChangedEventHandler
    event PreviewMouseDoubleClick : System.Windows.Input.MouseButtonEventHandler
    event PreviewMouseDown : System.Windows.Input.MouseButtonEventHandler
    event PreviewMouseLeftButtonDown : System.Windows.Input.MouseButtonEventHandler
    event PreviewMouseLeftButtonUp : System.Windows.Input.MouseButtonEventHandler
    event PreviewMouseMove : System.Windows.Input.MouseEventHandler
    event PreviewMouseRightButtonDown : System.Windows.Input.MouseButtonEventHandler
    event PreviewMouseRightButtonUp : System.Windows.Input.MouseButtonEventHandler
    event PreviewMouseUp : System.Windows.Input.MouseButtonEventHandler
    event PreviewMouseWheel : System.Windows.Input.MouseWheelEventHandler
    event PreviewQueryContinueDrag : System.Windows.QueryContinueDragEventHandler
    event PreviewStylusButtonDown : System.Windows.Input.StylusButtonEventHandler
    event PreviewStylusButtonUp : System.Windows.Input.StylusButtonEventHandler
    event PreviewStylusDown : System.Windows.Input.StylusDownEventHandler
    event PreviewStylusInAirMove : System.Windows.Input.StylusEventHandler
    event PreviewStylusInRange : System.Windows.Input.StylusEventHandler
    event PreviewStylusMove : System.Windows.Input.StylusEventHandler
    event PreviewStylusOutOfRange : System.Windows.Input.StylusEventHandler
    event PreviewStylusSystemGesture : System.Windows.Input.StylusSystemGestureEventHandler
    event PreviewStylusUp : System.Windows.Input.StylusEventHandler
    event PreviewTextInput : System.Windows.Input.TextCompositionEventHandler
    event PreviewTouchDown : System.EventHandler<System.Windows.Input.TouchEventArgs>
    event PreviewTouchMove : System.EventHandler<System.Windows.Input.TouchEventArgs>
    event PreviewTouchUp : System.EventHandler<System.Windows.Input.TouchEventArgs>
    member PreviousArrangeRect : System.Windows.Rect
    member PreviousConstraint : System.Windows.Size
    event QueryContinueDrag : System.Windows.QueryContinueDragEventHandler
    event QueryCursor : System.Windows.Input.QueryCursorEventHandler
    member RenderSize : System.Windows.Size with get, set
    member RenderTransform : System.Windows.Media.Transform with get, set
    member RenderTransformOrigin : System.Windows.Point with get, set
    event RequestBringIntoView : System.Windows.RequestBringIntoViewEventHandler
    member Resources : System.Windows.ResourceDictionary with get, set
    event ResourcesChanged : System.EventHandler
    member Root : System.Windows.FrameworkElement
    member ScaleTransform : obj
    member ScrollableAreaClipChangedHandler : System.EventHandler
    member ShouldLookupImplicitStyles : bool with get, set
    event SizeChanged : System.Windows.SizeChangedEventHandler
    member SnapsToDevicePixels : bool with get, set
    member SnapsToDevicePixelsCache : bool with get, set
    event SourceUpdated : System.EventHandler<System.Windows.Data.DataTransferEventArgs>
    member StateGroupsRoot : System.Windows.FrameworkElement
    member StoresParentTemplateValues : bool with get, set
    member Style : System.Windows.Style with get, set
    event StylusButtonDown : System.Windows.Input.StylusButtonEventHandler
    event StylusButtonUp : System.Windows.Input.StylusButtonEventHandler
    event StylusDown : System.Windows.Input.StylusDownEventHandler
    event StylusEnter : System.Windows.Input.StylusEventHandler
    event StylusInAirMove : System.Windows.Input.StylusEventHandler
    event StylusInRange : System.Windows.Input.StylusEventHandler
    event StylusLeave : System.Windows.Input.StylusEventHandler
    event StylusMove : System.Windows.Input.StylusEventHandler
    event StylusOutOfRange : System.Windows.Input.StylusEventHandler
    member StylusPlugIns : System.Windows.Input.StylusPlugIns.StylusPlugInCollection
    event StylusSystemGesture : System.Windows.Input.StylusSystemGestureEventHandler
    event StylusUp : System.Windows.Input.StylusEventHandler
    member SubtreeHasLoadedChangeHandler : bool with get, set
    member ``System.Windows.Markup.IHaveResources.Resources`` : System.Windows.ResourceDictionary with get, set
    member TabIndex : int with get, set
    member Tag : obj with get, set
    event TargetUpdated : System.EventHandler<System.Windows.Data.DataTransferEventArgs>
    member Template : System.Windows.Controls.ControlTemplate with get, set
    member TemplateCache : System.Windows.FrameworkTemplate with get, set
    member TemplateChild : System.Windows.UIElement with get, set
    member TemplateChildIndex : int with get, set
    member TemplateInternal : System.Windows.FrameworkTemplate
    member TemplatedParent : System.Windows.DependencyObject
    event TextInput : System.Windows.Input.TextCompositionEventHandler
    member ThemeStyle : System.Windows.Style
    member ThisHasLoadedChangeEventHandler : bool
    member ToolTip : obj with get, set
    event ToolTipClosing : System.Windows.Controls.ToolTipEventHandler
    event ToolTipOpening : System.Windows.Controls.ToolTipEventHandler
    event TouchDown : System.EventHandler<System.Windows.Input.TouchEventArgs>
    event TouchEnter : System.EventHandler<System.Windows.Input.TouchEventArgs>
    event TouchLeave : System.EventHandler<System.Windows.Input.TouchEventArgs>
    event TouchMove : System.EventHandler<System.Windows.Input.TouchEventArgs>
    event TouchUp : System.EventHandler<System.Windows.Input.TouchEventArgs>
    member TouchesCaptured : System.Collections.Generic.IEnumerable<System.Windows.Input.TouchDevice>
    member TouchesCapturedWithin : System.Collections.Generic.IEnumerable<System.Windows.Input.TouchDevice>
    member TouchesDirectlyOver : System.Collections.Generic.IEnumerable<System.Windows.Input.TouchDevice>
    member TouchesOver : System.Collections.Generic.IEnumerable<System.Windows.Input.TouchDevice>
    member TransformChangedHandler : System.EventHandler
    member TranslateTransform : obj
    member TreeLevel : uint32 with get, set
    member Triggers : System.Windows.TriggerCollection
    member Uid : string with get, set
    event Unloaded : System.Windows.RoutedEventHandler
    member UnloadedPending : obj []
    member UseLayoutRounding : bool with get, set
    member VerticalAlignment : System.Windows.VerticalAlignment with get, set
    member VerticalContentAlignment : System.Windows.VerticalAlignment with get, set
    member ViewPort : System.Windows.Shapes.Rectangle
    member Visibility : System.Windows.Visibility with get, set
    event VisualAncestorChanged : System.Windows.Media.Visual.AncestorChangedEventHandler
    member VisualBitmapEffect : System.Windows.Media.Effects.BitmapEffect with get, set
    member VisualBitmapEffectInput : System.Windows.Media.Effects.BitmapEffectInput with get, set
    member VisualBitmapEffectInputInternal : System.Windows.Media.Effects.BitmapEffectInput with get, set
    member VisualBitmapEffectInternal : System.Windows.Media.Effects.BitmapEffect with get, set
    member VisualBitmapScalingMode : System.Windows.Media.BitmapScalingMode with get, set
    member VisualCacheMode : System.Windows.Media.CacheMode with get, set
    member VisualChildrenCount : int
    member VisualClearTypeHint : System.Windows.Media.ClearTypeHint with get, set
    member VisualClip : System.Windows.Media.Geometry with get, set
    member VisualContentBounds : System.Windows.Rect
    member VisualDescendantBounds : System.Windows.Rect
    member VisualEdgeMode : System.Windows.Media.EdgeMode with get, set
    member VisualEffect : System.Windows.Media.Effects.Effect with get, set
    member VisualEffectInternal : System.Windows.Media.Effects.Effect with get, set
    member VisualOffset : System.Windows.Vector with get, set
    member VisualOpacity : float with get, set
    member VisualOpacityMask : System.Windows.Media.Brush with get, set
    member VisualParent : System.Windows.DependencyObject
    member VisualScrollableAreaClip : System.Nullable<System.Windows.Rect> with get, set
    member VisualStateChangeSuspended : bool with get, set
    member VisualTextHintingMode : System.Windows.Media.TextHintingMode with get, set
    member VisualTextRenderingMode : System.Windows.Media.TextRenderingMode with get, set
    member VisualTransform : System.Windows.Media.Transform with get, set
    member VisualXSnappingGuidelines : System.Windows.Media.DoubleCollection with get, set
    member VisualYSnappingGuidelines : System.Windows.Media.DoubleCollection with get, set
    member Width : float with get, set
    member WorldBoundaries : System.Windows.Shapes.Rectangle
    val _contextStorage : obj
    val _controlBoolField : System.Windows.Controls.Control.ControlBoolFlags
    val _parent : System.Windows.DependencyObject
    val _parentIndex : int
    val _proxy : System.Windows.Media.Composition.VisualProxy
    val _templatedParent : System.Windows.DependencyObject
    val sizeChangedInfo : System.Windows.SizeChangedInfo
    static val ActualHeightProperty : System.Windows.DependencyProperty
    static val ActualWidthProperty : System.Windows.DependencyProperty
    static val AllowDropProperty : System.Windows.DependencyProperty
    static val AreAnyTouchesCapturedProperty : System.Windows.DependencyProperty
    static val AreAnyTouchesCapturedPropertyKey : System.Windows.DependencyPropertyKey
    static val AreAnyTouchesCapturedWithinProperty : System.Windows.DependencyProperty
    static val AreAnyTouchesCapturedWithinPropertyKey : System.Windows.DependencyPropertyKey
    static val AreAnyTouchesDirectlyOverProperty : System.Windows.DependencyProperty
    static val AreAnyTouchesDirectlyOverPropertyKey : System.Windows.DependencyPropertyKey
    static val AreAnyTouchesOverProperty : System.Windows.DependencyProperty
    static val AreAnyTouchesOverPropertyKey : System.Windows.DependencyPropertyKey
    static val BackgroundProperty : System.Windows.DependencyProperty
    static val BindingGroupProperty : System.Windows.DependencyProperty
    static val BitmapEffectInputProperty : System.Windows.DependencyProperty
    static val BitmapEffectProperty : System.Windows.DependencyProperty
    static val BitmapEffectStateField : System.Windows.UncommonField<System.Windows.Media.Effects.BitmapEffectState>
    static val BorderBrushProperty : System.Windows.DependencyProperty
    static val BorderThicknessProperty : System.Windows.DependencyProperty
    static val CacheModeProperty : System.Windows.DependencyProperty
    static val ClipProperty : System.Windows.DependencyProperty
    static val ClipToBoundsProperty : System.Windows.DependencyProperty
    static val CommandBindingCollectionField : System.Windows.UncommonField<System.Windows.Input.CommandBindingCollection>
    static val ContentProperty : System.Windows.DependencyProperty
    static val ContentStringFormatProperty : System.Windows.DependencyProperty
    static val ContentTemplateProperty : System.Windows.DependencyProperty
    static val ContentTemplateSelectorProperty : System.Windows.DependencyProperty
    static val ContextMenuClosingEvent : System.Windows.RoutedEvent
    static val ContextMenuOpeningEvent : System.Windows.RoutedEvent
    static val ContextMenuProperty : System.Windows.DependencyProperty
    static val CursorProperty : System.Windows.DependencyProperty
    static val DType : System.Windows.DependencyObjectType
    static val DType : System.Windows.DependencyObjectType
    static val DataContextChangedKey : System.Windows.EventPrivateKey
    static val DataContextProperty : System.Windows.DependencyProperty
    static member DefaultFocusVisualStyle : System.Windows.Style
    static val DefaultNumberSubstitution : System.Windows.Media.NumberSubstitution
    static val DefaultStyleKeyProperty : System.Windows.DependencyProperty
    static val DependentListMapField : System.Windows.UncommonField<obj>
    static val DirectDependencyProperty : System.Windows.DependencyProperty
    static member DpiScaleX : float
    static member DpiScaleY : float
    static val DragEnterEvent : System.Windows.RoutedEvent
    static val DragLeaveEvent : System.Windows.RoutedEvent
    static val DragOverEvent : System.Windows.RoutedEvent
    static val DropEvent : System.Windows.RoutedEvent
    static val EffectProperty : System.Windows.DependencyProperty
    static val EventHandlersStoreField : System.Windows.UncommonField<System.Windows.EventHandlersStore>
    static val ExpressionInAlternativeStore : obj
    static val FlowDirectionProperty : System.Windows.DependencyProperty
    static val FocusVisualStyleProperty : System.Windows.DependencyProperty
    static val FocusWithinProperty : System.Windows.FocusWithinProperty
    static val FocusableChangedKey : System.Windows.EventPrivateKey
    static val FocusableProperty : System.Windows.DependencyProperty
    static val FontFamilyProperty : System.Windows.DependencyProperty
    static val FontSizeProperty : System.Windows.DependencyProperty
    static val FontStretchProperty : System.Windows.DependencyProperty
    static val FontStyleProperty : System.Windows.DependencyProperty
    static val FontWeightProperty : System.Windows.DependencyProperty
    static val ForceCursorProperty : System.Windows.DependencyProperty
    static val ForegroundProperty : System.Windows.DependencyProperty
    static val GiveFeedbackEvent : System.Windows.RoutedEvent
    static val GotFocusEvent : System.Windows.RoutedEvent
    static val GotKeyboardFocusEvent : System.Windows.RoutedEvent
    static val GotMouseCaptureEvent : System.Windows.RoutedEvent
    static val GotStylusCaptureEvent : System.Windows.RoutedEvent
    static val GotTouchCaptureEvent : System.Windows.RoutedEvent
    static val HasContentProperty : System.Windows.DependencyProperty
    static val HeightProperty : System.Windows.DependencyProperty
    static val HorizontalAlignmentProperty : System.Windows.DependencyProperty
    static val HorizontalContentAlignmentProperty : System.Windows.DependencyProperty
    static val InheritedPropertyChangedKey : System.Windows.EventPrivateKey
    static val InitializedKey : System.Windows.EventPrivateKey
    static val InputBindingCollectionField : System.Windows.UncommonField<System.Windows.Input.InputBindingCollection>
    static val InputScopeProperty : System.Windows.DependencyProperty
    static val IsEnabledChangedKey : System.Windows.EventPrivateKey
    static val IsEnabledProperty : System.Windows.DependencyProperty
    static val IsFocusedProperty : System.Windows.DependencyProperty
    static val IsFocusedPropertyKey : System.Windows.DependencyPropertyKey
    static val IsHitTestVisibleChangedKey : System.Windows.EventPrivateKey
    static val IsHitTestVisibleProperty : System.Windows.DependencyProperty
    static val IsKeyboardFocusWithinChangedKey : System.Windows.EventPrivateKey
    static val IsKeyboardFocusWithinProperty : System.Windows.DependencyProperty
    static val IsKeyboardFocusWithinPropertyKey : System.Windows.DependencyPropertyKey
    static val IsKeyboardFocusedChangedKey : System.Windows.EventPrivateKey
    static val IsKeyboardFocusedProperty : System.Windows.DependencyProperty
    static val IsKeyboardFocusedPropertyKey : System.Windows.DependencyPropertyKey
    static val IsManipulationEnabledProperty : System.Windows.DependencyProperty
    static val IsMouseCaptureWithinChangedKey : System.Windows.EventPrivateKey
    static val IsMouseCaptureWithinProperty : System.Windows.DependencyProperty
    static val IsMouseCaptureWithinPropertyKey : System.Windows.DependencyPropertyKey
    static val IsMouseCapturedChangedKey : System.Windows.EventPrivateKey
    static val IsMouseCapturedProperty : System.Windows.DependencyProperty
    static val IsMouseCapturedPropertyKey : System.Windows.DependencyPropertyKey
    static val IsMouseDirectlyOverChangedKey : System.Windows.EventPrivateKey
    static val IsMouseDirectlyOverProperty : System.Windows.DependencyProperty
    static val IsMouseDirectlyOverPropertyKey : System.Windows.DependencyPropertyKey
    static val IsMouseOverProperty : System.Windows.DependencyProperty
    static val IsMouseOverPropertyKey : System.Windows.DependencyPropertyKey
    static val IsStylusCaptureWithinChangedKey : System.Windows.EventPrivateKey
    static val IsStylusCaptureWithinProperty : System.Windows.DependencyProperty
    static val IsStylusCaptureWithinPropertyKey : System.Windows.DependencyPropertyKey
    static val IsStylusCapturedChangedKey : System.Windows.EventPrivateKey
    static val IsStylusCapturedProperty : System.Windows.DependencyProperty
    static val IsStylusCapturedPropertyKey : System.Windows.DependencyPropertyKey
    static val IsStylusDirectlyOverChangedKey : System.Windows.EventPrivateKey
    static val IsStylusDirectlyOverProperty : System.Windows.DependencyProperty
    static val IsStylusDirectlyOverPropertyKey : System.Windows.DependencyPropertyKey
    static val IsStylusOverProperty : System.Windows.DependencyProperty
    static val IsStylusOverPropertyKey : System.Windows.DependencyPropertyKey
    static val IsTabStopProperty : System.Windows.DependencyProperty
    static val IsVisibleChangedKey : System.Windows.EventPrivateKey
    static val IsVisibleProperty : System.Windows.DependencyProperty
    static val IsVisiblePropertyKey : System.Windows.DependencyPropertyKey
    static val KeyDownEvent : System.Windows.RoutedEvent
    static val KeyUpEvent : System.Windows.RoutedEvent
    static member KeyboardNavigation : System.Windows.Input.KeyboardNavigation
    static val LanguageProperty : System.Windows.DependencyProperty
    static val LayoutTransformProperty : System.Windows.DependencyProperty
    static val LoadedEvent : System.Windows.RoutedEvent
    static val LoadedPendingProperty : System.Windows.DependencyProperty
    static val LoadedPendingPropertyKey : System.Windows.DependencyPropertyKey
    static val LostFocusEvent : System.Windows.RoutedEvent
    static val LostKeyboardFocusEvent : System.Windows.RoutedEvent
    static val LostMouseCaptureEvent : System.Windows.RoutedEvent
    static val LostStylusCaptureEvent : System.Windows.RoutedEvent
    static val LostTouchCaptureEvent : System.Windows.RoutedEvent
    static val MAX_ELEMENTS_IN_ROUTE : int
    static val ManipulationBoundaryFeedbackEvent : System.Windows.RoutedEvent
    static val ManipulationCompletedEvent : System.Windows.RoutedEvent
    static val ManipulationDeltaEvent : System.Windows.RoutedEvent
    static val ManipulationInertiaStartingEvent : System.Windows.RoutedEvent
    static val ManipulationStartedEvent : System.Windows.RoutedEvent
    static val ManipulationStartingEvent : System.Windows.RoutedEvent
    static val MarginProperty : System.Windows.DependencyProperty
    static val MaxHeightProperty : System.Windows.DependencyProperty
    static val MaxWidthProperty : System.Windows.DependencyProperty
    static val MinHeightProperty : System.Windows.DependencyProperty
    static val MinWidthProperty : System.Windows.DependencyProperty
    static val MouseCaptureWithinProperty : System.Windows.MouseCaptureWithinProperty
    static val MouseDoubleClickEvent : System.Windows.RoutedEvent
    static val MouseDownEvent : System.Windows.RoutedEvent
    static val MouseEnterEvent : System.Windows.RoutedEvent
    static val MouseLeaveEvent : System.Windows.RoutedEvent
    static val MouseLeftButtonDownEvent : System.Windows.RoutedEvent
    static val MouseLeftButtonUpEvent : System.Windows.RoutedEvent
    static val MouseMoveEvent : System.Windows.RoutedEvent
    static val MouseOverProperty : System.Windows.MouseOverProperty
    static val MouseRightButtonDownEvent : System.Windows.RoutedEvent
    static val MouseRightButtonUpEvent : System.Windows.RoutedEvent
    static val MouseUpEvent : System.Windows.RoutedEvent
    static val MouseWheelEvent : System.Windows.RoutedEvent
    static val NameProperty : System.Windows.DependencyProperty
    static val OpacityMaskProperty : System.Windows.DependencyProperty
    static val OpacityProperty : System.Windows.DependencyProperty
    static val OverridesDefaultStyleProperty : System.Windows.DependencyProperty
    static val PaddingProperty : System.Windows.DependencyProperty
    static member PopupControlService : System.Windows.Controls.PopupControlService
    static val PreviewDragEnterEvent : System.Windows.RoutedEvent
    static val PreviewDragLeaveEvent : System.Windows.RoutedEvent
    static val PreviewDragOverEvent : System.Windows.RoutedEvent
    static val PreviewDropEvent : System.Windows.RoutedEvent
    static val PreviewGiveFeedbackEvent : System.Windows.RoutedEvent
    static val PreviewGotKeyboardFocusEvent : System.Windows.RoutedEvent
    static val PreviewKeyDownEvent : System.Windows.RoutedEvent
    static val PreviewKeyUpEvent : System.Windows.RoutedEvent
    static val PreviewLostKeyboardFocusEvent : System.Windows.RoutedEvent
    static val PreviewMouseDoubleClickEvent : System.Windows.RoutedEvent
    static val PreviewMouseDownEvent : System.Windows.RoutedEvent
    static val PreviewMouseLeftButtonDownEvent : System.Windows.RoutedEvent
    static val PreviewMouseLeftButtonUpEvent : System.Windows.RoutedEvent
    static val PreviewMouseMoveEvent : System.Windows.RoutedEvent
    static val PreviewMouseRightButtonDownEvent : System.Windows.RoutedEvent
    static val PreviewMouseRightButtonUpEvent : System.Windows.RoutedEvent
    static val PreviewMouseUpEvent : System.Windows.RoutedEvent
    static val PreviewMouseWheelEvent : System.Windows.RoutedEvent
    static val PreviewQueryContinueDragEvent : System.Windows.RoutedEvent
    static val PreviewStylusButtonDownEvent : System.Windows.RoutedEvent
    static val PreviewStylusButtonUpEvent : System.Windows.RoutedEvent
    static val PreviewStylusDownEvent : System.Windows.RoutedEvent
    static val PreviewStylusInAirMoveEvent : System.Windows.RoutedEvent
    static val PreviewStylusInRangeEvent : System.Windows.RoutedEvent
    static val PreviewStylusMoveEvent : System.Windows.RoutedEvent
    static val PreviewStylusOutOfRangeEvent : System.Windows.RoutedEvent
    static val PreviewStylusSystemGestureEvent : System.Windows.RoutedEvent
    static val PreviewStylusUpEvent : System.Windows.RoutedEvent
    static val PreviewTextInputEvent : System.Windows.RoutedEvent
    static val PreviewTouchDownEvent : System.Windows.RoutedEvent
    static val PreviewTouchMoveEvent : System.Windows.RoutedEvent
    static val PreviewTouchUpEvent : System.Windows.RoutedEvent
    static val QueryContinueDragEvent : System.Windows.RoutedEvent
    static val QueryCursorEvent : System.Windows.RoutedEvent
    static val RenderTransformOriginProperty : System.Windows.DependencyProperty
    static val RenderTransformProperty : System.Windows.DependencyProperty
    static val RequestBringIntoViewEvent : System.Windows.RoutedEvent
    static val ResourcesChangedKey : System.Windows.EventPrivateKey
    static val ResourcesField : System.Windows.UncommonField<System.Windows.ResourceDictionary>
    static val SizeChangedEvent : System.Windows.RoutedEvent
    static val SnapsToDevicePixelsProperty : System.Windows.DependencyProperty
    static val StyleProperty : System.Windows.DependencyProperty
    static val StylusButtonDownEvent : System.Windows.RoutedEvent
    static val StylusButtonUpEvent : System.Windows.RoutedEvent
    static val StylusCaptureWithinProperty : System.Windows.StylusCaptureWithinProperty
    static val StylusDownEvent : System.Windows.RoutedEvent
    static val StylusEnterEvent : System.Windows.RoutedEvent
    static val StylusInAirMoveEvent : System.Windows.RoutedEvent
    static val StylusInRangeEvent : System.Windows.RoutedEvent
    static val StylusLeaveEvent : System.Windows.RoutedEvent
    static val StylusMoveEvent : System.Windows.RoutedEvent
    static val StylusOutOfRangeEvent : System.Windows.RoutedEvent
    static val StylusOverProperty : System.Windows.StylusOverProperty
    static val StylusSystemGestureEvent : System.Windows.RoutedEvent
    static val StylusUpEvent : System.Windows.RoutedEvent
    static val TabIndexProperty : System.Windows.DependencyProperty
    static val TagProperty : System.Windows.DependencyProperty
    static val TemplateProperty : System.Windows.DependencyProperty
    static val TextInputEvent : System.Windows.RoutedEvent
    static val ToolTipClosingEvent : System.Windows.RoutedEvent
    static val ToolTipOpeningEvent : System.Windows.RoutedEvent
    static val ToolTipProperty : System.Windows.DependencyProperty
    static val TouchDownEvent : System.Windows.RoutedEvent
    static val TouchEnterEvent : System.Windows.RoutedEvent
    static val TouchLeaveEvent : System.Windows.RoutedEvent
    static val TouchMoveEvent : System.Windows.RoutedEvent
    static val TouchUpEvent : System.Windows.RoutedEvent
    static val TouchesCapturedWithinProperty : System.Windows.Input.TouchesCapturedWithinProperty
    static val TouchesOverProperty : System.Windows.Input.TouchesOverProperty
    static val UIElementDType : System.Windows.DependencyObjectType
    static val UidProperty : System.Windows.DependencyProperty
    static val UnloadedEvent : System.Windows.RoutedEvent
    static val UnloadedPendingProperty : System.Windows.DependencyProperty
    static val UnloadedPendingPropertyKey : System.Windows.DependencyPropertyKey
    static val UseLayoutRoundingProperty : System.Windows.DependencyProperty
    static val VerticalAlignmentProperty : System.Windows.DependencyProperty
    static val VerticalContentAlignmentProperty : System.Windows.DependencyProperty
    static val VisibilityProperty : System.Windows.DependencyProperty
    static val WidthProperty : System.Windows.DependencyProperty
  end
type IBalls with
  member MyAverage : unit -> System.Windows.Point
type IBalls with
  member Zoom : unit -> float
type IBalls with
  member Zoom04 : unit -> float
val create :
  nextEvent:(unit -> Async<GameModel.GameEvent>) ->
    sendCommand:(Commands.Command -> unit) -> log:'a -> Async<unit>

module MainApp
type MainWindow =
  class
    inherit FsXaml.XamlTypeFactory<System.Windows.Window>
    new : unit -> MainWindow + 1 overload
    member Accessor : FsXaml.XamlFileAccessor
    member ErrorLabel : System.Windows.Controls.TextBlock
    member GameControlPlace : System.Windows.Controls.ContentControl
    member Root : System.Windows.Window
  end
val window : MainWindow
val app : System.Windows.Application
[<System.STAThread ()>]
val main : string [] -> int

