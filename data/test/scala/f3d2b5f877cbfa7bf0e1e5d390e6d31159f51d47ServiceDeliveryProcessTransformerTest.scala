package uk.gov..mi.stream.servicedelivery

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.{FlatSpec, Inside, Matchers}
import uk.gov..mi.model.SServiceDeliveryProcess
import uk.gov..mi.model.servicedelivery.ServiceDeliveryProcess
import uk.gov..mi.stream.HashHelper._

@RunWith(classOf[JUnitRunner])
class ServiceDeliveryProcessTransformerTest extends FlatSpec with Matchers with Inside {

  "Service delivery process" should "return list process" in {
    val serviceDelivery = ServiceDeliveryHelper.serviceDelivery("RandomId")

    val actualProcesses = ServiceDeliveryProcessTransformer.process("messageId", serviceDelivery, System.currentTimeMillis())

    actualProcesses should have size serviceDelivery.serviceDeliveryProcesses.size

    inside(actualProcesses.head) {
      case SServiceDeliveryProcess(_, _, _,
      _, srvc_dlvry_handle_id, process_handle_id,
      rec_seqno, rec_hash_value, process_handle_visibility,
      srvc_dlvry_stage_cd, process_status_cd, process_created_by,
      process_created_datetime, process_last_updated_by, process_last_updated_datetime,
      process_created2_datetime, process_list_agg_hash, lnk_srvcdlvry_prc_list_hk,
      srvc_dlvry_hk) =>
        srvc_dlvry_handle_id should equal(serviceDelivery.internalHandle.interface_identifier)
        val expectedProcess: ServiceDeliveryProcess = serviceDelivery.serviceDeliveryProcesses.sorted.head
        process_handle_id should equal(expectedProcess.internalHandle.interface_identifier)
        rec_seqno should equal(0)
        rec_hash_value should not equal emptyHash
        process_handle_visibility should equal(expectedProcess.internalHandle.visibility_marker)
        srvc_dlvry_stage_cd should equal(expectedProcess.serviceDeliveryStage.refDataValueCode)
        process_status_cd should equal(expectedProcess.processStatus.refDataValueCode)
        process_created_by should equal(expectedProcess.createdUserId)
        process_created_datetime should equal(expectedProcess.created)
        process_last_updated_by should equal(expectedProcess.lastUpdatedUserId)
        process_last_updated_datetime should equal(expectedProcess.lastUpdated)
        process_created2_datetime should equal(expectedProcess.createdDate)
        process_list_agg_hash should not equal emptyHash
        lnk_srvcdlvry_prc_list_hk should not equal emptyHash
        srvc_dlvry_hk should not equal emptyHash
    }
  }

}
