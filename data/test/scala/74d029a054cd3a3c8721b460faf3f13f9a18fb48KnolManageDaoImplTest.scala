package com.knol.core.Impl

import java.sql.PreparedStatement

import org.scalatest.BeforeAndAfter
import org.scalatest.FunSuite

import com.knol.core.impl.KnolManage
import com.knol.core.impl.KnolManageDaoImpl
import com.knol.core.impl.Knolder
import com.knol.core.impl.KnolderDaoImpl
import com.knol.core.impl.KnolderSession
import com.knol.core.impl.KnolderSessionDaoImpl
import com.knol.db.connection.DBConnectionImpl

class KnolManageDaoImplTest extends FunSuite with BeforeAndAfter {

  var knolRepo = new KnolderDaoImpl
  var knolSessionRepo = new KnolderSessionDaoImpl
  var knolManageObj = new KnolManageDaoImpl

  val dbCon = new DBConnectionImpl()
  val con = dbCon.getConnection()
  con match {
    case Some(con) => {
      try {

        val stmt1 = con.createStatement()
        var sql1 = "CREATE TABLE IF NOT EXISTS knolder (id int not null AUTO_INCREMENT, name varchar(20),email varchar(20),mobile varchar(20),primary key(id),unique key(email))";
        val st1: PreparedStatement = con.prepareStatement(sql1);
        st1.executeUpdate(sql1);
        knolRepo.insert(Knolder(0, "Adam", "adam@jason.com", "10101"))

        val stmt = con.createStatement()
        var sql = "create table IF NOT EXISTS knoldersession (id int not null auto_increment, topic varchar(20), date Date,knol_id int, primary key(id),unique key (topic), foreign key(id) references knolder(id))";
        val st: PreparedStatement = con.prepareStatement(sql);
        st.executeUpdate(sql);
        knolSessionRepo.insert(KnolderSession(0, "Angular", "2015-02-02", 1));

      } catch {
        case ex: Exception => {
          None
        }
      }
    }
    case None => None
  }

  after {
    // val dbCon = new DBConnectionImpl()
    // val con = dbCon.getConnection()
    con match {
      case Some(con) =>
        {
          try {

            val stmt = con.createStatement()
            var sql = "Drop table knolder"
            var sql1 = "Drop table knoldersession"
            stmt.execute(sql1)
            stmt.execute(sql)
            con.close()
          } catch {
            case ex: Exception => {
              None
            }
          }
        }
      case None => None
    }
  }

  test("Testing the join query for fetching the matching result from both knolder and knoldersession tables") {
    //pending

    val knol1 = KnolManage(1, "Adam", "adam@jason.com", "10101", 1, "Angular", "2015-02-02")
    var list = List(knol1)
    assert(knolManageObj.ShowAll === list)
  }

  test("Testing the join query for fetching the matching result from both knolder and knoldersession tables for catch case coverage") {

    val dbCon1 = new DBConnectionImpl()
    val con1 = dbCon.getConnection()
    con1 match {
      case Some(con1) =>
        var sql = "Drop table knolder"
        var sql1 = "Drop table knoldersession"
        val stmts = con1.createStatement()
        stmts.execute(sql1)
        stmts.execute(sql)

        val knol1 = KnolManage(1, "Am", "adaason.com", "10101", 1, "Angular", "2002-02")
        var list = List(knol1)
      case None=>None
    }
    assert(knolManageObj.ShowAll === 0)
  }

}


