package joos.codegen.generators

import joos.assemgen.Register._
import joos.assemgen._
import joos.ast.expressions.ClassInstanceCreationExpression
import joos.codegen.AssemblyCodeGeneratorEnvironment

class ClassInstanceCreationExpressionCodeGenerator(expression: ClassInstanceCreationExpression)
    (implicit val environment: AssemblyCodeGeneratorEnvironment) extends AssemblyCodeGenerator {

  override def generate() {

    val tipe = expression.classType.declaration

    appendText(
      :#(s"[BEGIN] Class Instance Creation ${expression}"),
      emptyLine
    )

    expression.arguments.foreach {
      argument =>
        appendText(
          :#("Evaluate parameter"),
          push(Ecx) :# "Save old this",
          #>)

        argument.generate()

        appendText(
          #<,
          pop(Ecx) :# "Retrieve old this",
          push(Eax) :# "Push parameter onto stack",
          emptyLine
        )
    }

    appendText(
      push(Ecx) :# "Save old this",
      call(mallocTypeLabel(tipe)) :# "Allocate raw bytes for object. Returns this in ecx",
      call(expression.constructor.uniqueName) :# "Call constructor. Returns this as ecx",
      mov(Eax, Ecx) :# "Return new object as eax",
      pop(Ecx) :# "Retrieve old this",
      add(Esp, 4 * expression.arguments.size) :# "Pop arguments off stack"
    )

    appendText(
      :#(s"[END] Class Instance Creation ${expression}"),
      emptyLine
    )
  }

}