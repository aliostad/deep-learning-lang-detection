package gafis.pages

import javax.inject.Inject

import gafis.utils.CommonUtils
import org.apache.tapestry5.json.{JSONObject}
import org.apache.tapestry5.services.{Request, Response}
import org.apache.tapestry5.util.TextStreamResponse
import org.gafis.service.elasticsearch.ManageIndexService

/**
  * Created by yuchen on 2017/8/30.
  */
class IndexApi {
  @Inject
  private var request:Request= _

  @Inject
  private var manageIndexService:ManageIndexService = _

  @Inject
  private var response:Response= _

  def onActivate = {

    val jSONObject = new JSONObject()
    try{
      val operType = request.getParameter("type")
      val index = request.getParameter("index")
      if(!CommonUtils.isNullOrEmpty(operType) && !CommonUtils.isNullOrEmpty(index)){
        operType match{
          case "createindex" =>
            manageIndexService.createIndex(request.getParameter("index"))
            jSONObject.put("success",true)
            jSONObject.put("message","OK")
          case "deleteindex" =>
            manageIndexService.deleteIndex(request.getParameter("index"))
            jSONObject.put("success",true)
            jSONObject.put("message","OK")
          case "searchindex" =>
            val result = manageIndexService.searchIndex(request.getParameter("index"))
            jSONObject.put("success",true)
            jSONObject.put("message","OK")
            jSONObject.put("result",result)
        }
      }else{
        throw new Exception("param is null or empty")
      }

    }catch{
      case ex:Exception =>
        jSONObject.put("success",false)
        jSONObject.put("message",ex.getMessage)
    }

    response.setHeader("Access-Control-Allow-Origin","*")
    response.setHeader("Access-Control-Allow-Headers","X-Requested-With,Content-Type,X-Hall-Request")
    new TextStreamResponse("text/plain", jSONObject.toString)
  }
}
