
package ee.cone.c4gate

import com.typesafe.scalalogging.LazyLogging
import ee.cone.c4actor.QProtocol.Firstborn
import ee.cone.c4actor._
import ee.cone.c4actor.Types.SrcId
import ee.cone.c4assemble.Types.{Index, Values}
import ee.cone.c4assemble._
import ee.cone.c4gate.HttpProtocol.HttpPost

@assemble class ManagementPostAssemble(actorName: String) extends Assemble {
  def joinHttpPostHandler(
    key: SrcId,
    posts: Values[HttpPost]
  ): Values[(SrcId, TxTransform)] =
    for(post ← posts if post.path == s"/manage/$actorName")
      yield WithPK(ManageHttpPostTx(post.srcId, post))

  def joinConsumers(
    key: SrcId,
    firsts: Values[Firstborn]
  ): Values[(SrcId,LocalPostConsumer)] =
    for(_ ← firsts)
      yield WithPK(LocalPostConsumer(s"/manage/$actorName"))
}

case class ManageHttpPostTx(srcId: SrcId, post: HttpPost) extends TxTransform with LazyLogging {
  private def indent(l: String) = s"  $l"
  private def valueLines(index: Index[Any, Product])(k: Any): List[String] =
    index.getOrElse(k,Nil).flatMap(v⇒s"$v".split("\n")).map(indent).toList
  private def report(local: Context): String = {
    val headers: Map[String, String] = post.headers.map(h⇒h.key→h.value).toMap
    val world = local.assembled
    val WorldKeyAlias = """(\w+),(\w+)""".r
    val worldKeyAlias = headers("X-r-world-key")
    val WorldKeyAlias(alias,keyClassAlias) = worldKeyAlias
    val (indexStr,index): (String,Index[Any, Product]) = Single.option(world.keys.toList.collect{
      case worldKey@JoinKey(`alias`,keyClassName,valueClassName)
        if valueClassName.split("\\W").last == keyClassAlias ⇒
        (s"$worldKey",worldKey.of(world))
    }).getOrElse(("[index not found]",Map.empty))
    val res: List[String] = headers("X-r-selection") match {
      case k if k.startsWith(":") ⇒ k.tail :: valueLines(index)(k.tail)
      case "keys" ⇒ index.keys.map(_.toString).toList.sorted
      case "all" ⇒ index.keys.map(k⇒k.toString→k).toList.sortBy(_._1).flatMap{
        case(ks,k) ⇒ ks :: valueLines(index)(k)
      }
    }
    (s"REPORT $indexStr" :: res.map(indent) ::: "END" :: Nil).mkString("\n")
  }
  def transform(local: Context): Context = {
    if(ErrorKey.of(local).isEmpty) logger.info(report(local))
    TxAdd(LEvent.delete[Product](post))(local)
  }
}
