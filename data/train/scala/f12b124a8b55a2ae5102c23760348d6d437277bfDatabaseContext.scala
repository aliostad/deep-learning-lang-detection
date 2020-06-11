package contexts

import slick.lifted.TableQuery
import table_definitions.PrimeNumberGenerationLogTable
import slick.jdbc.MySQLProfile.api._

/**
  * Database context to manage database tables.
  */
class DatabaseContext {

  /**
    * [[TableQuery]] object enables you to make operations on `primenumbergenerationlog` table.
    */
  val primeNumberGenerationLogs = TableQuery[PrimeNumberGenerationLogTable]

  /**
    * Lazy load database which is used by current context.
    */
  lazy val database = Database.forConfig("database")

}