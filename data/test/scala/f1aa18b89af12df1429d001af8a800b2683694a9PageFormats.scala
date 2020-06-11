package com.github.stonexx.play.json

import com.github.stonexx.scala.data.Page
import play.api.libs.functional.syntax._
import play.api.libs.json._

trait PageFormats {

  // @formatter:off
  implicit def pageJsonWrites[A: Writes]: Writes[Page[A]] = (
    (__ \ 'items).write[Seq[A]] ~
    (__ \ 'page).write[Int] ~
    (__ \ 'size).write[Int] ~
    (__ \ 'total).write[Int] ~
    (__ \ 'offset).write[Long] ~
    (__ \ 'last).write[Int] ~
    (__ \ 'prev).writeNullable[Int] ~
    (__ \ 'next).writeNullable[Int]
  )(unlift(Page.Result.unapply[A]))
  // @formatter:on
}
