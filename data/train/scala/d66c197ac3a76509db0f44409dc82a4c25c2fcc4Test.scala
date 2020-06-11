package com.gendata.kernel.db

import com.gendata.common.enums.DatabaseType
import com.gendata.kernel.owl.OwlBuilder

object Test extends App{

  override def main(args:Array[String]) = {
    val databaseName = "muumedb"
    val engine = DatabaseEngineFactory.getDatabaseEngine(DatabaseType.MYSQL).get
    val dataSource = engine.config(databaseName, "root", "12345678", s"jdbc:mysql://127.0.0.1:3306/$databaseName")
    val dump = new DatabaseDumper(dataSource)
    val db = dump.readDatabase(databaseName)
    dump.writeDatabase(db, s"/home/isajin/$databaseName.xml")
    val model = dump.copy(db)
    new OwlBuilder().convert(model, s"/home/isajin/protege/$databaseName.owl")
  }
}
