package services

import com.google.inject.ImplementedBy

import jp.co.bizreach.elasticsearch4s._

import models.Uservector
import org.elasticsearch.index.query.QueryBuilders

import org.elasticsearch.search.sort.SortOrder

import scala.concurrent._
import scala.concurrent.ExecutionContext.Implicits.global



import scala.concurrent.Future

/**
 * Created by kyota.yasuda on 15/08/19.
 */
@ImplementedBy(classOf[ManageUservectorWithElasticsearchService])
trait ManageUservectorService {
  def insertUservector(uservector: Uservector): Future[Any]
}

class ManageUservectorWithElasticsearchService extends ManageUservectorService with ManageElasticsearch {

  def config = ESConfig("nekomimi", "uservector")

  def insertUservector(uservector: Uservector): Future[Any] = {
    AsyncESClient.apply(serverUrl).insertAsync(config, uservector)
  }
}
