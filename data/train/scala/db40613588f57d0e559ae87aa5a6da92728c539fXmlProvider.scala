package degrel.misc.serialize

import scala.xml.{XML, Elem}

class XmlProvider extends FormatProvider[DDocument, Elem] {
  override def dump(in: DDocument): Elem = {
    val vs = in.vertices.map(toXElem)
    <graph>
      {vs}
    </graph>
  }

  protected def toXElem(v: DVertex): Elem = {
    <vertex id={v.id.toString} label={v.label}>
      {v.edges.map {
      case DEdge(_, lbl, DRef(id)) => <edge label={lbl} ref={id.toString}/>
      case DEdge(_, lbl, dv: DVertex) =>
        <edge label={lbl}>
          {toXElem(dv)}
        </edge>
    }}
    </vertex>
  }

  override def load(in: Elem): DDocument = ???

  override def dumpString(in: DDocument): String = {
    val xml = this.dump(in)
    xml.toString()
  }

  override def loadString(in: String): DDocument = {
    val xml = XML.loadString(in)
    this.load(xml)
  }
}
