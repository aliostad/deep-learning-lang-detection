open System    

module native = 
  open System.Runtime.InteropServices

  [<DllImport @"boyer_moore.dll">]
  extern nativeint boyerMoore(
    nativeint data, 
    nativeint search, 
    int       datalen, 
    int       searchlen)

  let vrfy n = if n <= 0n then failwith "null ptr" else n

  let copy_s (p : byte array) =
    let ptr = Marshal.AllocHGlobal p.Length |> vrfy in
      Marshal.Copy(p,0,ptr,p.Length)
    ptr
  
  (* semantic return pointer to array *)  
  let inline (~~) (data : byte array)  = copy_s data 
  let inline (!~) (n : nativeint)      = Marshal.FreeHGlobal n

  (* cant get rid of this unless we free inside the native interface (bad idea)  *)
  let search data search =
    let pData,pSearch = ~~data, ~~search
    let result = boyerMoore(pData,pSearch,data.Length,search.Length)
    !~pData;!~pSearch
    result
    
let f1 = IO.File.ReadAllBytes @"C:\users\dklein\desktop\librhash.dll"

let sbox = [|
   27uy; 0uy; 249uy; 100uy; 246uy; 205uy; 221uy; 254uy; 226uy; 241uy; 143uy;
   124uy; 20uy; 21uy; 215uy; 17uy; 211uy; 24uy; 140uy; 139uy; 30uy; 136uy;
   223uy; 221uy|]

match native.search f1 sbox with
  | x when x > 0n -> sprintf "[s-box detected] snefru hash function at 0x%x" x
  | _             -> ""
