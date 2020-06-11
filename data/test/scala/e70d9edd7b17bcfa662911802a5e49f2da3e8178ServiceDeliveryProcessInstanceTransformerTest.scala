package uk.gov..mi.stream.servicedelivery

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.{FlatSpec, Inside, Matchers}
import uk.gov..mi.model.SServiceDeliveryProcessInstance
import uk.gov..mi.model.servicedelivery.ProcessInstance
import uk.gov..mi.stream.HashHelper.emptyHash


@RunWith(classOf[JUnitRunner])
class ServiceDeliveryProcessInstanceTransformerTest extends FlatSpec with Matchers with Inside {

  "Service delivery process Instance " should "return list process instances" in {
    val serviceDelivery = ServiceDeliveryHelper.serviceDelivery("RandomId")

    val actualProcessInstances = ServiceDeliveryProcessInstanceTransformer.processInstances("messageId", serviceDelivery, System.currentTimeMillis())

    actualProcessInstances should have size serviceDelivery.processInstances.size

    inside(actualProcessInstances.head) {
      case SServiceDeliveryProcessInstance(_, _, _,
      _, srvc_dlvry_handle_id, process_inst_id,
      rec_seqno, rec_hash_value, process_id,
      process_inst_status_cd, process_inst_stage_cd, start_date,
      end_date, process_inst_list_agg_hash, lnk_srvcdlvry_prc_inst_list_hk,
      srvc_dlvry_hk) =>
        srvc_dlvry_handle_id should equal(serviceDelivery.internalHandle.interface_identifier)
        val expectedProcessInstance: ProcessInstance = serviceDelivery.processInstances.sorted.head
        process_inst_id should equal(expectedProcessInstance.id)
        rec_seqno should equal(0)
        rec_hash_value should not equal emptyHash
        process_id should equal(expectedProcessInstance.processId)
        process_inst_status_cd should equal(expectedProcessInstance.processStatusCode)
        process_inst_stage_cd should equal(expectedProcessInstance.stageCode)
        start_date should equal(expectedProcessInstance.startDateTime)
        end_date should equal(expectedProcessInstance.endDateTime)
        process_inst_list_agg_hash should not equal emptyHash
        lnk_srvcdlvry_prc_inst_list_hk should not equal emptyHash
        srvc_dlvry_hk should not equal emptyHash
    }
  }
}
