package org.goldenport

import java.util.UUID
import org.goldenport.recorder.GRecordable
import org.goldenport.util.{ Dumpable, DumpLoggerable }

/*
 * @since   Jul. 25, 2008
 *  version Feb.  4, 2009
 * @version Nov.  1, 2012
 * @author  ASAMI, Tomoharu
 */
abstract class GObject extends GRecordable with Dumpable with DumpLoggerable {
  val uuid: UUID = UUID.randomUUID()
  private var _name: String = ""

  final def name: String = _name
  final def name_=(aName: String) {
    require (aName != null)
    _name = aName
  }

  /*
   * Debug
   */
  def dumpString(): String = toString
}
