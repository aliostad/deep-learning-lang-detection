package org.idio.wikidata.dump

import org.apache.spark.{SparkConf, SparkContext}

import org.idio.wikidata.dump.element.{Property, Item, DumpElement}

/*
* Extracts Relationships from the Wikidata Dump.
* It requieres:
*   - Path to wikidata dump
*   - A mapping stating which Topics(Qids to Extract relationships for)
* */
class Extractor(pathToDump: String)(implicit val sc: SparkContext){

  private val originalDump =  sc.textFile(pathToDump)

  // Clean the lines of the dump
  private val cleanedDump = originalDump.filter(line => line!="[" && line!="]").map { line =>
    val lastChar = line.substring(line.size-1, line.size)
    if (lastChar == ","){
      line.substring(0, line.size-1)
    }else{
      line
    }
  }
  private val parsedDump = cleanedDump.flatMap(DumpElement.parseElement(_))

  /*
  * Returns a Map :
  *    PropertyId -> EnglishLabel
  *
  *    i.e:
  *    "P123" -> "isA"
  * */
  def getPropertyMap() ={
    val onlyProperties = parsedDump.flatMap{
      case property:Property => Some(property)
      case _ => None
    }

    val identifierLabelTuples = onlyProperties.map{
       property =>
         val identifier = property.getId().getOrElse("NO_IDENTIFIER")
         val label = property.getLabel("en").getOrElse("NO_LABEL")
         (identifier, label)
    }
    identifierLabelTuples.collect().toMap
  }

  /*
  * @param topicMapping: Path to tsv file where first field is a qId
  * @param pathToOutputRelationships: Path where the resulting extracted relationships will be stored
  * */
  def extractRelationships(topicMapping:Map[String, String], pathToOutputRelationships:String)={

    println("Creating property map..")
    val propertyMap = getPropertyMap()
    println("Finished creating property map")

    // Get only topic elements from the dump which are part of the mapping
    val onlyTopicsInMappingRDD = parsedDump.flatMap{
      case topic:Item if topicMapping.contains(topic.getId().getOrElse("NO_ID")) => Some(topic)
      case _=> None
    }

    // Get the relationships for the selected topics
    val relationships = onlyTopicsInMappingRDD.flatMap{
       topic =>
          topic.getRelationshipTuples().map {
            tuple =>
              val propertyId = tuple._1
              val argumentQid = tuple._2
              (topic.getId().get, argumentQid, propertyId)
          }
    }

    /* Transform relationships:
    //   Qids -> LineIds
    //  PropretyType -> property Labels
    */
    val triples = relationships.flatMap{
       triple =>
          val startQid = triple._1
          val endQid = triple._2
          val relType = triple._3

         val mappedNodes = Array(topicMapping.get(startQid),  topicMapping.get(endQid)).flatten



         if( mappedNodes.size == 2){
           Some( Array(mappedNodes(0),
                       mappedNodes(1),
                       propertyMap.getOrElse(relType, relType) + "_" + relType)
                      )
         }
         else{
           None
         }
    }

    // Save Relationships to a File
    val exportLines = triples.map{
       rel =>
          rel.mkString("\t")
    }

    exportLines.saveAsTextFile(pathToOutputRelationships)
  }


}

object Extractor{

  def main(args:Array[String]): Unit ={
    val pathToMapping = args(0)
    val pathToDump = args(1)
    val outputFolder = args(2)
    println("loading mapping...")
    val nodeMapping = NodeMapping.loadQidToLine(pathToMapping)

    val conf = new SparkConf()
      .setMaster("local[4]")
      .setAppName("Wikidata Relationship Extractor")
      .set("spark.executor.memory", "4G")

    implicit val sc: SparkContext = new SparkContext(conf)

    val parser = new Extractor(pathToDump)
    parser.extractRelationships(nodeMapping, outputFolder)

  }
}
