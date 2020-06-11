package com.bryghts.ustring
package show

/**
 * Created by Marc Esquerrà on 01/08/2014.
 */
trait ShowPrimitives
{

    implicit def showUnit    = Show.forType[Unit]
    implicit def showByte    = Show.forType[Byte]
    implicit def showShort   = Show.forType[Short]
    implicit def showInt     = Show.forType[Int]
    implicit def showLong    = Show.forType[Long]
    implicit def showFloat   = Show.forType[Float]
    implicit def showDouble  = Show.forType[Double]
    implicit def showBoolean = Show.forType[Boolean]

}
