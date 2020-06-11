package defsheff

import scalaz.NonEmptyList
import scalaz.Show

package data {

  final case class Card(rank: Rank, suit: Suit)

  object Card {
    implicit val show: Show[Card] = Show.show {
      case Card(r, s) => Show[Rank].show(r) ++ Show[Suit].show(s)
    }
  }

  sealed trait Suit
  final case object Clubs extends Suit
  final case object Diamonds extends Suit
  final case object Hearts extends Suit
  final case object Spades extends Suit

  object Suit {
    implicit val show: Show[Suit] = Show.shows {
      case Clubs    => "♣"
      case Diamonds => "♦"
      case Hearts   => "♥"
      case Spades   => "♠"
    }
  }

  sealed trait Rank
  final case class NC(r: Int) extends Rank { assert ((2 <= r) && (r <= 10)) }
  final case object Jack extends Rank
  final case object Queen extends Rank
  final case object King extends Rank
  final case object Ace extends Rank

  object Rank {
    implicit val show: Show[Rank] = Show.shows {
      case NC(r) => f"$r%2d"
      case Jack  => " J"
      case Queen => " Q"
      case King  => " K"
      case Ace   => " A"
    }
  }
}



/* Type aliases that can't be defined at the top-level */
package object data {
  type Hand = NonEmptyList[Card]
  type Deck = List[Card]
}
