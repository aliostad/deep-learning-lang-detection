package com.knol.core.Impl

import org.scalatest.BeforeAndAfter
import org.scalatest.FunSuite
import org.slf4j.LoggerFactory
import com.knol.core.impl.Knolder
import com.knol.core.impl.KnolderDaoImpl
import com.knol.core.impl.KnolderSessionDaoImpl
import com.knol.db.connection.DBConnectionImpl
import com.knol.db.connection.DBConnectionImpl
import com.knol.core.impl.KnolderSession
import com.knol.core.impl.KnolManageDaoImpl
import com.knol.core.impl.KnolManageDaoImpl
import com.knol.core.impl.KnolManageDaoImpl
import com.knol.core.impl.KnolManage
import java.sql.PreparedStatement

class KnolderDaoImplTest extends FunSuite with BeforeAndAfter {

  var knolRepo = new KnolderDaoImpl
  var knolSessionRepo = new KnolderSessionDaoImpl
  var knolManageObj = new KnolManageDaoImpl

  before {
    val dbCon = new DBConnectionImpl()
    val con = dbCon.getConnection()
    con match {
      case Some(con) => {
        try {
          val stmt = con.createStatement()
          var sql = "CREATE TABLE IF NOT EXISTS knolder (id int not null AUTO_INCREMENT, name varchar(20),email varchar(20),mobile varchar(20),primary key(id),unique key(email))";

          val st: PreparedStatement = con.prepareStatement(sql);
          st.executeUpdate();
          knolRepo.insert(Knolder(0, "Adam", "adam@jason.com", "10101"))
        } catch {
          case ex: Exception => {
            None
          }
        }
      }
      case None => None
    }
  }

  after {
    val dbCon = new DBConnectionImpl()
    val con = dbCon.getConnection()
    con match {
      case Some(con) =>
        {
          try {

            val stmt = con.createStatement()
            var sql1 = "drop table knoldersession"
            var sql = "drop table knolder"
          
            stmt.execute(sql)  
            stmt.execute(sql1)
            con.close()
          } catch {
            case ex: Exception => {
              //logger.error("Knol repl before error",ex)
              None
            }
          }
        }
      case None => None
    }
  }

  test("Creating a knol") {
    //pending
    val knol = Knolder(0, "mike", "mike@jason.com", "10101")
    assert(knolRepo.insert(knol) === 2)
  }

  test("Creating a knol & testing the catch") {
    // pending 
    val knol = Knolder(0, "Adam", "adam@jason.com", "10101")
    assert(knolRepo.insert(knol) === 0)
  }

  test("Deleting a knol") {
    // pending
    assert(knolRepo.delete(1) === Some(1))
  }

  test("Deleting a knol & testing the catch case") {
    //pending
    assert(knolRepo.delete(10) === None)
  }

  test("selecting a knol") {
    // pending
    val knol = Knolder(1, "Adam", "adam@jason.com", "10101")
    assert(knolRepo.selectById(1).get === knol)
  }

  test("selecting a knol and testing the catch case") {
    //pending
    val knol = Knolder(3, "name", "email", "34")
    assert(knolRepo.selectById(3) === None)
  }

  test("updating a knol") {
    //pending
    val knol = Knolder(1, "king", "shinoda@gmail.com", "1")
    assert(knolRepo.update(knol) === Some(1))

  }

  test("updating a knol and testing the catch case") {
    //pending
    val knol = Knolder(115, "Jammy", "shinoda", "5555")
    assert(knolRepo.update(knol) === None)
  }

  /*
  * Testing for the join query that matches the result coming from both tables
  * knolder and knoldersession.
  */

  /*
  // $COVERAGE-OFF$
  test("Testing the join query for fetching the matching result from both knolder and knoldersession tables") {
    pending

    val knol1 = KnolManage(24, "mike", "mike@.com", "1111", 14, "angular", "2015-02-10")
    //  val knol2 = KnolManage(2,"name","email","1234",4,"Jquery","015-02-03")
    var list = List(knol1)
    assert(knolManageObj.ShowAll === list)

  }

  test("Testing the join query for fetching the matching result from both tables and covering the catch case") {
    pending
    val knol1 = KnolManage(24, "mike", "mike@.com", "1111", 14, "angular", "2015-02-10")
    // val knol2 = KnolManage(44,"name","email","1234",4,"Jquery","015-02-03")
    var list = List(knol1)
    assert(knolManageObj.ShowAll === list)

  }
*/
}