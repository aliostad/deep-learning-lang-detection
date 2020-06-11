package org.gafis.service.elasticsearch

/**
  * Created by yuchen on 2017/8/25.
  *    用于在elasticsearch中建立索引库使用。在elasticsearch中，index代表一个库。
  * 该索引库中存在一张我们自定义名称的表，表中的每一行代表一个文档。
  * 具体方法包括创建更新索引、删除索引
  */
trait ManageIndexService {

    def createIndex(indexName:String):Unit

    def putDataToIndex(indexName: String,id:String,jsonStr: String): Unit

    def deleteIndex(indexName:String): Unit

    def searchIndex(indexName:String):String

    def query(indexName:String,jsonStr:String):Unit

    def updateDataToIndex(indexName: String,id:String,jsonStr: String):Unit
}
