open System
open System.Text

type GapBuffer(content : string) =
    let _buffergap = 5
    let mutable _gapBeginPosition = 0
    let mutable _gapEndPosition = 0
    let mutable _buffer = content.ToCharArray()
    let mutable _buffertwo : char array = Array.zeroCreate 0
//
//    member this.GapLength = (_gapEndPosition - _gapBeginPosition)
//
//    member this.AddGapWhenNoneExists(caret : int, length : int) =
//        let buffertwolength = length + _buffergap + _buffer.Length
//        let newbuffergap = length + _buffergap
//        let newgapendposition = caret + length + _buffergap
//        _buffertwo <- Array.zeroCreate buffertwolength
//        System.Array.Copy(_buffer, 0, _buffertwo, 0, caret)
//        System.Array.Copy(_buffer, caret, _buffertwo, newgapendposition, _buffer.Length-caret)
//        Array.Clear(_buffer,0,_buffer.Length)
//
//        if(_buffer.Length <> buffertwolength) then 
//            _buffer <- Array.zeroCreate buffertwolength
//        _buffer <- Array.copy(_buffertwo)
//
//        _gapEndPosition <- newgapendposition
//        _gapBeginPosition <- caret
//
//    member this.AddGapBeforeExisting(caret : int, length : int) =
//        let newlength = _buffergap + length
//        let newgapEndPosition = caret + newlength
//        let oldlength = this.GapLength
//        let delta = _gapBeginPosition - caret 
//        let newbufferlength = _buffertwo.Length + newlength - oldlength //==> Old buffer array without the gap: Then add the new gap to get the length for the second buffer array
//        do this.GapLength |> printfn "GapLenght %d"
//        do _buffertwo.Length  |> printfn "_buffertwo.Length: = %d"
//        do _gapEndPosition |> printfn "_gapEndPosition: = %d"
//        do _buffertwo.Length - _gapEndPosition |> printfn "_buffertwo.Length - _gapEndPosition: = %d"
//        do newgapEndPosition + delta |> printfn "newgapEndPosition + delta: = %d"
//        _buffertwo <- Array.zeroCreate newbufferlength
//        System.Array.Copy(_buffer, 0,_buffertwo, 0, caret)
//        System.Array.Copy(_buffer, caret, _buffertwo, newgapEndPosition, delta)
//        System.Array.Copy(_buffer, _gapEndPosition, _buffertwo, newgapEndPosition + delta, _buffer.Length - _gapEndPosition)
//        _gapEndPosition <- newgapEndPosition
//        _gapBeginPosition <- caret
//
//    member this.AddGapAfterExisting(caret : int, length : int) =
//            
//    member this.PrintChar() = 
//        do _gapEndPosition |> printfn("New End position %d")
//        for index = 0 to _buffertwo.Length-1 do
//            _buffertwo.[index].ToString() |> printfn("character is : %s");;
//
// let exercisecode = 
//    let doc = new GapBuffer("1234567890")
//    doc.AddGapWhenNoneExists(4,1)
//    doc.PrintChar()
//    doc.AddGapBeforeExisting(2,1)
//    doc.PrintChar();;
//
//
//
//
//
//
//        