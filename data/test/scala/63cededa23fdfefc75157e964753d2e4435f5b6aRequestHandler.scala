package com.wbport.admin

import com.walbrix.spring.mvc.Result
import com.walbrix.spring.{VelocitySupport, ScalikeJdbcSupport, EmailSupport}
import com.wbport.LogDAO
import org.springframework.stereotype.Controller
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.{RequestBody, ResponseBody, RequestMethod, RequestMapping}

/**
 * Created by shimarin on 14/11/14.
 */

case class Recipient(
  email:String,
  variables:Option[Map[String,String]]
)

case class BulkMail(
  subject:String,
  body:String,
  from:String,
  fromName:Option[String],
  recipients:Seq[Recipient]
)

@Controller
@Transactional
@RequestMapping(Array(""))
class RequestHandler extends ScalikeJdbcSupport with EmailSupport with LogDAO with VelocitySupport {
  val defaultDumpFile = "/tmp/wbport-dump.sql"

  @RequestMapping(value=Array("dump"), method = Array(RequestMethod.POST))
  @ResponseBody
  def dump(@RequestBody json:Map[String,AnyRef]):Result[Nothing] = {
    val dumpFile = json.get("file").getOrElse(defaultDumpFile)
    val rst = apply(sql"script to ${dumpFile}".execute())
    Result(rst)
  }

  @RequestMapping(value=Array("dump"), method = Array(RequestMethod.GET))
  @ResponseBody
  def dump():Result[Nothing] = {
    val dumpFile = defaultDumpFile
    val rst = apply(sql"script to ${dumpFile}".execute())
    Result(rst)
  }

  @RequestMapping(value=Array("bulk-mail"), method=Array(RequestMethod.POST))
  @ResponseBody
  def bulkMail(@RequestBody json:BulkMail):Result[Map[String,Int]] = {
    val sender = createMailSender()
    var success = 0
    var fail = 0
    json.recipients.foreach { recipient =>
      val message = sender.createJisMailMessage
      json.fromName match {
        case Some(fromName) => message.setFrom(json.from, fromName)
        case _ => message.setFrom(json.from)
      }
      message.setTo(recipient.email)
      val variables = recipient.variables.getOrElse(Map())
      val subject = evaluate(json.subject, variables)
      message.setSubject(subject)
      message.setText(evaluate(json.body, variables))
      try {
        sender.send(message)
        createMailLog(recipient.email, Some(subject), true)
        success += 1
      }
      catch {
        case e:Exception =>
          createMailLog(recipient.email, Some(subject), false, Some(e.getMessage))
          fail += 1
      }
    }

    Result(fail == 0, Some(Map("success"->success, "fail"->fail)))
  }

}
