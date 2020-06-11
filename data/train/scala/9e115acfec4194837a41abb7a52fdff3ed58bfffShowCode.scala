import scala.reflect.runtime._
import scala.tools.reflect.ToolBox

/**
 * Author: Krzysztof Romanowski
 */
object ShowCode extends App {

  import universe._

  lazy val toolbox: ToolBox[universe.type] = universe.runtimeMirror(getClass.getClassLoader).mkToolBox()

  val code = "List(1, 2).reduce(_ + _ )"
  val oldCode = toolbox.untypecheck(toolbox.typecheck(toolbox.parse(code)))
  val Apply(_, List(Function(params, body))) = oldCode

  val newClass = toolbox.parse(s"class Ala extends Function2[Int, Int, Any]{ override def apply(v1: Any) = ???}")

  val ClassDef(mods, name, tparams, Template(parents, self, List(constructor, oldApplyFunction))) = newClass


  val DefDef(functionMods, functionName, _, _, retType, _) = oldApplyFunction
  val newApplyFunction = DefDef(functionMods, functionName, Nil, List(params), retType, body)
  val newFunctionClass = ClassDef(mods, name, tparams, Template(parents, self, List(constructor, newApplyFunction)))

  val reCode = universe.showCode(newFunctionClass)
  val reParsed = toolbox.parse(reCode)
  println(reCode)
}
