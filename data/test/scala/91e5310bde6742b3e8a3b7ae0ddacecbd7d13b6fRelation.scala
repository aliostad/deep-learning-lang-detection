package hello

import org.apache.log4j.{ Level, Logger }
import org.apache.spark.{ SparkContext, SparkConf }
import org.apache.spark.graphx._
import org.apache.spark.rdd.RDD
import scala.io.Source
import scala.collection.mutable.ArrayBuffer
import scala.util.parsing.json._

case class vertexProperty(val name: String, val roletype: String)

object Relation {
  def main(args: Array[String]) {
    val startTime = System.currentTimeMillis();
    //屏蔽日志
    Logger.getLogger("org.apache.spark").setLevel(Level.WARN)
    Logger.getLogger("org.eclipse.jetty.server").setLevel(Level.OFF)

    //设置运行环境
    val conf = new SparkConf().setAppName("SimpleGraphX").setMaster("local")
    val sc = new SparkContext(conf)

    // 存点的数据 id,name,type
    val vertexArray = ArrayBuffer[(VertexId, vertexProperty)]()

    // 存边的数据 position
    val manageEdgeArray = ArrayBuffer[Edge[String]]()

    // 从json文件中加载数据
    val fileAbsPath = "C:/Users/LiYintao/code/scala-example/src/com/wyunbank/scala/data/BasicInfoItem_2016-05-18.json"
    val sourceV = Source.fromFile(fileAbsPath, "UTF-8")

    var vid = 0;
    val regex = "\"name\": \"";
    for (line <- Source.fromFile(fileAbsPath).getLines.filter(line => line.split(regex).length > 2)) {
      print(line + "\n")
      val firstEmplyee = line.split(regex).apply(2).split("\"").apply(0)
      //      val title = currentLine.split("job_title\":\"").apply(1).split("\"").apply(0)
      vid = vid + 1
      vertexArray += ((vid, vertexProperty(firstEmplyee, "individual")))
      print(vertexArray.apply(vid.toInt - 1) + "\n")
      vid = vid + 1

      val companyName = line.split(regex).apply(1).split("\"").apply(0)
      vertexArray += ((vid, vertexProperty(companyName, "company")))
      print(vertexArray.apply(vid.toInt - 1) + "\n")

      manageEdgeArray += Edge(vertexArray.apply(vid.toInt - 2)._1, vertexArray.apply(vid.toInt - 1)._1, "manage")
      print(manageEdgeArray.apply((vid / 2 - 1).toInt) + "\n")
    }

    // 构图
    // 创建点RDD
    val entities: RDD[(VertexId, vertexProperty)] = sc.parallelize(vertexArray)

    // 创建边RDD
    val managerelations: RDD[Edge[String]] = sc.parallelize(manageEdgeArray)

    // 定义一个默认用户，避免有不存在用户的关系
    val graph = Graph(entities, managerelations)

    // 输出Graph的信息
    graph.vertices.collect().foreach(println(_))
    graph.triplets.map(triplet => triplet.srcAttr + "----->" + triplet.dstAttr + "    attr:" + triplet.attr).collect().foreach(println(_))

    val endTime = System.currentTimeMillis();

    print("time consume: "+(endTime-startTime))
  }
}