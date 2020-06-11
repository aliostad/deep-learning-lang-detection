package com.manofj.commons.minecraftforge.network.io.conversions

import io.netty.buffer.ByteBufOutputStream

import com.manofj.commons.scala.util.conversions.Extension

import com.manofj.commons.minecraftforge.network.io.ByteBufWriteFunction


/** $output のインスタンスに対して､ユーティリティメソッドを使用可能にする
  *
  * @define p      `self`
  * @define output [[io.netty.buffer.ByteBufOutputStream]]
  */
trait ByteBufOutputStreamExtension
  extends Any
  with    Extension[ ByteBufOutputStream ]
{

  /** $p にオブジェクトを書き込む
    */
  def write[ A ]( obj: A )( implicit function: ByteBufWriteFunction[ A ] ): Unit = function( self, obj )

  /** $p にバイト配列を書き込む
    */
  def writeBinary( binary: Array[ Byte ] ): Unit = {
    self.writeInt( binary.length )
    self.write( binary )
  }

  /** $p にオブジェクトのコレクションを書き込む
    */
  def writeCollection[ A ]( collection: Iterable[ A ] )
                          ( implicit function: ByteBufWriteFunction[ A ] ): Unit =
  {
    self.writeInt( collection.size )
    collection.foreach( function( self, _ ) )
  }

  /** $p にオプショナルオブジェクトを書き込む
    */
  def writeOption[ A ]( option: Option[ A ] )
                      ( implicit function: ByteBufWriteFunction[ A ] ): Unit =
  {
    self.writeBoolean( option.isDefined )
    option.foreach( function( self, _ ) )
  }

}
