/*
 *  TimelineModelImpl.scala
 *  (AudioWidgets)
 *
 *  Copyright (c) 2011-2016 Hanns Holger Rutz. All rights reserved.
 *
 *	This software is published under the GNU Lesser General Public License v2.1+
 *
 *
 *	For further information, please contact Hanns Holger Rutz at
 *	contact@sciss.de
 */

package de.sciss.audiowidgets
package impl

import de.sciss.model.impl.ModelImpl
import de.sciss.span.Span
import de.sciss.span.Span.SpanOrVoid
import de.sciss.model.Change

final class TimelineModelImpl(bounds0: Span, val sampleRate: Double)
  extends TimelineModel.Modifiable with ModelImpl[TimelineModel.Update] {

  import TimelineModel._

  private var _total  = bounds0
  private var _visi   = bounds0
  private var _pos    = bounds0.start
  private var _sel    = Span.Void: SpanOrVoid

  def visible = _visi
  def visible_=(value: Span): Unit = {
    val oldSpan = _visi
    if (oldSpan != value) {
      _visi = value
      val visiCh  = Change(oldSpan, value)
      //      val oldPos  = _pos
      //      if (oldPos < value.start || oldPos > value.stop) {
      //        _pos = math.max(value.start, math.min(value.stop, _pos))
      //      }
      dispatch(Visible(this, visiCh))
    }
  }

  def position = _pos
  def position_=(value: Long): Unit = {
    val oldPos = _pos
    if (oldPos != value) {
      _pos      = value
      val posCh = Change(oldPos, value)
      dispatch(Position(this, posCh))
    }
  }

  def selection = _sel
  def selection_=(value: SpanOrVoid): Unit = {
    val oldSel = _sel
    if (oldSel != value) {
      _sel  = value
      val selCh = Change(oldSel, value)
      dispatch(Selection(this, selCh))
    }
  }

  def bounds = _total
  def bounds_=(value: Span): Unit = {
    val oldTot = _total
    if (oldTot != value) {
      _total = value
      val totCh = Change(oldTot, value)
      dispatch(Bounds(this, totCh))
    }
  }
}