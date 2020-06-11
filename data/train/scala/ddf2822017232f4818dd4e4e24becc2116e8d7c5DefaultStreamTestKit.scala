import akka.stream.FlowMaterializer
import akka.stream.stage.{Context, Directive, PushPullStage}
import org.scalatest.concurrent.ScalaFutures

class DefaultStreamTestKit extends DefaultTestKit with ScalaFutures {
  implicit val materializer = FlowMaterializer()

  class Dump[A](prefix:String) extends PushPullStage[A, A] {
    override def onPush(elem: A, ctx: Context[A]): Directive = {
      println(s"$prefix: $elem")

      ctx.push(elem)
    }

    override def onPull(ctx: Context[A]): Directive =
      ctx.pull()
  }

  def dump[A](prefix:String):Dump[A] = new Dump(prefix)
}
