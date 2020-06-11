package org.usagram.dresscode

import scala.xml.NodeSeq

trait View {
  def block[T](name: String)(content: => T) =
    <p>
    {{block:{name}}}
    {content}
    {{/block:{name}}}
    </p>.head.child

  def showFor(express: PartialFunction[Page, NodeSeq])(implicit context: Context) =
    showWith(context => express(context.page)) as {
      implicit val site = context.site
      val sample = PostSeq(Text(), Photo(), Panorama(), Photoset(), Quote(), Link(), Chat(), Audio(), Video(), Answer())
      block("Index") { express(Index(sample)) } ++
      block("Day")   { express(Day(sample)) }
    }

  def showWith[A](show: ShowContext => A)(implicit context: Context) = new ShowWith(show)

  def showBy[A](show: => A)(implicit context: Context) = new ShowBy(show)

  class Show[A](show: ShowContext => A)(implicit context: Context) {
    def as(make: MakeContext => A) = showOr(make)

    def as(make: => A) = showOr(_ => make)

    def referBy(varName: String)(implicit ev: String <:< A) = showOr(_ => s"{$varName}")

    private def showOr(make: MakeContext => A) = context match {
      case context: ShowContext => show(context)
      case context: MakeContext => make(context)
    }
  }

  class ShowWith[A](show: ShowContext => A)(implicit context: Context) extends Show(show)

  class ShowBy[A](show: => A)(implicit context: Context) extends Show(_ => show)

  def refer(name: String)(implicit context: Context) =
    showWith { context => context.variables.get(name) getOrElse "" } referBy name
}
