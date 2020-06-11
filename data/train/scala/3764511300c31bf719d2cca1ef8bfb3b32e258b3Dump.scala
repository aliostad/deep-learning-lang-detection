package ee.cyber.simplicitas.grammartest

import ee.cyber.simplicitas.CommonNode

object Dump {
    val indent = "  "

    def dumpNode(node: CommonNode): String = {
        val buf = new StringBuilder()
        dumpNode(buf, node, "")
        buf.toString
    }

    def dumpNode(buf: StringBuilder, obj: Any,
            prefix: String) {
        obj match {
            case node: CommonNode =>
                dumpCommonNode(buf, node, prefix)
            case null =>
                buf.append("(null)\n")
            case lst: List[Any] =>
                buf.append("List {\n")
                val newPref = prefix + indent
                for (item <- lst) {
                    buf.append(newPref)
                    dumpNode(buf, item, newPref)
                }
                buf.append(prefix + "}\n")
            case _ =>
                buf.append("\"" + obj + "\"")
                buf.append("\n")
        }
    }

    def dumpCommonNode(buf: StringBuilder, node: CommonNode,
            prefix: String) {
        // Write node header.
        buf.append(node.startIndex)
        buf.append(":")
        buf.append(node.endIndex)
        buf.append(":")
        buf.append(baseName(node.getClass.getName))
        buf.append(" {\n")

        // Create list of pairs (name, value)
        val children = node.childrenNames.zipWithIndex.map(
                arg =>
                    (arg._1, node.productElement(arg._2)))
        // Sort the children so they always will appear
        // in the same order.
        val sorted = children.sortWith(_._1 < _._1)

        val newPref = prefix + indent
        for ((name, value) <- sorted) {
            buf.append(newPref)
            buf.append(name)
            buf.append("=")
            dumpNode(buf, value, newPref)
        }
        buf.append(prefix + "}\n")
    }

    def baseName(s: String) = {
        val idx = s.lastIndexOf('.')
        if (idx == -1)
            s
        else
            s.substring(idx + 1)
    }
}