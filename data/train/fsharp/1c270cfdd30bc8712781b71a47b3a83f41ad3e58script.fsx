#light

type Vector2D(dx: float, dy: float) =
    class
        let len = sqrt(dx * dx + dy * dy)
        member v.DX = dx
        member v.DY = dy
        member v.Length = len
    end;;

open System.Drawing

type IShape =
    interface
        abstract Contains : Point -> bool
        abstract BoundingBox : Rectangle
    end;;

[<Struct>]
type Vector2DStruct =
    val dx: float
    val dy: float
    new(dx,dy) = {dx=dx; dy=dy}
    member v.DX = v.dx
    member v.DY = v.dy
    member v.Length = sqrt(v.dx * v.dx + v.dy * v.dy);;

type Vector2DStructUsingKeywords =
    struct
        val dx: float
        val dy: float
    end;;

type ControlEventHandler = delegate of int -> bool;;

open System.Runtime.InteropServices

let ctrlSignal = ref false;;

[<DllImport("kernel32.dll")>]
extern void SetConsoleCtrlHandler(ControlEventHandler callback,bool add);;

let ctrlEventHandler = new ControlEventHandler(fun i -> ctrlSignal := true; true)

SetConsoleCtrlHandler(ctrlEventHandler,true);;

type Vowels =
    | A = 1
    | E = 5
    | I = 9
    | O = 15
    | U = 21;;
