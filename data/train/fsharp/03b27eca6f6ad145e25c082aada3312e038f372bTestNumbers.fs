#light

namespace TestFSharps

open System

open NUnit.Framework
open FsUnit

[<TestFixture>]
type TestNumbers() =

    [<Test>] 
    member this.TestTypes() =
        let shortNumber = -1s
        shortNumber.GetType() |> should equal typeof<Int16>
        
        let ushortNumber = 1us
        ushortNumber.GetType() |> should equal typeof<UInt16>

        let intNumber = -1
        let intType = intNumber.GetType()
        // you can use both "exact name of type" or "type abbreviation"
        intType |> should equal typeof<Int32> 
        intType |> should equal typeof<int>

        let uintNumber = 99u
        uintNumber.GetType() |> should equal typeof<UInt32>

        // in F#, both "double" and "float" are actually, "Double"
        let doubleNumber = 3.1415
        let doubleType = doubleNumber.GetType()
        doubleType |> should equal typeof<Double>
        doubleType |> should equal typeof<double>
        doubleType |> should equal typeof<float>

        let doubleNumber : float = 3.1415925
        doubleNumber.GetType() |> should equal typeof<Double>

        let singleNumber = 3.1415f
        let singleType = singleNumber.GetType()
        singleType |> should equal typeof<Single>
        singleType |> should equal typeof<single>
        singleType |> should equal typeof<float32>

    [<Test>]
    member this.TestSizeof()=
        sizeof<int> |> should equal 4
        sizeof<float32> |> should equal 4
        sizeof<double> |> should equal 8
        sizeof<float> |> should equal 8

    (*
    F# don't have automatic upward casting
    several ways to convert from one type to another
    both 'single' and 'float32' are for Single type, you can use () or not
    both 'float' and 'double' are for Double type, you can use () or not 
    *)
    [<Test>]
    member this.TestConversion() =
        let shortNumber = 1

        let float32Number1 = float32 shortNumber
        let float32Number2 = single shortNumber
        let float32Number3 = single(shortNumber)

        float32Number3.GetType() |> should equal typeof<Single>
        float32Number3 |> should equal 1.0f

        // ---------------- float to int
        (int 3.6) |> should equal 3
        (int 3.4) |> should equal 3

        (int -3.6) |> should equal -3
        (int -3.4) |> should equal -3

    [<Test>]
    member this.TestReferenceFeature() =
        let x = 1
        let y = x
        y |> should equal 1
        y |> should not' (be sameAs x)

        let mutable a = 100
        let b = a
        b |> should not' (be sameAs a)
        b |> should equal 100

    // chekanote: the difference between ValueType and ReferenceType still works here
    // a copy is made when referencing one symbol to another, when that symbol is ValueType
    [<Test>]
    member this.TestCopyWhenReference() = 
        let x = 1
        let y = x
        y |> should not' (be sameAs x)
        y |> should equal x

        let x = 3
        y |> should equal 1
        y |> should not' (equal x)

    [<Test>]
    member this.TestMutable() = 
        let mutable x = 1
        x |> should equal 1

        // when an "immutable" reference to "mutable", it will make a copy
        let y = x
        y |> should not' (be sameAs x)

        x <- 2
        x |> should equal 2
        y |> should equal 1

    // chekanote: when referencing an mutable, whether the reference is mutable or not, a copy will always be made
    [<Test>]
    member this.TestReferenceMutable() =
        // ------------------------------ before modification
        let mutable original = 1
        let immutableCopy = original
        let mutable mutableCopy = original

        immutableCopy |> should equal 1
        immutableCopy |> should not' (be sameAs original)

        mutableCopy |> should equal 1
        mutableCopy |> should not' (be sameAs original)

        // ------------------------------ after modification
        original <- 100

        // chekanote: only change itself, there will be no other reference to be changed, 
        // because when referencing at first, they are actually making copies
        original |> should equal 100
        immutableCopy |> should equal 1
        mutableCopy |> should equal 1

    // note: for division, both sides must be double or not, cannot be hybrid
    [<Test>]
    member this.TestDivision() =
        let x = 100.0
        let y = 3.0
        x/y |> should (equalWithin 1e-3) 33.333333333333333

        let x = int x
        let y = int y
        (x/y) |> should equal 33

    [<Test>]
    member this.TestIntDivision()=
        // it is the commmon feature of .NET that
        // "/" will return integers when used against two integers
        // from MSDN: "When you divide two integers, the result is always an integer. For example, the result of 7 / 3 is 2"
        // C# is integer division, F# is also integer division
        10/3 |> should equal 3

    [<Test>]
    member this.TestPower()=
        // if using Pow (**), both operators must be float
        // int cannot be accepted here
        // (5 ** 3) |> should equal 125
        let result = 5.0 ** 3.0
        result |> should (equalWithin 1e-3) 125.0

    [<Test>]
    member this.TestCompare() =
        let a = 1
        let b = a
        let c = b + 1

        (a = b) |> should be True
        (a <> b) |> should be False
        (a = c) |> should be False

        (compare 1 3) |> should equal -1 

    [<Test>]
    member this.TestBooleans()=
        let t = true
        let f = false

        (t && f) |> should be False
        (t || f) |> should be True

    [<Test>]
    member this.TestStrConversion() = 
        let s = string 111
        s |> should equal "111"

        // two ways to parse number from string, one is using "Parse" or "TryParse"
        let n = Int32.Parse(s)
        n |> should equal 111

        // the other is using "type s" directly 
        // (actually 'type' there is also a function defined in Operator module)
        (int s) |> should equal 111

    [<Test>]
    member this.TestBoxing()=
        // -------------------- type annotation at left side
        let boxed : obj = box 100
        let unboxed : int = unbox boxed
        unboxed |> should equal 100

        // -------------------- type annotation at right side
        let boxfloat = box 3.1415926

        // chekanote: but the problem is: when hovering on "unboxobj", it still shows its type as "obj"
        let unboxobj = unbox boxfloat
        unboxobj.GetType() |> should equal typeof<float>
        
        let unboxfloat1 = unbox<float> boxfloat
        unboxfloat1.GetType() |> should equal typeof<float>

        let unboxfloat2 = unbox boxfloat : float// here specifies the return type to be "float"
        unboxfloat2.GetType() |> should equal typeof<float>

        // -------------------- exception
        (fun()-> 
                let impossible: float = unbox boxed
                ()) |> should throw typeof<System.InvalidCastException>

    [<Test>]
    member this.TestBuiltinOperators()=
        abs(-101) |> should equal 101
        (4.0 ** 3.0) |> should equal 64.0
       






