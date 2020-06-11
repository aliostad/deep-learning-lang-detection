package com.stocksimulator.output

import com.mongodb.BasicDBObject

object MongoToSql {
import MySqlModule._
import org.joda.time._

 trait SaveAllTables {
 
  def mkResTbl: MakeResultTable
  def mkOrdTbl: MakeOrdersTable
  def mkJobsTbl: MakeJobsTable
  def save(mongo: BasicDBObject) = {
    val resTbl = mkResTbl
    val ordTbl = mkOrdTbl
    val jobTbl = mkJobsTbl
    
    (jobTbl andThen(resTbl) andThen(ordTbl))(mongo, Map.empty[Symbol, Int])
  }
}

def defaultSaveAllTables(s3Location: String, mongo: BasicDBObject, idx: String) = {
 type SqlConn = MySqlConnectionDefault 
  val svATbl = new SaveAllTables {
    def mkResTbl = new MakeResultTable with SqlConn with ResultadosTblManageDefault {
      val s3Path = s3Location
      val id = idx}
    def mkOrdTbl = new MakeOrdersTable with SqlConn with OrdersTblManageDefault {}
    def mkJobsTbl = new MakeJobsTable with SqlConn with JobsTblManageDefault {}
    
    save(mongo)
  }
} 

 trait TableMakingTrail {
  tab => 

  protected val regex = new scala.util.matching.Regex("""(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})""", "year", "month", "day", "hour", "minute", "second") 
  
  
  type KeyMap = Map[Symbol, Int]
  def apply(mongo: BasicDBObject, previousKeys: KeyMap): (BasicDBObject, KeyMap)
  def andThen(x: TableMakingTrail): TableMakingTrail = {
    new TableMakingTrail {
      def apply(mongo: BasicDBObject, previousKeys: KeyMap): (BasicDBObject, KeyMap) = {
        val (b, k) = tab.apply(mongo, previousKeys)
        x.apply(b, k)
      }
    }
    
  } 
 }
 
 trait MakeJobsTable extends TableMakingTrail {
   self: JobsTblManage =>
     def apply(mongo: BasicDBObject, previousKeys: Map[Symbol, Int]) = {
       val id = mongo.get("sID").asInstanceOf[String]
            val dateParsed = for {
              regex(year, month, day, hour, minute, second) <- regex findFirstIn id
            } yield {
              (new DateTime(year.toInt, month.toInt, day.toInt, hour.toInt, minute.toInt, second.toInt)).getMillis()
            }
         val data = JobsTable(id, dateParsed.get)
         self.jobsTbl.save(data)
         (mongo, previousKeys)
     }
 }
 
 
 trait MakeOrdersTable extends TableMakingTrail {
   self: OrdersTblManage =>
   import scala.concurrent._
   import ExecutionContext.Implicits.global
    def apply(mongo: BasicDBObject, previousKeys: Map[Symbol, Int]) = {
      val prevKey = previousKeys('MakeResultTable)
      val orders = mongo.get("Orders").asInstanceOf[Seq[BasicDBObject]]
      orders.foreach {
        order => 
          val orderType = order.get("Order").asInstanceOf[String]
          if(orderType != "Empty") {
            val side = if(orderType == "Buy") 1 else -1
            val instrument = order.get("Instrument").asInstanceOf[String]
            val price = order.get("Value").asInstanceOf[Double] * side
            val volume = order.get("Quantity").asInstanceOf[Int]
            val dtlong = order.get("DateTimeLong").asInstanceOf[Long]
            
            val orderTblElem = OrdersTable(prevKey, instrument, dtlong, volume, price)
            future { self.ordersTbl.save(orderTblElem) }
          }
      }
      (mongo, previousKeys)
    }
 }
 trait MakeResultTable extends TableMakingTrail {
    self: ResultadosTblManage =>
      val s3Path: String
      val id: String
      def apply(mongo: BasicDBObject, previousKeys: Map[Symbol, Int]) = {
         val pnl = mongo.get("PNL").asInstanceOf[Double]
            val sortino = mongo.get("sortino").asInstanceOf[Double]
            val sharpe = mongo.get("sharpe").asInstanceOf[Double]
            //val date = mongo.get("date").asInstanceOf[String]
            val paramStr = mongo.get("inputStr").asInstanceOf[String]
            //val id = mongo.get("sID").asInstanceOf[String]
            val dateParsed = for {
              regex(year, month, day, hour, minute, second) <- regex findFirstIn id
            } yield {
              (new DateTime(year.toInt, month.toInt, day.toInt, hour.toInt, minute.toInt, second.toInt)).getMillis()
            }
         
            val resultado = ResultadosTable(id, dateParsed.get, paramStr, s3Path, pnl, sharpe)
            println(resultado)
            val newSqlId = this.resultTbl.save(resultado).get
           (mongo, previousKeys + ('MakeResultTable -> newSqlId))
      }
  }
}