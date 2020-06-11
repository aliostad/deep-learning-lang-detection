package com.thoughtstream.audit.process

import com.thoughtstream.audit.bean.JsNode
import play.api.libs.json._

/**
 *
 * @author Sateesh
 * @since 23/11/2014
 */
object FancyTreeProcessor {

  def transformToPresentableJsNodes(jsValue: JsValue): Seq[JsNode] = {
    jsValue match {
      case x: JsString => Seq(JsNode(x.value))
      case x: JsNumber => Seq(JsNode(x.value.toString()))
      case x: JsBoolean => Seq(JsNode(x.value.toString))
      case JsNull => Seq(JsNode(""))
      case x: JsUndefined => Seq(JsNode(""))
      case x: JsObject => collapseOldValues(x).map(y => collapseSingleChildToParentJsNode(y._1, transformToPresentableJsNodes(y._2))).toSeq
      case x: JsArray => x.value.map(transformToPresentableJsNodes).zip(1 to x.value.size).map(y => JsNode("item_" + y._2, y._1))
    }
  }

  private def collapseOldValues(input: JsObject): Seq[(String, JsValue)] = {
    val oldValueNodes = input.fieldSet.filter(x => x._1.endsWith(postfixForOldPrimitiveValue))
    if (oldValueNodes.isEmpty) {
      input.fields
    } else {
      input.fields.filter(x => !x._1.endsWith(postfixForOldPrimitiveValue)).map(x => {
        val oldValue = oldValueNodes.find(y => y._1.equals(x._1 + postfixForOldPrimitiveValue))
        if (oldValue.isDefined) {
          (x._1, JsObject(Seq(
            "currentValue" -> x._2,
            "oldValue" -> oldValue.get._2
          )))
        } else {
          x
        }
      }).toSeq
    }
  }

  private def collapseSingleChildToParentJsNode(title: String, children: Seq[JsNode]): JsNode = {
    children match {
      case Seq(x) if x.children == null || x.children.isEmpty => JsNode(title + (if (x.title.contains("=")) "/" else "=") + x.title)
      case _ => JsNode(title, children)
    }
  }
}
