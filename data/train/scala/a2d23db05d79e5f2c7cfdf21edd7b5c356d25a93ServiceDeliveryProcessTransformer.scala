package uk.gov..mi.stream.servicedelivery

import org.joda.time.format.ISODateTimeFormat
import org.joda.time.{DateTime, DateTimeZone}
import uk.gov..mi.DateHelper
import uk.gov..mi.model.SServiceDeliveryProcess
import uk.gov..mi.model.servicedelivery.{ServiceDelivery, ServiceDeliveryProcess}
import uk.gov..mi.stream.HashHelper
import uk.gov..mi.stream.HashHelper._


object ServiceDeliveryProcessTransformer {

  def process(messageId: String, serviceDelivery: ServiceDelivery, timestamp: Long): List[SServiceDeliveryProcess] = {
    val source = ""
    val fmt = ISODateTimeFormat.dateTime()
    val time = new DateTime(timestamp, DateTimeZone.UTC)

    val process_list_agg_str = processSetStr(serviceDelivery.serviceDeliveryProcesses)
    val process_list_agg_hash = HashHelper.sha1(process_list_agg_str)
    val lnk_srvcdlvry_prc_list_hk = HashHelper.sha1(List(("record_source", source), ("srvc_dlvry_handle_id", serviceDelivery.internalHandle.interface_identifier)) ++ process_list_agg_str)
    val srvc_dlvry_hk = sha1(Seq(("record_source", source), ("srvc_dlvry_handle_id", serviceDelivery.internalHandle.interface_identifier)))

    serviceDelivery.serviceDeliveryProcesses.sorted.zipWithIndex.map { case (process: ServiceDeliveryProcess, i: Int) =>
      val rec_hash_value = HashHelper.sha1(processStr(process))

      SServiceDeliveryProcess(messageId, DateHelper.getMostRecentDate(List(serviceDelivery.created, serviceDelivery.createdDate, serviceDelivery.lastUpdated)), fmt.print(time),
        source, serviceDelivery.internalHandle.interface_identifier, process.internalHandle.interface_identifier,
        i, rec_hash_value, process.internalHandle.visibility_marker,
        process.serviceDeliveryStage.refDataValueCode, process.processStatus.refDataValueCode, process.createdUserId,
        process.created, process.lastUpdatedUserId, process.lastUpdated,
        process.createdDate, process_list_agg_hash, lnk_srvcdlvry_prc_list_hk,
        srvc_dlvry_hk)
    }
  }

  def processSetStr(process: List[ServiceDeliveryProcess]): List[(String, String)] = {
    process.sorted.flatMap(process =>
      List(("process_handle_id", process.internalHandle.interface_identifier)) ++ processStr(process))
  }


  def processStr(process: ServiceDeliveryProcess): List[(String, String)] = {
    List(
      ("process_handle_visibility", process.internalHandle.visibility_marker.getOrElse("")),
      ("srvc_dlvry_stage_cd", process.serviceDeliveryStage.refDataValueCode),
      ("process_status_cd", process.processStatus.refDataValueCode),
      ("process_created_by", process.createdUserId.getOrElse("")),
      ("process_created_datetime", process.created.getOrElse("")),
      ("process_last_updated_by", process.lastUpdatedUserId.getOrElse("")),
      ("process_last_updated_datetime", process.lastUpdatedUserId.getOrElse(""))
    )
  }
}
