module Crypto

open System.Text
open System.Security.Cryptography

let private iterCount = 8000
let private subKeyLength = 32
let private saltSize = 32
let private blockCopy src srcOffset dst dstOffset count = System.Buffer.BlockCopy(src, srcOffset, dst, dstOffset, count)

let hashPassword password =
    use deriveBytes = new Rfc2898DeriveBytes(password, saltSize, iterCount)
    let salt = deriveBytes.Salt
    let subkey = deriveBytes.GetBytes subKeyLength
    subkey, salt

let getSubkey (password:string) (salt:byte[]) =
    let password = Encoding.UTF8.GetBytes password
    use deriveBytes = new Rfc2898DeriveBytes(password, salt, iterCount)
    deriveBytes.GetBytes subKeyLength