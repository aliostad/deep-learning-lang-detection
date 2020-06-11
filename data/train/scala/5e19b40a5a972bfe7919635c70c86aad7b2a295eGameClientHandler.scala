package net

import io.netty.channel.{ChannelHandler, ChannelHandlerContext, ChannelInboundHandlerAdapter, SimpleChannelInboundHandler}
import model.actions.Action
import model.engine.{ActionListener, VisibleGameState}
import view.GameStateListener

class GameClientHandler extends SimpleChannelInboundHandler[VisibleGameState] with ActionListener {
  override def channelRead0(ctx: ChannelHandlerContext, msg: VisibleGameState): Unit = {
    System.out.println(msg)
  }

  def registerGameStateListener(gameStateListener: GameStateListener) = {
    // TODO: Manage list of listeners and query on update
  }

  // TODO: Handle receiving/sending actions to server
  override def receiveAction(action: Action): Unit = ???
}
