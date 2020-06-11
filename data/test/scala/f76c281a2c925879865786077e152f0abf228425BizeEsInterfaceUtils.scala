package search.es.client.biz

import java.io.{FileInputStream, FileOutputStream}

import search.common.algorithm.impl.TrieDictionaryExpand
import search.common.cache.impl.LocalCache
import search.common.config.EsConfiguration
import search.common.entity.bizesinterface.{IndexObjEntity, QueryEntityWithCnt}
import search.common.serializer.JavaSerializer
import search.common.util.{Logging, Util}
import search.es.client.util.EsClientConf
import search.solr.client.SolrClientConf

import scala.collection.mutable
import scala.collection.mutable.ListBuffer

/**
  * Created by soledede.weng on 2016/9/20.
  */
private[search] object BizeEsInterfaceUtils extends Logging with EsConfiguration {


  /**
    * cache topics by stock code
    * Map(code->Set(topic1,topic2....)) //cache topics
    * Map(topic->Set(code1,code2...)) //cache codes
    *
    * @param sotckCodes
    * @param topic
    */
  def cacheTopicSetBystockCodeAndCachStocksByTopic(sotckCodes: mutable.Seq[String], topic: String): Unit = {
    if (sotckCodes != null && topic != null && !"".equalsIgnoreCase(topic.trim) && sotckCodes.size > 0) {

      //Map(topic->Set(code1,code2...)) //cache codes
      LocalCache.topic2StockCodesCache(topic.trim) = sotckCodes



      sotckCodes.foreach { code =>
        if (!LocalCache.codeToTopicSet.contains(code.trim)) {
          val topicSet = new mutable.HashSet[String]()
          LocalCache.codeToTopicSet(code.trim) = topicSet
        }
        LocalCache.codeToTopicSet(code.trim) += topic
        logInfo(s"cache Map(${code}-> ${topic}) success!")
      }
    }
  }

  /**
    * dump索引到磁盘
    *
    * @return
    */
  def dumpIndexToDisk(): String = {
    try {
      val cnt = BizeEsInterface.count().toInt
      val result = BizeEsInterface.matchAllQueryWithCount(0, cnt)
      val fOut = new FileOutputStream(dumpIndexPath)
      val ser = JavaSerializer(new SolrClientConf()).newInstance()
      val outputStrem = ser.serializeStream(fOut)
      outputStrem.writeObject(result)
      outputStrem.flush()
      outputStrem.close()
      val resultString = s"dump index to dis successful,size:${cnt},local path:${dumpIndexPath}"
      println(resultString)
      resultString
    } catch {
      case e: Exception => null
    }
  }

  /**
    * 从磁盘读入Trie树
    *
    * @param conf
    */
  def readDumpTrieFromDisk(conf: EsClientConf) = {
    readDumpTrieDictionaryFromDisk
    readDumpTrieGraphDictionaryFromDisk

    def readDumpTrieDictionaryFromDisk() = {
      try {
        val ser = JavaSerializer(new SolrClientConf()).newInstance()
        val fIput = new FileInputStream(dumpDictionaryPath)
        val inputStream = ser.deserializeStream(fIput)
        val obj = inputStream.readObject[TrieDictionaryExpand]()
        if (obj != null) {
          conf.dictionary = obj
        }
        inputStream.close()
      } catch {
        case fE: java.io.FileNotFoundException => logInfo("I can't read,no dump to disk")
        case e: Exception =>
          logError("read dump trie failed! dumpDictionaryPath", e)
      }
    }

    def readDumpTrieGraphDictionaryFromDisk() = {
      try {
        val ser = JavaSerializer(new SolrClientConf()).newInstance()
        val fIput = new FileInputStream(dumpGraphDictionaryPath)
        val inputStream = ser.deserializeStream(fIput)
        val obj = inputStream.readObject[TrieDictionaryExpand]()
        if (obj != null) {
          conf.graphDictionary = obj
        }
        inputStream.close()
      } catch {
        case fE: java.io.FileNotFoundException => logInfo("I can't read,no dump to disk")
        case e: Exception =>
          logError("read dump trie failed! dumpGraphDictionaryPath", e)
      }
    }

  }


  /**
    * dump Trie树到磁盘
    *
    * @param conf
    */
  def dumpTrieToDisk(conf: EsClientConf): Long = {

    dumpDictionaryToDisk
    dumpGraphDictionaryToDisk


    def dumpDictionaryToDisk() = {
      if (conf.dictionary != null) {
        try {
          val fOut = new FileOutputStream(dumpDictionaryPath)
          val ser = JavaSerializer(new SolrClientConf()).newInstance()
          val outputStrem = ser.serializeStream(fOut)
          outputStrem.writeObject(conf.dictionary)
          outputStrem.flush()
          outputStrem.close()
          val resultString = s"dump trie dictionary  to dis successful,local path:${dumpDictionaryPath}"
          println(resultString)
        } catch {
          case e: Exception =>
            logError("write dump trie failed! dumpDictionaryPath", e)
        }
      }
    }

    def dumpGraphDictionaryToDisk() = {
      if (conf.graphDictionary != null) {
        try {
          val fOut = new FileOutputStream(dumpGraphDictionaryPath)
          val ser = JavaSerializer(new SolrClientConf()).newInstance()
          val outputStrem = ser.serializeStream(fOut)
          outputStrem.writeObject(conf.graphDictionary)
          outputStrem.flush()
          outputStrem.close()
          val resultString = s"dump trie dictionary  to dis successful,local path:${dumpGraphDictionaryPath}"
          println(resultString)
        } catch {
          case e: Exception =>
            logError("write dump trie failed! dumpGraphDictionaryPath", e)
        }
      }
    }
    -1
  }

  //将公司信息写入文本文件
  def writeCompanyToDiskByText(): Unit = {
    val companyCache = LocalCache.companyStockCache
    if (companyCache != null) {
      val listString = new ListBuffer[String]
      companyCache.foreach { case (k, compy) =>
        val code = compy.getCode
        val simCom = compy.getSimPy
        val com = compy.getName
        val stringBuilder: StringBuilder = new StringBuilder
        if (simCom != null) stringBuilder.append(simCom).append("\t")
        if (code != null) stringBuilder.append(code).append("\t")
        if (com != null) stringBuilder.append(com)
        listString += stringBuilder.toString()
      }
      if (listString.size > 0) Util.writeSeqToDisk(listString, stockPath)
    }
  }

  //将主题信息写入文本文件
  def writeTopicToDiskByText(): Unit = {
    val topicCache = LocalCache.topicCache
    if (topicCache != null) {
      val listString = new ListBuffer[String]
      topicCache.foreach { case (k, topic) =>
        val topicName = topic.getName
        val stringBuilder: StringBuilder = new StringBuilder
        if (topicName != null) stringBuilder.append(topicName)
        listString += stringBuilder.toString()
      }
      if (listString.size > 0) Util.writeSeqToDisk(listString, topicPath)
    }
  }

  //将行业信息写入文本文件
  def writeIndustryToDiskByText(): Unit = {
    val industryCache = LocalCache.industryCache
    if (industryCache != null) {
      val listString = new ListBuffer[String]
      industryCache.foreach { case (k, industry) =>
        val industryName = industry.getName
        val stringBuilder: StringBuilder = new StringBuilder
        if (industryName != null) stringBuilder.append(industryName)
        listString += stringBuilder.toString()
      }
      if (listString.size > 0) Util.writeSeqToDisk(listString, industryPath)
    }
  }


}
