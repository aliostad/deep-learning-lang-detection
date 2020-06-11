package com.yinker.tinyv.utils

import java.util.Properties

object YKConfig {
  
  object kafkaConfig{
    val kafkaGroupId = LoadConfig.getProperty("group.id")
    val zkHosts=LoadConfig.getProperty("zookeeper.connect")
    val brokerList = LoadConfig.getProperty("metadata.broker.list")
    val message_max_bytes = LoadConfig.getProperty("fetch.message.max.bytes")
    val appTopic = LoadConfig.getProperty("kafkaAppTopic")
    val h5Topic = LoadConfig.getProperty("kafkaH5Topic")
  }
  object jdbcConfig{
    val url=LoadConfig.getProperty("url")
    val username = LoadConfig.getProperty("username")
    val password = LoadConfig.getProperty("password")
    val driver =  LoadConfig.getProperty("com.mysql.jdbc.Driver")
    val sqlsTable =  LoadConfig.getProperty("sqlsTable")
  }
  object sparkConfig{
    val seconds = LoadConfig.getProperty("seconds").toLong
    val appDir = LoadConfig.getProperty("appDir")
    val h5Dir = LoadConfig.getProperty("h5Dir")
  }
  
}