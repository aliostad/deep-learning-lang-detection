package org.qingqing.relation.util

import java.io.File
import java.io.FileWriter
import java.io.BufferedWriter
import scala.collection.mutable.Map

class Write {

  /** Appen to file
    */
  def appendtofile(output: String, list: List[List[String]]) = {
    val outputfile = new File(output)
    val fw = new BufferedWriter(new FileWriter(outputfile, true))

    list.foreach {
      case l =>
        {
          fw.write(l(0))
          for (i <- 1 to l.size - 1)
            fw.write("\t" + l(i))
        }
        fw.newLine()
    }
    fw.flush()
    fw.close()
  }

  def rewrite(output: String, data: Map[String, List[(String, String, String, String, String)]]) = {
    data.foreach {
      case (disrel, tuples) => {
        val outputname = output + "/" + disrel + ".txt"
        val outputfile = new File(outputname)
        val fw = new BufferedWriter(new FileWriter(outputfile, false))

        tuples.foreach {
          case tuple => {
            fw.write(tuple._1)
            fw.write("\t")
            fw.write(tuple._2)
            fw.write("\t")
            fw.write(tuple._3)
            fw.write("\t")
            fw.write(tuple._4)
            fw.write("\t")
            fw.write(tuple._5)
            fw.newLine()
          }
        }
        fw.flush()
        fw.close()
      }
    }
  }

  def rewrite_1(output: String, data: List[(String, String, String, String, String)]) = {
    val outputfile = new File(output)
    val fw = new BufferedWriter(new FileWriter(outputfile, false))

    data.foreach {
      case tuple => {
        fw.write(tuple._1)
        fw.write("\t")
        fw.write(tuple._2)
        fw.write("\t")
        fw.write(tuple._3)
        fw.write("\t")
        fw.write(tuple._4)
        fw.write("\t")
        fw.write(tuple._5)
        fw.newLine()
      }
    }
    fw.flush()
    fw.close()
  }

  def rewrite_version1(outputname: String,
    data: List[(String, String, String, String, String, Set[Set[org.allenai.nlpstack.graph.Graph.Edge[org.allenai.nlpstack.parse.graph.DependencyNode]]])]) = {
    val outputfile = new File(outputname)
    val fw = new BufferedWriter(new FileWriter(outputfile, false))

    data.foreach {
      case tuple => {
        fw.write(tuple._1)
        fw.write("\t")
        fw.write(tuple._2)
        fw.write("\t")
        fw.write(tuple._3)
        fw.write("\t")
        fw.write(tuple._4)
        fw.write("\t")
        fw.write(tuple._5)
        fw.write("\t")
        fw.write(tuple._6.toString)
        fw.newLine()
      }
    }
    fw.flush()
    fw.close()
  }

  def rewrite_3(outputname: String, data: Map[String, Int]) = {
    val outputfile = new File(outputname)
    val fw = new BufferedWriter(new FileWriter(outputfile, false))

    data.foreach {
      case (entity, count) => {
        println("---" + entity)
        println("====" + count)
        fw.write(entity)
        fw.write("\t")
        fw.write(count.toString)
        fw.newLine()
      }
    }
    fw.flush()
    fw.close()
  }

  def rewrite_2(outputname: String,
    data: List[(String, String, String, String, String, Set[Set[String]])]) = {
    val outputfile = new File(outputname)
    val fw = new BufferedWriter(new FileWriter(outputfile, false))

    data.foreach {
      case tuple => {
        fw.write(tuple._1)
        fw.write("\t")
        fw.write(tuple._2)
        fw.write("\t")
        fw.write(tuple._3)
        fw.write("\t")
        fw.write(tuple._4)
        fw.write("\t")
        fw.write(tuple._5)
        fw.write("\t")
        fw.write(tuple._6.toString)
        fw.newLine()
      }
    }
    fw.flush()
    fw.close()
  }
}