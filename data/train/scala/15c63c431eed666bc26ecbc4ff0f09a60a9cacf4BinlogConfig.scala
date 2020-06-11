package com.yinker.tinyv.manager

import com.yinker.tinyv.utils.LoadConfigInfo

/**
  * description: 获取kafka相关配置
  * user: angelo.liu 
  * date: 2017/6/13 18:34
  *
  */
object BinlogConfig {

  object kafkaConfig{
    val kafkaGroupId = LoadConfigInfo.getProperty("group.id")
    val zkHosts = LoadConfigInfo.getProperty("zookeeper.connect")
    val brokerList = LoadConfigInfo.getProperty("metadata.broker.list")
    val message_max_bytes = LoadConfigInfo.getProperty("fetch.message.max.bytes")
    val topics = LoadConfigInfo.getProperty("kafkaTopics").split(",")
  }

  object sparkConfig{
    val seconds = LoadConfigInfo.getProperty("seconds").toInt
  }

  object esConfig{
    val esCluster = LoadConfigInfo.getProperty("es.cluster")
    val esServers = LoadConfigInfo.getProperty("es.server")
    val esIndexName = LoadConfigInfo.getProperty("es.indexName").split(",")
    val esIndexType = LoadConfigInfo.getProperty("es.indexType").split(",")
  }

}
