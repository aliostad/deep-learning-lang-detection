package implicitconverter

import json._

trait Writes[A] {
	def write(a:A): JsValue
}

object StandardWrites {
	implicit val stringWrites = new Writes[String] {
		def write(a: String) = JsString(a)
	}

	implicit val intWrites = new Writes[Int] {
		def write(a: Int) = JsNumber(a.toDouble)
	}

  implicit val doubleWrites = new Writes[Double] {
    def write(a: Double) = JsNumber(a)
  }

  implicit val mapWrites = new Writes[Map[String,JsValue]] {
    def write(a: Map[String,JsValue]) = JsObject(a)
  }

	implicit def toJson[A](a: A)(implicit writer: Writes[A]): JsValue =
		writer.write(a)
}