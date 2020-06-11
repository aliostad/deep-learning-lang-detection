
type Student = 
    { Name: string
      Age: int  }

type Color =
    | Red = 0
    | Green = 1
    | Blue = 3

type Error =
    | Timeout of int
    | FileNotFound of string 
    | Unknow 

type ManageResult =
    | Ok
    | Fail of string

let manage x =
    match x with
    | Timeout 10 -> Ok // "Time in 10 second"
    | Timeout second -> Ok //sprintf "Timeout in %A" second
    //| Unknow -> ""
    //| FileNotFound file -> sprintf "%s not found" file
    | _ -> Fail "Unknow"

let processFile() =
    Timeout 10

let rs = processFile()
manage rs

type Student3 =
    { Name: string 
      Color: Color
      Age: float }

type Student2(name, age) =
    member val Name = name with set,get
    member val Age = age with set,get

let std2 = Student2("wk", 20)

let std21 = Student2("20", 20)

let std1 = { Student.Name = "wk"; Age =  20 }

let message x =
    match x with
    | { Student.Name = "wk" ; Age = 10 } -> "This is wk"
    | _ -> "other"

message { Name = "wk"; Age =  20 } |> printfn "%A"
