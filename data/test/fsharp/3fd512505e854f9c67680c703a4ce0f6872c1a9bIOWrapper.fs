module DevRT.IOWrapper

open System.IO

let createDirectory = Directory.CreateDirectory >> ignore

let getFiles p () = p |> Directory.GetFiles

let getDirectories p () = p |> Directory.GetDirectories

let enumerateFiles = Directory.EnumerateFiles

let enumerateDirectories = Directory.EnumerateDirectories

let exists = Directory.Exists
let fileExists = File.Exists

let deleteRecursive target = Directory.Delete(target, true)

let combine x y = Path.Combine(x, y)

let copyFile x y = File.Copy(x, y)

let createPath dest = Path.GetFileName >> combine dest

let readAllLines path = File.ReadAllLines path

let writeAllLines path lines = File.WriteAllLines(path, lines)
