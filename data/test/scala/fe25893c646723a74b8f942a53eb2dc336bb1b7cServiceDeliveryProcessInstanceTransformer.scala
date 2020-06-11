package uk.gov..mi.stream.servicedelivery

import org.joda.time.format.ISODateTimeFormat
import org.joda.time.{DateTime, DateTimeZone}
import uk.gov..mi.DateHelper
import uk.gov..mi.model.SServiceDeliveryProcessInstance
import uk.gov..mi.model.servicedelivery.{ProcessInstance, ServiceDelivery}
import uk.gov..mi.stream.HashHelper._


object ServiceDeliveryProcessInstanceTransformer {

  def processInstances(messageId: String, serviceDelivery: ServiceDelivery, timestamp: Long): List[SServiceDeliveryProcessInstance] = {
    val source = ""
    val fmt = ISODateTimeFormat.dateTime()
    val time = new DateTime(timestamp, DateTimeZone.UTC)

    val process_list_agg_str = processInstanceSetStr(serviceDelivery.processInstances)
    val process_inst_list_agg_hash = sha1(process_list_agg_str)
    val lnk_srvcdlvry_prc_inst_list_hk = sha1(List(("record_source", source), ("srvc_dlvry_handle_id", serviceDelivery.internalHandle.interface_identifier)) ++ process_list_agg_str)
    val srvc_dlvry_hk = sha1(Seq(("record_source", source), ("srvc_dlvry_handle_id", serviceDelivery.internalHandle.interface_identifier)))

    serviceDelivery.processInstances.sorted.zipWithIndex.map { case (processInstance: ProcessInstance, i: Int) =>
      val rec_hash_value = sha1(processInstanceStr(processInstance))
      SServiceDeliveryProcessInstance(messageId, DateHelper.getMostRecentDate(List(serviceDelivery.created, serviceDelivery.createdDate, serviceDelivery.lastUpdated)), fmt.print(time),
        source, serviceDelivery.internalHandle.interface_identifier, processInstance.id,
        i, rec_hash_value, processInstance.processId,
        processInstance.processStatusCode, processInstance.stageCode, processInstance.startDateTime,
        processInstance.endDateTime, process_inst_list_agg_hash, lnk_srvcdlvry_prc_inst_list_hk,
        srvc_dlvry_hk)
    }
  }

  def processInstanceStr(processInstance: ProcessInstance): List[(String, String)] = {
    List(
      ("process_id", processInstance.processId.toString),
      ("process_inst_status_cd", processInstance.processStatusCode),
      ("process_inst_stage_cd", processInstance.stageCode),
      ("process_inst_start_datetime", processInstance.startDateTime.getOrElse("")),
      ("process_inst_end_datetime", processInstance.endDateTime.getOrElse(""))
    )
  }

  def processInstanceSetStr(processInstances: List[ProcessInstance]): List[(String, String)] = {
    processInstances.sorted.flatMap(processInstance =>
      List(("process_inst_handle_id", processInstance.id.toString)) ++ processInstanceStr(processInstance))
  }
}
