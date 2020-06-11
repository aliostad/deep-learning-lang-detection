package rosalind.graphs

import java.io.FileWriter

/**
 * Created by nikita on 10.12.14.
 */


object GraphVisWriter extends GraphWriter{
  def write(graph:Graphable, name:String, toFile:String) = {
    val fw = new FileWriter(toFile)

    writeHeader()
    for(node <- graph.nodes){
      writeNode(node)
    }
    for(edge <- graph.edges){
      writeEdge(edge)
    }
    writeFooter()
    fw.close()

    def writeHeader() = {
      fw.write("rankdir=LR; node[shape=box fillcolor=gray95 style=filled]\n")
      fw.write(s"digraph $name {\n")
    }

    def writeFooter() = {
      fw.write(s"}\n")
    }

    def writeNode(node:Node) = {
//      fw.write("  \""+node.id+"\";\n")
      fw.write(s"""  "${node.id}" [label="${node.toString}"];\n""")
    }

    def writeEdge(edge:Edge) = {
//      fw.write(s"${edge.n1.name} -> ${edge.n2.name};")
      fw.write(s"""  "${edge.n1.id}" -> "${edge.n2.id}";\n""")
    }
  }


}
