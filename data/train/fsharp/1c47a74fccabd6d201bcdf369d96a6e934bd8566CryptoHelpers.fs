namespace Fooble.Core

open Fooble.Common
open System
open System.Security.Cryptography

[<RequireQualifiedAccess>]
module internal Crypto =

    let private subkeyLength = 32
    let private saltLength = 16

    let private saltOffset = 1
    let private subkeyOffset = saltOffset + saltLength
    let private itersOffset = subkeyOffset + subkeyLength
    let private partsLength = itersOffset + sizeof<int>

    let private blockCopy src srcOffset dstOffset count dst =
        Buffer.BlockCopy(src, srcOffset, dst, dstOffset, count)
        dst

    let hash password iterations =
#if DEBUG
        assertWith (validateRequired password "password" "Password")
        assertOn iterations "iterations" [ ((<=) 1), "Iterations is less than one" ]
#endif

        let salt, bytes =
            new Rfc2898DeriveBytes(password, saltLength, iterations)
            |> fun x -> x.Salt, x.GetBytes(subkeyLength)

        let iters =
            BitConverter.GetBytes(iterations)
            |> if BitConverter.IsLittleEndian then id else Array.rev

        Array.zeroCreate<byte> partsLength
        |> fun xs -> xs.[0] <- 0uy; xs // set version of this hashing algorithm
        |> blockCopy salt 0 saltOffset saltLength
        |> blockCopy bytes 0 subkeyOffset subkeyLength
        |> blockCopy iters 0 itersOffset sizeof<int>
        |> Convert.ToBase64String

    let verify hashedPassword (password:string) =
#if DEBUG
        assertWith (validateRequired hashedPassword "hashedPassword" "Hashed password")
        assertWith (validateRequired password "password" "Password")
#endif

        let parts = Convert.FromBase64String(hashedPassword)

        match parts with
        | x when x.Length <> partsLength -> false
        | x when x.[0] <> 0uy -> false
        | _ ->

        let salt =
            Array.zeroCreate<byte> saltLength
            |> blockCopy parts saltOffset 0 saltLength

        let bytes =
            Array.zeroCreate<byte> subkeyLength
            |> blockCopy parts subkeyOffset 0 subkeyLength

        let iterations =
            Array.zeroCreate<byte> sizeof<int>
            |> blockCopy parts itersOffset 0 sizeof<int>
            |> if BitConverter.IsLittleEndian then id else Array.rev
            |> fun xs -> BitConverter.ToInt32(xs, 0)

        new Rfc2898DeriveBytes(password, salt, iterations)
        |> fun x -> x.GetBytes(32)
        |> Array.forall2 (=) bytes

    let version hashedPassword =
#if DEBUG
        assertWith (validateRequired hashedPassword "hashedPassword" "Hashed password")
#endif
        Convert.FromBase64String(hashedPassword).[0]
