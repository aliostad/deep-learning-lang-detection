module Prue

open System
open System.Runtime.InteropServices

[<CompiledName("ToHexDigit")>]
let toHexDigit n = if n < 10 then char (n + 0x30) else char (n + 0x37)

[<CompiledName("FromHexDigit")>]
let fromHexDigit = function
    | c when c >= '0' && c <= '9' -> (int c - int '0')
    | c when c >= 'A' && c <= 'F' -> (int c - int 'A') + 10
    | c when c >= 'a' && c <= 'f' -> (int c - int 'a') + 10
    | _ -> raise <| new ArgumentException()

[<CompiledName("Encode")>]
let encode : byte array -> bool -> string = 
    fun (buf:byte array) (prefix:bool) ->
        Array.zeroCreate (buf.Length * 2) |> fun hex ->
            for i = 0 to buf.Length - 1 do
                hex.[i*2]   <- toHexDigit ((int buf.[i] &&& 0xF0) >>> 4)
                hex.[i*2+1] <- toHexDigit (int buf.[i] &&& 0xF)
            if prefix then String.Concat("0x", new String(hex)) 
            else new String(hex)

[<CompiledName("Decode")>]
let decode : string -> byte array = fun s ->
    match s with
    | null                  -> nullArg "s"
    | _ when s.Length = 0   -> Array.empty
    | _                     ->
        let len, i =
            if s.Length >= 2 
                && s.[0] = '0' && (s.[1] = 'x' || s.[1] = 'X') then
                (s.Length - 2, ref 2)
            else (s.Length, ref 0)
        if len % 2 <> 0 then invalidArg "s" "Invalid hex format"
        else
            let buf = Array.zeroCreate (len / 2)
            let mutable n = 0
            while !i < s.Length do
                buf.[n] <- byte (((fromHexDigit s.[!i]) <<< 4) ||| (fromHexDigit s.[!i + 1]))
                i := !i + 2
                n <- n + 1
            buf

let Crc16 msg =
    let polynomial      = 0xA001us
    let mutable code    = 0xffffus
    for b in msg do
        code <- code ^^^ uint16 b
        for j in [0..7] do
            if (code &&& 1us <> 0us) then
                code <- (code >>> 1) ^^^ polynomial
            else
                code <- code >>> 1
    code

let (<==) dst src               = (src : byte array).CopyTo(dst, 0)
let (<++) src dst p size        = Buffer.BlockCopy(dst,0 ,src ,p ,size)
let (<-+) src dst p size        = Buffer.BlockCopy(dst,p ,src ,0 ,size)
let (<+++) src dst p o size     = Buffer.BlockCopy(dst,o ,src ,p ,size)
let (<++|) device bytes size    =
    let unmanagedPtr = Marshal.AllocHGlobal(size : int)
    Marshal.Copy( (bytes : byte array), 0, unmanagedPtr, size)
    Marshal.PtrToStructure(unmanagedPtr, (device : obj))
    Marshal.FreeHGlobal(unmanagedPtr)

let seconds dt = Convert.ToInt32( (dt - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Local ) ).TotalSeconds ) 
let fromseconds (seconds : float, dtk : DateTimeKind) = (new DateTime(1970, 1, 1, 0, 0, 0 , ( dtk : DateTimeKind ) )).AddSeconds(seconds)
