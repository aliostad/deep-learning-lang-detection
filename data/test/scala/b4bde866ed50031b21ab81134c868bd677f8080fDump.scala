package org.leialearns.crystallize.util

object Dump {
  def dump(prefix: String, thing: Any): Iterator[String] = {
    thing match {
      case custom: DumpCustom => dump(prefix, custom.dumpAs)
      case Some(item) => dump(prefix + "! ", item)
      case map: Map[_,_] => dumpMap(prefix, map)
      case iterable: Iterable[_] => dumpIterable(prefix, iterable)
      case iterator: Iterator[_] => dumpIterator(prefix, "[[", "]]", iterator)
      case product: Product => dumpIterator(prefix, "(", ")", product.productIterator)
      case _ =>
        Array(prefix + thing.toString).iterator
    }
  }

  def dumpIterator[T](prefix: String, open: String, close: String, iterator: Iterator[T]): Iterator[String] = {
    val delimited = Seq[Any](open).iterator ++ (iterator map (Some(_))) ++ Seq[Any](close)
    val subPrefix = prefix + "  "
    delimited flatMap {
      case Some(x) => dump(subPrefix, x)
      case delimiter => Seq[String](prefix + delimiter.toString)
    }
  }

  def dumpIterable[T](prefix: String, iterable: Iterable[T]): Iterator[String] = {
    val sorted = iterable.toSeq sortBy sortProjection
    dumpIterator(prefix, "[", "]", sorted.iterator)
  }

  def dumpMap[K,V](prefix: String, map: Map[K,V]): Iterator[String] = {
    val sorted = map.toSeq sortBy {
      case (k, v) => sortProjection(k)
    }
    val delimited = Seq[Any]('{') ++ sorted ++ Seq[Any]('}')
    val subPrefix = prefix + "  "
    delimited.iterator flatMap {
      case (k, v) => dump(subPrefix + k.toString + ": ", v)
      case delimiter => Seq(prefix + delimiter.toString)
    }
  }

  def sortProjection(item: Any): String = {
    item match {
      case hasKey: Sortable => hasKey.sortKey
      case null => null
      case x: Any => x.toString
    }
  }
}
