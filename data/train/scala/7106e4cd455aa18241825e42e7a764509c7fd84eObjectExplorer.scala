package scala.util.dump

import scala.language.experimental.macros
import scala.reflect.macros.Context
import scala.annotation.implicitNotFound
import scala.collection.immutable

sealed trait DumpTree
case class Object(name: String, fields: immutable.ListMap[String, DumpTree]) extends DumpTree
// Maps with non-string keys will be coerced
case class Mapping(map: Map[String, DumpTree]) extends DumpTree
case class Sequence(seq: List[DumpTree]) extends DumpTree
case class Leaf(value: String) extends DumpTree

@implicitNotFound("Don't know how to dump ${A}")
case class Dumpable[A](dumpF: A => DumpTree)

object Dumpable {
  implicit class DumpableOps[A](a: A)(implicit dumpable: Dumpable[A]) {
    def dump = Option(a).map(dumpable.dumpF).getOrElse(Leaf("null"))
  }

  // primitives
  implicit def `String is dumpable` = Dumpable[String](a => Leaf(a))
  implicit def `Double is dumpable` = Dumpable[Double](a => Leaf(a.toString))
  implicit def `Int is dumpable` = Dumpable[Int](a => Leaf(a.toString))
  implicit def `Long is dumpable` = Dumpable[Long](a => Leaf(a.toString))

  // collections
  implicit def `List is dumpable`[A: Dumpable] = Dumpable[List[A]] {
    as => Sequence(as.map(_.dump))
  }

  implicit def `Array is dumpable`[A: Dumpable] = Dumpable[Array[A]] {
    as => Sequence(as.map(_.dump).toList)
  }

  implicit def `Map is dumpable`[A, B: Dumpable] = Dumpable[Map[A, B]] {
    as => Mapping(as.map { case (k, v) => (k.toString, v.dump) }.toMap)
  }

  // case classes
  implicit def `Anything could be dumpable`[A]: Dumpable[A] = macro DumpableMacros.materializeImpl[A]
}

object DumpableMacros {
  def materializeImpl[A: c.WeakTypeTag](c: Context) = {
    import c.universe._
    val fields = caseClassFields(c)(weakTypeOf[A])
    val typeName = weakTypeOf[A].toString
    val obj = newTermName(c.fresh("obj"))
    val materialized = newTermName(c.fresh("materialized"))
    val tmp = newTermName(c.fresh("tmp"))
    val fieldValues = fields map { f =>
      q"{ implicit val $tmp = $materialized; $f -> scala.util.dump.Dumpable.DumpableOps($obj.${newTermName(f)}).dump }"
    }
    c.Expr[Dumpable[A]](q"""{
      lazy val $materialized: scala.util.dump.Dumpable[${weakTypeOf[A]}] = scala.util.dump.Dumpable[${weakTypeOf[A]}] { $obj =>
        scala.util.dump.Object(
          $typeName,
          scala.collection.immutable.ListMap[String, scala.util.dump.DumpTree](..$fieldValues)
        )
      }
      $materialized
    }""")
  }

  private def caseClassFields(c: Context)(tpe: c.Type): List[String] = {
    import c.universe._
    val ctor = tpe.declaration(nme.CONSTRUCTOR)
    val defaultCtor = if (ctor.isMethod) {
      ctor.asMethod
    } else {
      ctor.asTerm.alternatives.map(_.asMethod).find(_.isPrimaryConstructor).get
    }
    defaultCtor.paramss.reduceLeft(_ ++ _).map(_.name.toString)
  }
}

object AsciiTreeView {
  import Dumpable._

  def apply[A: Dumpable](a: A) = show(a.dump, 0, true)

  private def show(t: DumpTree, level: Int, indentFirstLine: Boolean): String = {
    val indent = "  " * level
    val doubleIndent = indent + "  "
    val header = if (indentFirstLine) indent else ""
    t match {
      case Leaf(x) =>
        header + x

      case Object(name, fields) =>
        header + name + (fields map { case (k, v) =>
          doubleIndent + s"$k = " + show(v, level + 1, false)
        }).mkString("\n", ",\n", "")

      case Sequence(seq) =>
        s"$header[" + seq.map(show(_, level + 1, true)).mkString("\n", ",\n", "\n") + s"$indent]"

      case Mapping(m) =>
        s"$header{" + (m map { case (k, v) =>
          doubleIndent + s"$k -> " + show(v, level + 1, false)
        }).mkString("\n", ",\n", "\n") + s"$indent}"
    }
  }
}
