module TwentyFortyEightTests.Moves

open TwentyFortyEight
open Helpers
open NUnit.Framework
open FsUnit

[<TestFixture>]
type MovementTests() =

    let testMove board direction expected expectedPoints shouldMove r =
        let (moved, newBoard, points) = move direction board r
        newBoard |> should equal expected
        points |> should equal expectedPoints
        moved |> should equal shouldMove

    [<Test>]
    member test.``Move & Get New Tile``() =
        let r = new System.Random(2048)
        let board = [| 
                        [| n; s 2; n; n; |]; 
                        [| n; n; n; n; |]; 
                        [| n; n; n; n; |]; 
                        [| n; n; n; n; |]; 
                        |]
                       |> toBoard

        testMove board Direction.Up board 0 false r

        let board = [| 
                        [| n; n; n; n; |]; 
                        [| n; s 2; n; n; |]; 
                        [| n; n; n; n; |]; 
                        [| n; n; n; n; |]; 
                        |]
                       |> toBoard

        let expected = Array2D.copy board
        Array2D.set expected 0 1 (s 2)
        Array2D.set expected 1 1 n
        Array2D.set expected 2 2 (s 2)
        testMove board Direction.Up expected 0 true r

        let board = [| 
                        [| n; n; n; n; |]; 
                        [| n; s 1024; n; n; |]; 
                        [| n; s 1024; n; n; |]; 
                        [| n; n; s 512; n; |]; 
                        |]
                       |> toBoard

        let expected = Array2D.copy board
        Array2D.set expected 1 1 n
        Array2D.set expected 2 1 n
        Array2D.set expected 3 1 (s 2048)
        Array2D.set expected 1 0 (s 2)
        testMove board Direction.Down expected 2048 true r