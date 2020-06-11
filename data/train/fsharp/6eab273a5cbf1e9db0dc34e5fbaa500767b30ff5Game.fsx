#load "Game.fs"

open Game

let player1 = Player1 (LocalHuman "Adam")
let player2 = Player2 (LocalHuman "Joe")
let player3 = Player3 (LocalHuman "Marcin")

let game = 
    let rnd = System.Random 1
    newGame player1 player2 player3 rnd

let game2 =
    [ player1, Bid 110us
      player2, Bid 120us
      player3, Bid 130us
      player1, Pass
      player2, Bid 140us
      player3, Pass ]
    |> List.map BiddingEvent
    |> List.fold processEvent game

let game3 = processEvent game2 <| PassCardsEvent ({ Suit = Heart; Rank = Ace }, { Suit = Heart; Rank = King })


