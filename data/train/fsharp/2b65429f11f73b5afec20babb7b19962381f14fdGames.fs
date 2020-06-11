module TwentyFortyEightTests.Games

open TwentyFortyEight
open Helpers
open NUnit.Framework
open FsUnit

[<TestFixture>]
type GameTests() =
    [<Test>]
    member test.HasReached() =
        let board = [| 
                        [| n; n; n; n; |]; 
                        [| n; s 512; n; n; |]; 
                        [| n; n; s 2048; n; |]; 
                        [| n; n; n; n; |]; 
                        |]

        board
            |> toBoard
            |> hasReached 2048
            |> should equal true


        let board = [| 
                        [| n; n; n; n; |]; 
                        [| n; s 512; n; n; |]; 
                        [| n; n; s 1024; n; |]; 
                        [| n; n; n; n; |]; 
                        |]

        board
            |> toBoard
            |> hasReached 2048
            |> should equal false


    [<Test>]
    member test.HasNoMoves() =
        let board = [| 
                        [| s 32; s 128; s 512; s 32; |]; 
                        [| s 8; s 16; s 8; s 2; |]; 
                        [| s 4; s 8; s 2; s 4; |]; 
                        [| s 2; s 16; s 4; s 2; |]; 
                        |]

        board
            |> toBoard
            |> hasNoMoves
            |> should equal true

        let b = Array2D.copy (toBoard board)
        Array2D.set b 2 1 n
        b
            |> hasNoMoves
            |> should equal false
            
        let b = Array2D.copy (toBoard board)
        Array2D.set b 3 0 (s 16)
        b
            |> hasNoMoves
            |> should equal false