package com.knol.core.impl
import com.knol.core
import com.knol.db.connection.DBConnectionImpl
import java.sql.ResultSet
import java.sql.PreparedStatement
import com.knol.core.KnolManageDao

class KnolManageDaoImpl extends DBConnectionImpl with KnolManageDao {

/*
 * This ShowAll function is fetching the result from both tables knolder and knoldersession and
 * showing the result after the join query
 */
  def ShowAll: List[KnolManage] =
    {
      val jdb = new DBConnectionImpl()
      import scala.collection.mutable;
      var list = List[KnolManage]();
      try {
        val connection = jdb.getConnection()
        connection match {
          case Some(connection) => {
            val preparedStatement: PreparedStatement =
              connection.prepareStatement("select k.id, k.name,k.email,k.mobile,ks.id as 'sessionID', ks.topic,ks.date from knolder k, knoldersession ks where ks.knol_id=k.id; ");
            val resultSet: ResultSet = preparedStatement.executeQuery();
            if (resultSet.next() == false)
              throw new NoSuchElementException
            else {
              resultSet.previous()
              while (resultSet.next()) {
                var knol =
                  KnolManage(resultSet.getInt("id"), resultSet.getString("name"), resultSet.getString("email"), resultSet.getString("mobile"), resultSet.getInt("sessionId"), resultSet.getString("topic"), resultSet.getString("date"));
                list = list.::(knol)
              }
              list
            }
          }
          case None => list
        }
      } catch {
        case ee: Exception =>
          list
      }
    }
}
