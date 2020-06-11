module FsRaster.Utils

open System
open System.Collections

open System.Windows.Controls
open System.Windows.Media

let first f (a, b) = (f a, b)
let second f (a, b) = (a, f b)
let curry f a b = f (a, b)
let uncurry f (a, b) = f a b

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
[<RequireQualifiedAccess>]
module ConsIList =
    type ConsIList<'a> =
        | ConsList of Generic.IList<'a> * int

    let ofList list = ConsList (list, 0)
    let isEmpty (ConsList (list, idx)) = list.Count = idx
    let nextElement (ConsList (list, idx)) = (list.[idx], ConsList(list, idx + 1))

let (|ListNil|ListCons|) lst = if ConsIList.isEmpty lst then ListNil else ListCons (ConsIList.nextElement lst)

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
[<RequireQualifiedAccess>]
module ConsArray =
    type ConsArray<'a> =
        | ConsArray of 'a array * int

    let ofArray arr = ConsArray (arr, 0)
    let isEmpty (ConsArray (arr, idx)) = arr.Length = idx
    let nextElement (ConsArray (arr, idx)) = (arr.[idx], ConsArray (arr, idx + 1))

let (|ArrayNil|ArrayCons|) arr = if ConsArray.isEmpty arr then ArrayNil else ArrayCons (ConsArray.nextElement arr)

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
[<RequireQualifiedAccess>]
module UIColors =
    type UIColor = { Color : Color; Name : string }
    let allColors =
        typeof<Colors>.GetProperties()
        |> Array.map (fun p -> { Color = p.GetValue(null) :?> Color; Name = p.Name })

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
[<RequireQualifiedAccess>]
module List =
    let rec butLast = function
        | []     -> []
        | [a]    -> []
        | a :: r -> a :: butLast r

    let takeWhileState f s lst =
        let rec takeWhileState' f s lst acc =
            match lst with
            | x :: xs ->
                let s', r = f s x
                if r then takeWhileState' f s' xs (x :: acc) else (s, acc)
            | [] -> (s, acc)
        takeWhileState' f s lst []

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
[<RequireQualifiedAccess>]
module Array =
    let takeWhileState f s (lst: 'T array) =
        let rec findIndex currIdx s =
          if currIdx = lst.Length then (s, currIdx)
          else
            let s', acc = f s lst.[currIdx]
            if acc then findIndex (currIdx + 1) s' else (s, currIdx)
        let s, lastIndex = findIndex 0 s
        s, Array.sub lst 0 lastIndex

    // Based on https://github.com/mykohsu/Extensions/blob/master/ArrayExtensions.cs
    let fastFill (arr : 'a array) (value : 'a) =
        arr.[0] <- value
        let mutable copyLength = 1
        let mutable nextCopyLength = copyLength <<< 1
        while nextCopyLength < arr.Length do
            Array.Copy(arr, 0, arr, copyLength, copyLength)
            copyLength <- nextCopyLength
            nextCopyLength <- copyLength <<< 1
        Array.Copy(arr, 0, arr, copyLength, arr.Length - copyLength)

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
[<RequireQualifiedAccess>]
module Option =
    let opt def o = Option.fold (fun _ -> id) def o
    let optFunc def = function
    | Some o -> o
    | None   -> def ()
    let withOpt f def o = Option.fold (fun _ s -> f s) def o
    let fromSome = function | Some o -> o | _ -> failwith "Invalid argumen - None passed"

#nowarn "9"
module Native =
    open System.Runtime.InteropServices
    open Microsoft.FSharp.NativeInterop

    [<DllImport("kernel32.dll", EntryPoint = "CopyMemory")>]
    extern void CopyMemoryNative(void *dest, void *src, UIntPtr size);

    [<DllImport("msvcrt.dll", EntryPoint = "memset", CallingConvention = CallingConvention.Cdecl)>]
    extern void *memsetNative(void *dest, int c, UIntPtr count);

    let inline copyMemory (src : 'a nativeptr) srcOffset (dst : 'a nativeptr) dstOffset (length : int) =
        let src' = NativePtr.toNativeInt (NativePtr.add src srcOffset)
        let dst' = NativePtr.toNativeInt (NativePtr.add dst dstOffset)
        CopyMemoryNative(dst', src', UIntPtr(uint32 (length * 4)))

    let inline memset (dst : 'a nativeptr) (c : int) (count : int) =
        let dst' = NativePtr.toNativeInt dst
        let count' = count * sizeof<'a>
        memsetNative(dst', c, UIntPtr(uint32 count')) |> ignore
