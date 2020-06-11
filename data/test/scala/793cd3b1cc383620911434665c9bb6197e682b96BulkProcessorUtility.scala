package org.allenai.common.indexing

import org.allenai.common.Logging
import BuildCorpusIndex.indexWithoutDuplicate

import com.typesafe.config.Config
import org.elasticsearch.action.bulk.{ BulkResponse, BulkProcessor, BulkRequest }
import org.elasticsearch.action.index.IndexRequest
import org.elasticsearch.client.transport.TransportClient
import org.elasticsearch.common.io.stream.{ InputStreamStreamInput, OutputStreamStreamOutput }
import org.elasticsearch.common.unit.{ TimeValue, ByteSizeUnit, ByteSizeValue }

import scala.collection.JavaConverters._
import scala.util.Random
import java.io.{ FileInputStream, FileOutputStream }
import java.util.concurrent.ConcurrentLinkedQueue

/** Factory for elasticsearch BulkProcessor.
  */
class BulkProcessorUtility extends Logging {

  private val failedRequests: ConcurrentLinkedQueue[BulkRequest] =
    new ConcurrentLinkedQueue[BulkRequest]()

  /** Builds a bulk processor, with listener configured with nice behavior on fail: dump to fail
    * and save failed requests to a sequence to be retried later.
    * @param esClient TransportClient with which to send requests to the elasticsearch server
    * @param dumpFilePath path to dump files to
    * @return The contructed bulk processor
    */
  def buildDumpOnErrorBulkProcessor(
    esClient: TransportClient,
    dumpFilePath: String
  ): BulkProcessor = {
    BulkProcessor.builder(
      esClient,
      new BulkProcessor.Listener() {
        override def afterBulk(executionId: Long, request: BulkRequest,
          failure: Throwable): Unit = {
          logger.warn(s"${failure.getMessage}, retrying later")
          dumpRequestToFile(request, dumpFilePath)
          failedRequests.add(request)
        }
        override def beforeBulk(l: Long, bulkRequest: BulkRequest): Unit = {}
        override def afterBulk(l: Long, bulkRequest: BulkRequest,
          bulkResponse: BulkResponse): Unit = {}
      }
    )
      .setBulkActions(10000)
      .setBulkSize(new ByteSizeValue(1, ByteSizeUnit.GB))
      .setFlushInterval(TimeValue.timeValueSeconds(600))
      .setConcurrentRequests(1)
      .build()
  }

  /** Serialize a request and save to file.
    * @param request failed bulk request
    * @param dumpFilePath path to dump folder
    */
  def dumpRequestToFile(request: BulkRequest, dumpFilePath: String): Unit = {
    val outStream = new OutputStreamStreamOutput(new FileOutputStream(
      dumpFilePath + "/" + randomRequestFileName()
    ))
    request.writeTo(outStream)
    outStream.close()
  }

  /** Method for retrying failed request.
    * @param dumpFilePath path to dumped request
    * @param esConfig configuration of elasticsearch index for which request should be executed
    */
  def retryDumpedRequest(dumpFilePath: String, esConfig: Config, indexName: String): Unit = {
    val bulkRequest = new BulkRequest
    bulkRequest.readFrom(new InputStreamStreamInput(new FileInputStream(dumpFilePath)))
    val esClient = ElasticSearchTransportClientUtil.ConstructTransportClientFromESconfig(esConfig)
    for (request <- bulkRequest.requests().asScala) {
      indexWithoutDuplicate(request.asInstanceOf[IndexRequest], esClient, indexName)
    }
    esClient.close()
  }

  /** Utility method for generating random file name.
    * @return random file name
    */
  def randomRequestFileName(): String = {
    "request_" + Random.alphanumeric.take(10).mkString + ".txt"
  }

  /** Get list of bulk requests that failed.*/
  def getFailedRequests(): List[BulkRequest] = {
    failedRequests.asScala.toList
  }

}
