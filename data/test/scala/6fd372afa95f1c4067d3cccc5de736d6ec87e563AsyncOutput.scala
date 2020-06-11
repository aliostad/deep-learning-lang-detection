package net.reduls.aio

import scala.util.continuations.shift
import scala.actors.Actor.actor
import java.io.OutputStream

trait AsyncOutput extends OutputStream {
  def asyncWrite(byte:Int) = {
    shift {ctx: (Unit => Unit) =>
      actor{
        write(byte)
        ctx()
      }:Unit
    }   
  }

  def asyncWrite(bytes:Array[Byte]) = {
    shift {ctx: (Unit => Unit) =>
      actor{
        write(bytes)
        ctx()
      }:Unit
    }   
  }

  def asyncWrite(bytes:Array[Byte], offset:Int, length:Int) = {
    shift {ctx: (Unit => Unit) =>
      actor{
        write(bytes, offset, length)
        ctx()
      }:Unit
    }   
  }
}
