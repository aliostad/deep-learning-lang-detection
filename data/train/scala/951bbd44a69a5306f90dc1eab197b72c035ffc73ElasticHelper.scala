package com.github.sonenko.elastichelper
package helper

import com.sksamuel.elastic4s.ElasticClient
import com.sksamuel.elastic4s.ElasticDsl.{RichFuture, _}
import com.sksamuel.elastic4s.mappings.TypedFieldDefinition
import com.sksamuel.elastic4s.source.DocumentMap
import org.elasticsearch.action.admin.indices.create.CreateIndexResponse
import org.elasticsearch.action.admin.indices.delete.DeleteIndexResponse
import org.elasticsearch.action.index.IndexResponse
import org.elasticsearch.action.search.SearchResponse
import spray.json._
import scala.concurrent
import scala.concurrent.ExecutionContext.Implicits.global
import org.joda.time.DateTime


import com.github.sonenko.elastichelper.helper.json._
import com.github.sonenko.elastichelper.helper.json.HelperJsonProtocol._

import scala.concurrent.duration.Duration

class ElasticHelper(val client: ElasticClient) {
  import ElasticHelper._

  def createIndex(indexName: String, mapping: Map[String, List[TypedFieldDefinition]] = Map()): RichFuture[CreateIndexResponse] = {
    client execute {
      create index indexName mappings (mapping.map{ case (key, valueList) =>
        key as (valueList:_*)
      }.toList:_*)
    }
  }

  def isIndexExists(indexName: String): RichFuture[Boolean] =
    client.exists(indexName).map(_.isExists)

  def deleteIndex(indexName: String): RichFuture[DeleteIndexResponse] =
    client execute {
      delete index indexName
    }

  def insert(indexName: String, dirName: String, data: DocumentMap): RichFuture[IndexResponse] = {
    client execute {
      index into indexName -> dirName doc data
    }
  }

  def list[T: JsonFormat](indexName: String, dirName: String, offset: Int = 0, count: Int = Int.MaxValue): RichFuture[List[T]] = {
    val res = client execute {
      search in indexName -> dirName start offset limit count
    }
    res.map(searchResponseToCaseClass[T])
  }


  def dump(dumpName: String): Unit = {
    client.refresh().await
    client.execute {
      repository create dumpDir `type` "fs" settings Map("location" -> dumpsLocation, "compress" -> "true")
    }.await
    client.refresh().await

    client.execute {
      snapshot create dumpName in dumpDir waitForCompletion true
    }.await
    client.refresh().await
  }

  def restoreDump(dumpName: String, indexName: String): Unit = {
    client.execute {
      snapshot restore dumpName from dumpDir index indexName
    }.await
  }

  def waitForRefresh(indexes: String*): Unit = {
    client.refresh(indexes: _*).await(Duration(10, concurrent.duration.SECONDS))
  }
}


object ElasticHelper {

  val dumpDir = "dumpDir"
  val dumpsLocation = Config.dumpsLocation

  def searchResponseToResult[T: JsonFormat](res: SearchResponse): Search.Result[T] =
    res.toString.parseJson.convertTo[Search.Result[T]]

  def searchResponseToCaseClass[T: JsonFormat](res: SearchResponse): List[T] =
    searchResponseToResult[T](res).hits.hits.map(_._source)
}





