package util

import java.sql.DriverManager

import com.typesafe.config.ConfigFactory
import org.postgresql.core.BaseConnection
import org.scalatest.{BeforeAndAfter, BeforeAndAfterAll, Suite}

import scala.concurrent.{ExecutionContext, Future}
import scala.util.Random

/**
  * Created by hsslbch on 9/9/16.
  */
trait PostgresFixture extends BaseFixture with BeforeAndAfterAll { self: Suite =>

  override def afterAll(): Unit = {
    super.afterAll()
    if (manageConnectionIsOpened) {
      manageConnection.close()
    }
  }

  private val config = ConfigFactory.load().getConfig("postgres")
  private val url = config.getString("url")
  private val username = config.getString("username")
  private val password = config.getString("password")

  private var manageConnectionIsOpened = false
  private lazy val manageConnection = {
    manageConnectionIsOpened = true
    DriverManager.getConnection(url, username, password)
  }

  def withPostgres[T](fixtureName: String)
                     (testCode: BaseConnection => Future[T]): Future[T] = {
    val dbName = "test_" + Random.alphanumeric.take(6).mkString.toLowerCase()
    manageConnection.createStatement().execute(s"CREATE DATABASE $dbName;")

    val conn = DriverManager.getConnection(url + dbName, username, password).asInstanceOf[BaseConnection]
    conn.createStatement().execute(Resource.read(s"/fixtures/$fixtureName.sql"))

    withOneArg(conn)(testCode) {
      conn.close()
      manageConnection.createStatement().execute(s"DROP DATABASE $dbName")
    }
  }
}
