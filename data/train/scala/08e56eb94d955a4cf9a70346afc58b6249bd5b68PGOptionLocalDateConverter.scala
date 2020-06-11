package org.pgscala.converters

import org.joda.time.LocalDate

/** Do not edit - generated in Builder / PGLocalDateConverterBuilder.scala */

object PGOptionLocalDateConverter extends PGConverter[Option[LocalDate]] {
  val PGType = PGLocalDateConverter.PGType

  def toPGString(old: Option[LocalDate]): String =
    old match {
      case None =>
        null
      case Some(ld) =>
        PGLocalDateConverter.toPGString(ld)
    }

  def fromPGString(ld: String): Option[LocalDate] =
    ld match {
      case null | "" =>
        None
      case old =>
        Some(PGLocalDateConverter.fromPGString(old))
    }
}
