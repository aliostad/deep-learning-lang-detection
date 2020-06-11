
namespace TestFSharps

open NUnit.Framework
open FsUnit

type OsObject =
    | File of string // file: name
    | Process of string * int // process: name,priority
    | Unknown

/// recursive definition
/// chekanote: two ways to specify generic types, prefix with "'t" or suffix with <'t>
type 't Stack =
    | EmptyStack
    | StackNode of 't * Stack<'t>

// As of F# 3.1, you can give an individual field a name, but the name is optional, 
// even if other fields in the same case are named.
type Shape = 
    | Rectangle of width: float * length: float
    | Circle of radius: float
    | Prism of width : float * float * height : float

[<TestFixture>]
type TestDiscriminatedUnions() =

    static member MakeOsObject ostype name =
        match ostype with
            | "file" -> File(name)
            | "process" -> Process(name,0)
            | _ -> Unknown

    static member GetName osobject =
        match osobject with
            | File(name) -> name
            | Process(name,priority) -> name
            | Unknown -> System.String.Empty

    [<Test>]
    member this.TestFieldNames() = 
        let rect = Rectangle(length = 1.3, width = 10.0)
        let circ = Circle (1.0)
        let prism = Prism(5., 2.0, height = 3.0)
        ()

    [<Test>]
    member this.TestTypes()=
        File("test.txt").GetType().FullName |> should equal "TestFSharps.OsObject+File" 
        Process("app.exe",1).GetType().FullName |> should equal "TestFSharps.OsObject+Process"
        Unknown.GetType().FullName |> should equal "TestFSharps.OsObject+_Unknown"

    [<Test>]
    member this.TestPolymorphy() =  
        let file = TestDiscriminatedUnions.MakeOsObject "file" "file.txt"
        (TestDiscriminatedUnions.GetName file) |> should equal "file.txt"

        let proc = TestDiscriminatedUnions.MakeOsObject "process" "app.exe"
        (TestDiscriminatedUnions.GetName proc) |> should equal "app.exe"

        let thread = TestDiscriminatedUnions.MakeOsObject "thread" "main"
        (TestDiscriminatedUnions.GetName thread) |> should equal ""

    [<Test>]
    member this.TestDecomposeArgs()=
        let retrieve(Process(name,priority)) = name,priority

        let n,p = Process("app",10) |> retrieve

        n |> should equal "app"
        p |> should equal 10

    [<Test>]
    member this.TestOption()=
        let safe_div (a:int) (b:int) =
            match b with
                | 0 -> None
                | _ -> Some(a/b)

        let some = safe_div 5 2
        some |> Option.isSome |> should be True
        // two way of getting value from Some
        some.Value |> should equal 2
        some |> Option.get |> should equal 2

        let none = safe_div 5 0
        none |> Option.isNone |> should be True
        none |> Option.isSome |> should be False
        (fun()-> none.Value |> ignore) |> should throw typeof<System.NullReferenceException >

    [<Test>]
    member this.GenericSample()=
        let intstack = StackNode(1,StackNode(2,EmptyStack))
        let strstack = StackNode("a",StackNode("b",StackNode("c",EmptyStack)))
        1 |> ignore

    [<Test>]
    member this.TestMatch() =
        let get_description (obj: OsObject)=
            match obj with 
                | File(name) -> sprintf "file<%s>" name
                | Process(name,priority)-> sprintf "process<%s> has priority<%d>" name priority
                | Unknown -> "unknown"

        [Unknown;Process("app.exe",100);File("doc.txt");]
            |> List.map get_description
            |> should equal ["unknown";
                             "process<app.exe> has priority<100>";
                             "file<doc.txt>"]



        

        

