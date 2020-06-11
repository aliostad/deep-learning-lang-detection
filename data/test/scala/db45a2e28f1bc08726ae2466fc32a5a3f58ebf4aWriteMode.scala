package org.embulk.output.couchbase

import com.couchbase.client.java.Bucket
import com.couchbase.client.java.document.Document
import org.embulk.config.ConfigException

sealed abstract class WriteMode(val value: String) {
  def write[A <: Document[_]](bucket: Bucket, document: A): A
}

object WriteMode {

  def of(value: String): WriteMode = value match {
    case Insert.value => Insert
    case Upsert.value => Upsert
    case v =>
      val validModes = WriteMode.values.map(_.value).mkString(", ")
      throw new ConfigException(s"Unknown write_mode '$v'. Supported write_mode are $validModes")
  }

  case object Insert extends WriteMode("insert") {
    override def write[A <: Document[_]](bucket: Bucket, document: A): A = {
      bucket.insert(document)
    }
  }

  case object Upsert extends WriteMode("upsert") {
    override def write[A <: Document[_]](bucket: Bucket, document: A): A = {
      bucket.upsert(document)
    }
  }

  val values: Set[WriteMode] = Set(Insert, Upsert)
}
