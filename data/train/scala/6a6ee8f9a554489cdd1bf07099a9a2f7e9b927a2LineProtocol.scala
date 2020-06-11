package metrics

import shapeless._
import ops.hlist._
import labelled.FieldType

object LineProtocol {
  object writeValue extends Poly1 {
    implicit def caseLong =
      at[Long](_.toString + "i")

    implicit def caseDouble =
      at[Double](_.toString)

    implicit def caseBigDecimal =
      at[BigDecimal](_.toString)

    implicit def caseString =
      at[String]("\"" + _.replaceAll("\"", "\\\\\"") + "\"")

    implicit def caseStringSeq =
      at[Seq[String]]("\"" + _.mkString(",").replaceAll("\"", "\\\\\"") + "\"")
  }

  trait WriteMetric[M] {
    def writeMetric(m: M): String
  }

  object WriteMetric extends LabelledTypeClassCompanion[WriteMetric] {
    implicit def field[T](implicit wv: writeValue.Case.Aux[T, String]) =
      new WriteMetric[T] {
        def writeMetric(f: T) = wv(f)
      }

    object typeClass extends LabelledTypeClass[WriteMetric] {
      def emptyProduct: WriteMetric[HNil] =
        new WriteMetric[HNil] {
          def writeMetric(n: HNil) = ???
        }

      def product[H, T <: HList](name: String, ch: WriteMetric[H], ct: WriteMetric[T]) =
        new WriteMetric[H :: T] {
          def writeMetric(hl: H :: T) = hl match {
            case h :: HNil => s"${name}=${ch.writeMetric(h)}"
            case h :: t => s"${name}=${ch.writeMetric(h)},${ct.writeMetric(t)}"
          }
        }

      def emptyCoproduct =
        new WriteMetric[CNil] {
          def writeMetric(n: CNil) = ???
        }

      def coproduct[L, R <: Coproduct](name: String, cl: ⇒ WriteMetric[L], cr: ⇒ WriteMetric[R]) =
        new WriteMetric[L :+: R] {
          def writeMetric(cp: L :+: R) = cp match {
            case Inl(l) => cl.writeMetric(l)
            case Inr(r) => cr.writeMetric(r)
          }
        }

      def project[F, G](instance: ⇒ WriteMetric[G], to: F ⇒ G, from: G ⇒ F) =
        new WriteMetric[F] {
          def writeMetric(f: F) = instance.writeMetric(to(f))
        }
    }
  }

  def writeMetric[M](m: M)(implicit wm: WriteMetric[M]) = wm.writeMetric(m)

  object writeMetricsMapField extends Poly1 {
    val nonAlnum = "[\\P{Alnum}_]+".r

    val underscoreSeq = "_+".r

    def normalizedName(n: String): String =
      underscoreSeq.replaceAllIn(nonAlnum.replaceAllIn(n, "_"), "_")

    implicit def default[K <: Symbol, M <: Metric](
      implicit kw: Witness.Aux[K],
      wm: WriteMetric[M]) =
      at[FieldType[K, Map[String, M]]](mm =>
        mm.map {
          case (l, v) =>
            (s"${kw.value.name}_${normalizedName(l)}", writeMetric(v.asInstanceOf[M]))
        }.toList)
  }

  def writeMetrics[H1 <: HList, H2 <: HList](m: Metrics, tags: String, timestamp: String)(
    implicit lgen: LabelledGeneric.Aux[Metrics, H1],
    lmapper: Lazy[Mapper.Aux[writeMetricsMapField.type, H1, H2]],
    toTrav: ToTraversable.Aux[H2, List, List[(String, String)]]) = {
    implicit val mapper = lmapper.value
    lgen.to(m).map(writeMetricsMapField).toList.flatten.map {
      case (l, v) =>
        s"${l}${tags} ${v} ${timestamp}"
    }.mkString("\n")
  }
}
