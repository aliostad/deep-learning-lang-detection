package com.stocksimulator.output

import java.sql.PreparedStatement
import org.joda.time.DateTime

object MySqlModule {
  import java.util.Properties
  import java.sql.{ Connection, DriverManager, Statement, ResultSet }

  
  
    trait NameFor[T] {
      val name: String
    }
  
  
  trait MySqlConnection {
    def connProvider: MySqlProvider

    trait MySqlCredentials {
      protected val user: String
      protected val password: String

      final lazy val properties: Properties = {
        val prop = new Properties()
        prop.put("user", user)
        prop.put("password", password)
        prop
      }
    }

    trait MySqlServerInfo {
      val hostname: String
      val port: Int = 3306
      val database: String
    }

    trait MySqlProvider {
      self: MySqlCredentials with MySqlServerInfo =>
      final private def connection: Connection = {
        DriverManager.getConnection(s"jdbc:mysql://$hostname:$port/$database", properties)
      }

      def openConnection[T](fun: (Connection) => T) = {

    	val conn = connection
        val res: T = fun(conn)
        conn.close()
        res
      }
      def withQuery(query: String): Int = {
        openConnection {
          conn =>
            val stmt = conn.createStatement()
            stmt.executeUpdate(query)
        }
      }

      private def preparedStatementApl[T](prep: (Connection, String) =>  PreparedStatement, post: (PreparedStatement, Boolean) => T)(query: String)(fun: PreparedStatement => Unit) = {
        openConnection {
          conn => 
          val preStat = prep(conn, query)
          fun(preStat)
          val ok = preStat.execute()
          post(preStat, ok)
        }
      }
      
      
      def withPreparedStatementReturnLastIntKey(query: String)(fun: PreparedStatement => Unit):Option[Int] = {
        val prepared = (conn: Connection, qr: String) => conn.prepareStatement(qr, Statement.RETURN_GENERATED_KEYS)
        val post = (prepStat: PreparedStatement, b: Boolean) => {
        val rs = prepStat.getGeneratedKeys()
        if(rs.next()) Some(rs.getInt(1)) else None  
        }
        preparedStatementApl(prepared, post)(query)(fun)
       
        
      } 
      def withPreparedStatement(query: String)(fun: PreparedStatement => Unit): Boolean = {
        val prepared = (conn: Connection, qr: String) => conn.prepareStatement(qr)
        val post = (_: PreparedStatement, b: Boolean) => b
         preparedStatementApl(prepared, post)(query)(fun)
      }
    }

  }
  trait TableManagement {
	  type T <: Table
	  def tableName(implicit ev: NameFor[T]): String = ev.name
      def save(tblElem: T): Option[Int]
      def get(id: Int): T = ???
	  def create: Int
  }
  
  trait SubTable {
    type Sub <: Table
    
    def getAll(id: Int):Sub
    
  }
  
  trait Table
  case class ResultadosTable(sid: String, datetime: Long, params: String, s3Obj: String, pnl: Double, sharpe: Double) extends Table
  case class OrdersTable(resLocId: Int, instrument: String, datetime: Long, volume: Int, price: Double) extends Table
  case class JobsTable(sid: String, date: Long) extends Table
  
  
  
  trait JobsTblManage {
    val jobsTbl: JobsTblComponent
    
    trait JobsTblComponent extends TableManagement {
      type T = JobsTable
    }
  }
  
  trait OrdersTblManage {
    val ordersTbl: OrdersTblComponent
    
    trait OrdersTblComponent extends TableManagement {
      type T = OrdersTable
    }
  }
  
  trait ResultadosTblManage {
    val resultTbl: ResultadosTblComponent
    trait ResultadosTblComponent extends TableManagement {
     // type Sub = OrdersTable
      type T = ResultadosTable
    }
  }

  trait JobsTblManageDefault extends JobsTblManage {
    self: MySqlConnection =>
      implicit object ResultadosTableName extends NameFor[JobsTable] {
        val name = "Jobs"
      }
      val jobsTbl = new JobsTblComponentImp
      class JobsTblComponentImp extends JobsTblComponent {
        def create = ???
        def save(tblElem: JobsTable) = {
          val query = s"INSERT INTO $tableName (sid, datetime) values (?, ?) on duplicate key update sid=sid"
          self.connProvider.withPreparedStatement(query) {
            prep =>
              prep.setString(1, tblElem.sid)
              prep.setTimestamp(2, new java.sql.Timestamp(tblElem.date))
          }
          None
        }
      }
  }
  trait OrdersTblManageDefault extends OrdersTblManage {
    self: MySqlConnection =>
    implicit object OrdersTableName extends NameFor[OrdersTable] {
      val name = "Orders"
    }
    val ordersTbl = new OrdersTblComponentImp
    class OrdersTblComponentImp extends OrdersTblComponent {
      def create = ???
      
      def save(tblElem: OrdersTable) = {
        val query = s"INSERT INTO $tableName (resLocId, instrument, datetime, volume, price) values (?, ?, ?, ?, ?)"
        self.connProvider.withPreparedStatementReturnLastIntKey(query) {
          prep =>
            prep.setInt(1, tblElem.resLocId)
            prep.setString(2, tblElem.instrument)
            val timestamp = new java.sql.Timestamp(tblElem.datetime)
            //println(timestamp)
            prep.setTimestamp(3, timestamp)
            prep.setInt(4, tblElem.volume)
            prep.setDouble(5, tblElem.price)
            //prep.setDouble(6, tblElem.sharpe)
        }
      }
    }
  }
  trait ResultadosTblManageDefault extends ResultadosTblManage {
    
    self: MySqlConnection =>
    implicit object ResultTableName extends NameFor[ResultadosTable] {
    val name = "ResultadosLocation"
   }
      val resultTbl = new ResultadosTblComponentImp
    class ResultadosTblComponentImp extends ResultadosTblComponent {
      
      
      def create = {
    	val creationQuery = s"""CREATE TABLE `$tableName` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
  `sid` varchar(300) NOT NULL,
  `date` varchar(20) NOT NULL,
  `params` varchar(300) NOT NULL,
  `s3obj` varchar(150) NOT NULL,
  `pnl` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;"""
        self.connProvider.withQuery(creationQuery)
      }
      def save(tblElem: ResultadosTable): Option[Int] = {

        val query = s"INSERT INTO $tableName (sid, date, params, s3Obj, pnl, sharpe) values (?, ?, ?, ?, ?, ?)"
        self.connProvider.withPreparedStatementReturnLastIntKey(query) {
          prepStat =>
            prepStat.setString(1, tblElem.sid)
            prepStat.setTimestamp(2, new java.sql.Timestamp(tblElem.datetime))
            prepStat.setString(3, tblElem.params)
            prepStat.setString(4, tblElem.s3Obj)
            prepStat.setDouble(5, tblElem.pnl)
            prepStat.setDouble(6, tblElem.sharpe)
        }
      }

    }
  }
  trait MySqlConnectionDefault extends MySqlConnection {
    trait AllInfo extends MySqlCredentials with MySqlServerInfo {
      val user = "workerresult"
      val database = user
      val password = "fiveware"
      val hostname = "workerresult.ceipej2fivuq.us-west-2.rds.amazonaws.com"
    }

    val connProvider = new MySqlProvider with AllInfo
  }
}