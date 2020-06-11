module Dialog

open System
open Microsoft.Win32
open KiwiFruit

//
// 開く
//
let ofd = OpenFileDialog()

let fileFilter exts =
  let extNames = 
    toWords exts 
    |> List.map(String.map Char.ToUpper)
    |> String.concat ","

  let exts = 
    toWords exts 
    |> List.map(sprintf "*.%s") 
    |> String.concat ";"

  sprintf "%sファイル(%s)|%s" extNames exts exts


let openFileOf exts handler =
  ofd.Filter <- fileFilter exts
  let result = ofd.ShowDialog()
  if result.HasValue && result.Value then
    handler ofd.FileName
//
// 保存
//
let sfd = SaveFileDialog()

let saveFileOf ext handler =
  sfd.DefaultExt <- sprintf ".%s" ext
  sfd.FileName <- sprintf "%s.%s" ext ext
  sfd.Filter     <- sprintf "%sファイル(*.%s)|*.%s" ext ext ext
  let result = sfd.ShowDialog()
  if result.HasValue && result.Value then
    handler sfd.FileName