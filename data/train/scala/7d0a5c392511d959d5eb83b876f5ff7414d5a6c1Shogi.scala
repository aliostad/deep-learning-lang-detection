package jp.sndyuk.shogi.ui

import jp.sndyuk.shogi.core._
import scala.annotation.tailrec
import scala.util.Try
import jp.sndyuk.shogi.player.AIPlayer
import jp.sndyuk.shogi.player.Player

trait Shogi {

  def board: Board
  def playerA: Player
  def playerB: Player

  def beforeMove(player: Player): Unit
  def afterMove(player: Player, oldPos: Point, newPos: Point): Unit
  // Validationの結果がfalseの場合に呼ばれる
  def failToMove(player: Player, oldPos: Point, newPos: Point): Unit
  def done(player: Player, oldPos: Point, newPos: Point, winner: Player): Unit
  def onError(e: Exception): Unit

  @tailrec private def readWhile(state: State): Unit = {
    val player = if (state.turn == PlayerA) playerA else playerB
    beforeMove(player)
    Thread.`yield`
    val Transition(oldPos, newPos, nari, _) = player.next(board, state)
    val newState = board.moveOpt(state, oldPos, newPos, player.needValidation, nari)

    newState match {
      case Some(s) => {
        afterMove(player, oldPos, newPos)
        if (board.isFinish(state.turn)) {
          done(player, oldPos, newPos, player)
        } else {
          readWhile(s)
        }
      }
      case None => {
        failToMove(player, oldPos, newPos)
        readWhile(state)
      }
    }
  }

  def start(): Unit = {
    while (true) {
      Try(readWhile(State(Nil, PlayerA))).recover {
        case e: Exception => {
          onError(e)
        }
      }
    }
  }
}