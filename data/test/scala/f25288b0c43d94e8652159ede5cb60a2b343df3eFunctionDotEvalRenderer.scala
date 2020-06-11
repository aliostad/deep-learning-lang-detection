package com.github.sbroadhead.multisched

import com.github.sbroadhead._
import com.github.sbroadhead.codegraph.CodeGraph.{EdgeKey, NodeKey}
import com.github.sbroadhead.codegraph._
import com.github.sbroadhead.codegraph.dot.Dot.Builder
import com.github.sbroadhead.codegraph.dot._
import com.github.sbroadhead.multisched.Instructions._
import com.github.sbroadhead.multisched.Registers._

class FunctionDotEvalRenderer(cg: FunctionGraph, nodeNameMap: Map[NodeKey, String], env: Map[NodeKey, Any]) extends CodeGraphRenderer[Register, Instruction](cg) {
  import CodeGraphOps._

  override def buildNodeLabelAttributes(key: NodeKey): Builder[(String, String)] = { attr =>
    def get(key: NodeKey) = env.getOrElse(key, sys.error(s"Node not evaluated: $key")).asInstanceOf[Vec4]

    def dumpInt(i: Int) = f"${java.lang.Float.intBitsToFloat(i)}%16.8g 0x${i.toHexString.reverse.padTo(8, '0').reverse}"

    def dumpVec(v: Vec4) = f"${dumpInt(v.a)}\n${dumpInt(v.b)}\n${dumpInt(v.c)}\n${dumpInt(v.d)}"

    val node = cg.node(key).head
    node match {
      case x if cg.inputs.contains(key) =>
        attr("shape" -> "trapezium")
        attr("fillcolor" -> "#ddffdd")
        attr("style" -> "filled")
        attr("fontname", "courier")
        attr("fontsize", "11.0")
        attr("label" -> dumpVec(get(key)))
      case x if cg.outputs.contains(key) =>
        attr("shape" -> "invtrapezium")
        attr("fillcolor" -> "#ddffdd")
        attr("style" -> "filled")
        attr("fontname", "courier")
        attr("fontsize", "11.0")
        attr("label" -> dumpVec(get(key)))
      case VEC() =>
        attr("shape" -> "box")
        attr("style" -> "filled")
        attr("fontname", "courier")
        attr("label" -> (nodeNameMap.getOrElse(key, "-") + "\n" + dumpVec(get(key))))
        attr("fontsize", "11.0")
    }
  }

  override def buildEdgeLabelAttributes(key: EdgeKey): Builder[(String, String)] = { attr =>
    val edge = cg.edge(key).head
    edge.label match {
      case const(Vec4(a,b,c,d)) =>
        attr("shape", "note")
        attr("fontname", "courier")
        attr("label", s"0x${a.toHexString}\\n0x${b.toHexString}\\n0x${c.toHexString}\\n0x${d.toHexString}")
        attr("style", "filled")
        attr("fillcolor", "#ffcccc")
      case x =>
        attr("shape", "rect")
        attr("fontname", "helvetica")
        attr("label", s"${edge.label.toString}")
        attr("style", "filled")
        attr("fillcolor", "#ccccff")
    }
  }
}
