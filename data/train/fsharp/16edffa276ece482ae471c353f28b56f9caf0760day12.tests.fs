module day12tests

open NUnit.Framework
open day12

[<TestFixture>]
type day12tests () =

    let sampleData = [ "cpy 41 a"
                       "inc a"
                       "inc a"
                       "dec a"
                       "jnz a 2"
                       "dec a" ]

    [<Test>]
    member this.``Register 'a' with value 1 and decrementing it should result in register 'a' having 0`` () =
        let expected = 0
        let result = (Decrement 'a') |> executeInstruction (1,{initRegisters with a=1}) |> snd
        Assert.That(result.a, Is.EqualTo expected)
       

    [<Test>]
    member this.``Parsing and executing the sample data should result in register 'a' having 42`` () =
        let expected = 42
        let result = sampleData |> List.map parseInstruction |> Seq.toArray
                     |> runProgram initRegisters
        Assert.That(result.a, Is.EqualTo expected)

    [<Test>]
    member this.``Parsing instruction 'cpy b a' should result in CopyRegister ('b'','a')`` () =
        let expected = CopyRegister ('b','a')
        let result = parseInstruction "cpy b a" 
        Assert.That(result, Is.EqualTo expected)

    [<Test>]
    member this.``Parsing instruction 'cpy -41 a' should result in CopyValue (-41,'a')`` () =
        let expected = CopyValue (-41,'a')
        let result = parseInstruction "cpy -41 a" 
        Assert.That(result, Is.EqualTo expected)

    [<Test>]
    member this.``Parsing instruction 'cpy 41 a' should result in CopyValue (41,'a')`` () =
        let expected = CopyValue (41,'a')
        let result = parseInstruction "cpy 41 a" 
        Assert.That(result, Is.EqualTo expected)
