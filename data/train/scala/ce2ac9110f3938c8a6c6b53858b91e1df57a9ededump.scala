package white {

  import java.io._

  object dumper {
    var unit = "  "

    def dump(writer: PrintWriter, ast: W_AST, indent: String): Unit = {
      ast match {
        // 变量引用

        case VariableRef(name: String) => {
          writer.print(s"*ast.VariableRef { $name }\n")
        }

        // 变量声明
        case VariableDef(name: String, initValue: Expr) => {
          writer.print(s"*ast.VariableDef {\n" +
            s"${indent + unit}name: $name\n" +
            s"${indent + unit}initValue: ")
          dump(writer, initValue, indent + unit)
          writer.print(s"${indent}}\n")
        }

        // 赋值
        case AssignExpr(variable: VariableRef, value: Expr) => {
          writer.print(s"*ast.AssignExpr {\n" +
            s"${indent + unit}variable: $variable\n" +
            s"${indent + unit}value: ")
          dump(writer, value, indent + unit)
          writer.print(s"${indent}}\n")
        }
        // 代码块
        case Block(block: List[Expr], scope: Scope) => {
          var i = 0
          val last = block.length - 1
          writer.print(s"*ast.Block (len=${block.length}) {\n")
          if (scope.table.nonEmpty) {
            dumpScope(writer, indent + unit, scope)
          }
          for (i <- 0 to last) {
            writer.print(s"${indent + unit}$i: ")
            dump(writer, block(i), indent + unit)
          }
          writer.print(s"$indent}\n")
        }

        // 数字字面量
        case NumberLiteral(value: Double) => writer.println(value)

        // 字符串字面量
        case StringLiteral(value: String) => writer.println("\"" + value + "\"")

        // 布尔字面量
        case BoolLiteral(value: Boolean) => writer.println(value)

        // 二元运算
        case BinaryExpr(operator: W_Token, lhs: Expr, rhs: Expr) => {
          writer.print(s"*ast.BinaryExpr {\n" +
            s"${indent + unit}operator: $operator\n" +
            s"${indent + unit}lhs: ")
          dump(writer, lhs, indent + unit)
          writer.print(s"${indent + unit}rhs: ")
          dump(writer, rhs, indent + unit)
          writer.print(s"$indent}\n")
        }

        // 单目运算
        case UnaryExpr(operator: W_Token, hs: Expr) => {
          writer.print(s"*ast.UnaryExpr {\n" +
            s"${indent + unit}operator: $operator\n" +
            s"${indent + unit}hs: ")
          dump(writer, hs, indent + unit)
          writer.print(s"$indent}\n")
        }

        // 完整if表达式
        case IfExpr(cond: Expr, body: Expr, else_body: Option[Expr]) => {
          writer.print(s"*ast.IfExpr {\n" +
            s"${indent + unit}cond: ")
          dump(writer, cond, indent + unit)

          writer.print(s"${indent + unit}body: ")
          dump(writer, body, indent + unit)

          if (else_body.isDefined) {
            writer.print(s"${indent + unit}else_body: ")
            dump(writer, else_body.get, indent + unit)
          }

          writer.print(s"$indent}\n")
        }

        // while表达式
        case WhileExpr(cond: Expr, body: Expr) => {
          writer.print(s"*ast.WhileExpr {\n" +
            s"${indent + unit}cond: ")
          dump(writer, cond, indent + unit)

          writer.print(s"${indent + unit}body: ")
          dump(writer, body, indent + unit)

          writer.print(s"$indent}\n")
        }

        // 函数定义
        case FunctionDef(name: String, params: List[String], body: Block) => {
          writer.print(s"*ast.FunctionDef {\n" +
            s"${indent + unit}name: $name\n" +
            s"${indent + unit}params: ${params.mkString(",")}\n")

          writer.print(s"${indent + unit}body: ")
          dump(writer, body, indent + unit)

          writer.print(s"$indent}\n")
        }

        // 函数调用
        case FunctionCall(func: Expr, args: List[Expr]) => {
          var i = 0
          val last = args.length - 1

          writer.print(s"*ast.FunctionCall {\n")

          writer.print(s"${indent+unit}func: ")
          dump(writer, func, indent + unit)

          writer.print(s"${indent+unit}args: {\n")
          for (i <- 0 to last) {
            writer.print(s"${indent + unit * 2}$i: ")
            dump(writer, args(i), indent + unit * 2)
          }
          writer.print(s"${indent + unit}}\n")

          writer.print(s"$indent}\n")
        }

        // 模块
        case Module(body: List[Expr], scope: Scope) => {
          var i = 0
          val last = body.length - 1
          writer.print(s"*ast.Module (len=${body.length}) {\n")
          if (scope.table.nonEmpty) {
            dumpScope(writer, indent + unit, scope)
          }
          for (i <- 0 to last) {
            writer.print(s"${indent + unit}$i: ")
            dump(writer, body(i), indent + unit)
          }
          writer.print(s"$indent}\n")
        }
      }
    }

    def dumpScope(writer: PrintWriter, indent: String, scope: Scope) = {
      writer.print(s"${indent}scope:{\n")
      scope.table.foreach(
        x => {
          writer.print(s"${indent + unit}${x._1} -> ${x._2}\n")
        }
      )
      writer.print(s"$indent}\n")

    }

    def dump(ast: W_AST): Unit = {
      val writer = new PrintWriter(System.out)
      dump(writer, ast, "")
      writer.flush()
    }
  }

}
