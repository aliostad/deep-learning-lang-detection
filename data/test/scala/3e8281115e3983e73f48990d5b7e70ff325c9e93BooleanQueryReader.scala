package yairs.io

import java.io.File
import io.Source
import yairs.model.{Query, BooleanQuery}
import org.eintr.loglady.Logging
import yairs.util.Configuration

/**
 * Created with IntelliJ IDEA.
 * User: Hector, Zhengzhong Liu
 * Date: 2/6/13
 * Time: 9:38 PM
 */
class BooleanQueryReader(config:Configuration) extends QueryReader{
  @Override
  def getQueries(queryFile:File):List[Query] = Source.fromFile(queryFile).getLines().map(line => line.split(":")).map(fields => new BooleanQuery(fields(0),fields(1),config)).toList

  def getQuery(qid:String,queryString:String):Query = new BooleanQuery(qid,queryString,config)
}

object BooleanQueryReader extends Logging{
  def main(args : Array[String]) {
    if (args.length == 0) {
      log.error("Please supply the configuration file path as command line parameter")
      System.exit(1)
    }
    val configurationFileName = args(0)
    val config = new Configuration(configurationFileName)

    log.debug("Try some simple queries")

    val qr = new BooleanQueryReader(config)

    testQuery(qr)
    //testQueries(qr)
    log.debug("Done.")
  }

  private def testQuery(qr:BooleanQueryReader){
//    val query0 = qr.getQuery("1","#OR (#AND (viva la vida) coldplay)")
//    query0.dump()
//
//    val  query1 = qr.getQuery("2","(#AND (viva la vida) coldplay)")
//    query1.dump()
//
//    val query2 = qr.getQuery("3","#AND (viva la vida) coldplay")
//    query2.dump()
//
//    val query3 = qr.getQuery("4","(viva la vida) coldplay")
//    query3.dump()
//
//    val query4 = qr.getQuery("5","(#NEAR/2(viva la) vida) coldplay")
//    query4.dump()
//
//    val query5 = qr.getQuery("6","((#NEAR/2(viva la) vida)) coldplay")
//    query5.dump()
//
//    val query6 = qr.getQuery("7","#AND (#NEAR/1 (arizona states) obama)")
//    query6.dump()
//
//    val query7 = qr.getQuery("8","#NEAR/1 arizona states")
//    query7.dump()
//
//    val query8 = qr.getQuery("9","arizona+title states+title")
//    query8.dump()
//
//    val query9 = qr.getQuery("10","#NEAR/4 (poker tournaments)")
//    query9.dump()
//
//    val query10 = qr.getQuery("11","#OR (#NEAR/2 (alexian brothers) hospital)")
//    query10.dump()
//
//    val query11 = qr.getQuery("12","er #NEAR/2 (tv show)")
//    query11.dump()
//
//    val query12 = qr.getQuery("13","#WEIGHT(0.5 texas 0.4 hotel 0.1 convention )")
//    query12.dump()
//
//    val query13 = qr.getQuery("14", "#UW/2( border texas )")
//    query13.dump()
//
//    val query14 = qr.getQuery("15", "#AND( #NEAR/2( south africa ) fish )")
//    query14.dump()
//
//    val query15 = qr.getQuery("16", "#UW/2( border texas )")
//    query15.dump()
//
//    val query16 = qr.getQuery("17","#AND(#weight( 0.02598525 joints+anchor 0.002068559 joints+url 0.935296093 joints+body 0.036650099 joints+title ) )")
//    query16.dump()
//
//    val query17 = qr.getQuery("18","#AND(#weight( 0.02598525 keyboard+anchor 0.002068559 keyboard+url 0.935296093 keyboard+body 0.036650099 keyboard+title ) #weight( 0.02598525 reviews+anchor 0.002068559 reviews+url 0.935296093 reviews+body 0.036650099 reviews+title ) )")
//    query17.dump()
//
//    val query18 = qr.getQuery("19","#AND(#weight( 0.02598525 joints+anchor 0.002068559 joints+url 0.935296093 joints+body 0.036650099 joints+title ) #weight( 0.02598525 joints+anchor 0.002068559 joints+url 0.935296093 joints+body 0.036650099 joints+title ))")
//    query18.dump()
//
//     val query19 = qr.getQuery("20","#weight( 0.8 #and( obama family tree ) 0.1 #and( #near/3( family tree )  #near/3( obama family ) ) 0.1 #and( #uw/6( family tree )  #uw/6( obama family ) ) )")
//      query19.dump()
//
//
      val query20 = qr.getQuery("21","#weight( 0.8 #and( #weight( 0.02598525 obama+anchor 0.002068559 obama+url 0.935296093 obama+body 0.036650099 obama+title ) #weight( 0.02598525 family+anchor 0.002068559 family+url 0.935296093 family+body 0.036650099 family+title ) #weight( 0.02598525 tree+anchor 0.002068559 tree+url 0.935296093 tree+body 0.036650099 tree+title ) ) 0.1 #and(  #weight( 0.02598525 #near/3(obama+anchor family+anchor) 0.002068559 #near/3(obama+url family+url) 0.935296093 #near/3(obama+body family+body) 0.036650099 #near/3(obama+title family+title) ) #weight( 0.02598525 #near/3(family+anchor tree+anchor) 0.002068559 #near/3(family+url tree+url) 0.935296093 #near/3(family+body tree+body) 0.036650099 #near/3(family+title tree+title) )) 0.1 #and(  #weight( 0.02598525 #uw/6(obama+anchor family+anchor) 0.002068559 #uw/6(obama+url family+url) 0.935296093 #uw/6(obama+body family+body) 0.036650099 #uw/6(obama+title family+title) ) #weight( 0.02598525 #uw/6(family+anchor tree+anchor) 0.002068559 #uw/6(family+url tree+url) 0.935296093 #uw/6(family+body tree+body) 0.036650099 #uw/6(family+title tree+title) )) )")
      query20.dump()
  }

  def testQueries(qr:BooleanQueryReader){
    qr.getQueries(new File("data/queries.txt")).foreach(q => q.dump())
  }
}
