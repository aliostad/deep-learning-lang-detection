package pub.ayada.scala.sparkUtils.etl.write.parquet

case class DF2ParquetProps(taskType : String = "DF2Parquet",
                           id : String,
                           srcDF : String,
                           var loadType : String,
                           fileDir : String,
                           partitionColumns : Array[String],
                           preLoadCount : Boolean,
                           postLoadCount : Boolean) extends pub.ayada.scala.sparkUtils.etl.write.WriteProps {
    override def toString() : String = new StringBuilder()
        .append("DF2ParquetProps(")
        .append("id ->").append(id)
        .append(", srcDF ->").append(srcDF)
        .append(", loadType ->").append(loadType)
        .append(", fileDir ->").append(fileDir)
        .append(", preLoadCount ->").append(preLoadCount)
        .append(", postLoadCount ->").append(postLoadCount)
        .append(", partitionColumns ->").append(partitionColumns.mkString("[", ",", "]"))
        .append(")").toString
}
