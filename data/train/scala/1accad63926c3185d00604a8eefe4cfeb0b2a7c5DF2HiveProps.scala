package pub.ayada.scala.sparkUtils.etl.write.hive

/**
  * DF2HiveProps(id : String, srcDF : String, var loadType : String, schema : String, table : String, preLoadCount : Boolean, postLoadCount : Boolean)
  */
case class DF2HiveProps(taskType : String = "DF2Hive",
                        id : String,
                        srcDF : String,
                        var loadType : String,
                        schema : String,
                        table : String,
                        format : String,
                        partitionColumns : Array[String],
                        preLoadCount : Boolean,
                        postLoadCount : Boolean) extends pub.ayada.scala.sparkUtils.etl.write.WriteProps {

    override def toString() : String = new StringBuilder()
        .append("DF2HiveProps(")
        .append("id ->").append(id)
        .append("srcDF ->").append(srcDF)
        .append(", loadType ->").append(loadType)
        .append(", schema ->").append(schema)
        .append(", table ->").append(table)
        .append(", format ->").append(format)
        .append(", preLoadCount ->").append(preLoadCount)
        .append(", postLoadCount ->").append(postLoadCount)
        .append(", partitionColumns ->").append(partitionColumns.mkString("[", ",", "]"))
        .append(")").toString
}
