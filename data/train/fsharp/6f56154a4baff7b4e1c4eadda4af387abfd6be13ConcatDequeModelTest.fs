module CmdQ.Tests.ConcatDequeModelTest

open CmdQ.FingerTree
open Fuchu
open FsCheck
open FsCheck.Experimental

type TestType = uint16
type ModelType = ResizeArray<TestType>
type SutType = CmdQ.FingerTree.FingerTree<TestType> ref
type OpType = Operation<SutType, ModelType>

module ConcatDeque =
    let sequenceEqual seq tree =
        Seq.zip (ConcatDeque.toSeq tree) seq
        |> Seq.forall (fun ab -> ab ||> (=))

let concatDequeSpec =
    let check sut model op changer delta =
        sut := !sut |> changer delta
        !sut |> ConcatDeque.sequenceEqual model |@ sprintf "%s: %A" op delta

    let prepend what =
        { new OpType() with
            override __.Run model =
                let copy = model |> ResizeArray
                copy.Insert(0, what)
                copy

            override __.Check(sut, model) = check sut model "prepend" ConcatDeque.prepend what

            override __.ToString () = sprintf "prepend %A" what
        }

    let append what =
        { new OpType() with
            override __.Run model =
                let copy = model |> ResizeArray
                copy.Add what
                copy

            override __.Check(sut, model) = check sut model "append" ConcatDeque.append what

            override __.ToString () = sprintf "append %A" what
        }

    let concatRight what =
        { new OpType() with
            override __.Run model =
                let copy = model |> ResizeArray
                copy.AddRange what
                copy

            override __.Check(sut, model) =
                let right = ConcatDeque.ofList what
                sut := ConcatDeque.concat !sut right
                !sut |> ConcatDeque.sequenceEqual model
                |> Prop.trivial (what.Length = 0)

            override __.ToString () = sprintf "concatRight %A" what
        }

    let concatLeft what =
        { new OpType() with
            override __.Run model =
                let copy = model |> ResizeArray
                copy.InsertRange(0, what)
                copy

            override __.Check(sut, model) =
                let left = ConcatDeque.ofList what
                sut := ConcatDeque.concat left !sut
                !sut |> ConcatDeque.sequenceEqual model
                |> Prop.trivial (what.Length = 0)

            override __.ToString () = sprintf "concatLeft %A" what
        }

    let collectAddEnd (f:_ -> #seq<TestType>) what =
        { new OpType() with
            override __.Run model =
                let transformed = what |> Seq.collect f
                let copy = model |> ResizeArray
                copy.AddRange transformed
                copy

            override __.Check(sut, model) =
                let add = what |> ConcatDeque.collect (f >> ConcatDeque.ofSeq)
                sut := ConcatDeque.concat !sut add
                !sut |> ConcatDeque.sequenceEqual model
                |> Prop.trivial (Seq.isEmpty what)

            override __.ToString() = sprintf "collectAddEnd %A" what
        }

    let collectReplace (f:_ -> #seq<TestType>) what =
        { new OpType() with
            override __.Run _ =
                let transformed = what |> Seq.collect f
                ResizeArray(transformed)

            override __.Check(sut, model) =
                sut := what |> ConcatDeque.collect (f >> ConcatDeque.ofSeq)
                !sut |> ConcatDeque.sequenceEqual model
                |> Prop.trivial (Seq.isEmpty what)

            override __.ToString() = sprintf "collectReplace %A" what
        }

    let tail =
        { new OpType() with
            override __.Run model =
                let copy = model |> ResizeArray
                copy.RemoveAt 0
                copy

            override __.Pre model =
                model.Count > 0

            override me.Check (sut, model)=
                sut := !sut |> ConcatDeque.tail
                !sut |> ConcatDeque.sequenceEqual model
                |@ me.ToString()

            override __.ToString () = "tail"
        }

    let spine =
        { new OpType() with
            override __.Run model =
                let copy = model |> ResizeArray
                copy.RemoveAt(copy.Count - 1)
                copy

            override __.Pre model =
                model.Count > 0

            override me.Check (sut, model)=
                sut := !sut |> ConcatDeque.butLast
                !sut |> ConcatDeque.sequenceEqual model
                |@ me.ToString()

            override __.ToString () = "spine"
        }

    let create (initial) =
        { new Setup<SutType, ModelType>() with
            override __.Actual () = ref (ConcatDeque.ofArray initial)

            override __.Model () = initial |> ResizeArray
        }

    let rndNum = Arb.from<TestType> |> Arb.toGen

    { new Machine<SutType, ModelType>() with
        override __.Setup =
            rndNum
            |> Gen.arrayOf
            |> Gen.map create
            |> Arb.fromGen

        override __.Next _ =
            let withElement = gen {
                let! cmd = Gen.elements [append; prepend]
                let! num = rndNum
                return cmd num
            }
            let withList = gen {
                let! cmd = Gen.elements [concatLeft; concatRight]
                let! list = Gen.listOf rndNum
                return cmd list
            }
            let withUnit = gen {
                return! Gen.elements [tail; spine]
            }
            let forCollect = gen {
                let! cmd = Gen.elements [collectAddEnd; collectReplace]
                let! f = Arb.from<TestType -> TestType list> |> Arb.toGen
                let! list = Gen.listOf rndNum
                return cmd f list
            }
            Gen.frequency [3, withUnit; 3, withElement; 2, withList; 1, forCollect]
    }

[<Tests>]
let modelTests =
    [concatDequeSpec]
    |> List.map (StateMachine.toProperty >> testProperty "ConcatDeque")
    |> testList "Model tests"
