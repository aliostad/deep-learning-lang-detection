package core.db

import javax.inject.{Inject, Singleton}

import com.google.inject.ImplementedBy
import play.api.db.slick.DatabaseConfigProvider
import play.db.NamedDatabase

import scala.concurrent.ExecutionContext

@ImplementedBy(classOf[PgDatabaseModule])
trait DatabaseModule {
  def write: DBWithRole[CanWriteRole]
  def read: DBWithRole[CanReadRole]
  def backend: DBWithRole[CanWriteRole]
}

@Singleton
class PgDatabaseModule @Inject()(@NamedDatabase("write") writeProvider: DatabaseConfigProvider, @NamedDatabase("read") readProvider: DatabaseConfigProvider, @NamedDatabase("backend") backendProvider: DatabaseConfigProvider)(implicit ec: ExecutionContext) extends DatabaseModule {
  val write: DBWithRole[CanWriteRole] = new DBWithRole[CanWriteRole]("write", writeProvider.get[PgDriver])
  val read: DBWithRole[CanReadRole] = new DBWithRole[CanReadRole]("read", readProvider.get[PgDriver])
  val backend: DBWithRole[CanWriteRole] = new DBWithRole[CanWriteRole]("backend", backendProvider.get[PgDriver])
}
