// Copyright 2016 the original author or authors. All rights reserved.
// site: http://www.ganshane.com
/**
 * Copyright (c) 2015 Jun Tsai <jcai@ganshane.com>
 */

package stark.migration

/**
 * schema dumper
 * 支持表、主键、索引、注释、序列的导出
 * 尚不能支持
 * 存储过程、触发器
 * @author <a href="mailto:jcai@ganshane.com">Jun Tsai</a>
 * @since 2015-07-28
 */
object SchemaDumper {
  def main(args:Array[String]): Unit ={
    val driver = "oracle.jdbc.driver.OracleDriver"
    val url = System.getProperty("dump.jdbc.url")
    val user = System.getProperty("dump.jdbc.user")
    val pass = System.getProperty("dump.jdbc.pass")
    val schema = System.getProperty("dump.jdbc.schema")

    Class.forName(driver)
    val vendor = Vendor.forDriver(driver)
    val connectionBuilder = new ConnectionBuilder(url, user, pass)
    val databaseAdapter = DatabaseAdapter.forVendor(vendor,Option(schema))
    implicit val sb = new StringBuilder
    val migrator = new Migrator(connectionBuilder,databaseAdapter)
    migrator.dumpHead()

    migrator.tables()
      .foreach(migrator.dumpTable)
    migrator.sequences().foreach(migrator.dumpSequence)

    migrator.dumpMiddle()

    migrator.tables().reverse.foreach(migrator.dumpDropTable)
    migrator.sequences().reverse.foreach(migrator.dumpDropSequence)

    migrator.dumpFooter()

    println(sb)
  }
}
