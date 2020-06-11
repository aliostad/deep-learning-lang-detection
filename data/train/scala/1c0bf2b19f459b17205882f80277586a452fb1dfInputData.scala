package gafis.pages


import javax.inject.Inject

import gafis.service.elasticsearch.InputDataService
import gafis.utils.CommonUtils
import org.apache.tapestry5.{RenderSupport, StreamResponse}
import org.apache.tapestry5.annotations.Environmental
import org.apache.tapestry5.services.Request
import org.apache.tapestry5.util.TextStreamResponse
import org.gafis.service.elasticsearch.{DataAccessService, ManageIndexService}
import org.gafis.utils.{Constant, JsonUtil}

/**
  * Created by yuchen on 2017/9/6.
  */
class InputData {

  @Environmental
  var renderSupport:RenderSupport = _

  @Inject
  private var request:Request= _

  @Inject
  private var inputDataService:InputDataService = _

  @Inject
  private var manageIndexService:ManageIndexService = _

  @Inject
  private var dataAccessService:DataAccessService =_

  def setupRender(): Unit = {
    renderSupport.addScript("inputdata = function(source,result){"
      + "new Ajax.Request('InputData.inputdata/' + $F(source),{"
      + "method:'POST'," + "onSuccess: function(transport){"
      + "$(result).update(transport.responseText);"
      //+"alert(transport.responseText)"
      + "}" + "});"
      + "}")
  }


  def  onActionFromInputData():StreamResponse = {
    var result = Constant.EMPTY
    if(!CommonUtils.isNullOrEmpty(request.getParameter("sql"))){

      val sql_arr = request.getParameter("sql").split(";")
      val index_name = sql_arr(1).split("FROM")(1).trim

      //TODO:初始化soo_resource
      val uuid = inputDataService.initSooResource(index_name,request.getParameter("sql"))
      //TODO:创建索引库-空库
      manageIndexService.createIndex(index_name)
      //TODO:用SQL语句进行查询，循环放到索引库
      val listResult = dataAccessService.queryGafisPersonForInputDataToIndex(sql_arr(0))
      if(listResult.size > 0){
        listResult.foreach{
          t =>
            manageIndexService.putDataToIndex(index_name,t.get("ID").get.toString,JsonUtil.mapToJSONStr(t))
            dataAccessService.updateSooResourceSeq(t.get("SEQ").get.toString.toLong,uuid)
        }
        dataAccessService.updateSooResourceFlag(uuid)
      }
    }else{
      result = "<font size=\"3\" color=\"red\">输入参数为空</font>"
    }
    new TextStreamResponse("text/html",result)
  }
}
