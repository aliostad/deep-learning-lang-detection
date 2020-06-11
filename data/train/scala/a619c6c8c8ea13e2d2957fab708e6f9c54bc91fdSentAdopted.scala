package org.opensplice.mobile.dev.paxos.event

import org.opensplice.mobile.dev.paxos.StatePaxosData
import java.util.UUID

case class SentAdopted(override val instanceId: String, key: Long, sn: Int, proposer: UUID, epoch: Int, value: Option[StatePaxosData], oldSn: Int, oldProposer: UUID) extends PaxosEvent(instanceId) {
  override def toString(): String = {
    "[%d] Sent Adopted for serial number %d, proposer id %s and epoch %d, last accepted value for this epoch is %s with serial number %d, proposer %s".
      format(key, sn, toShortString(proposer), epoch, value, oldSn, toShortString(oldProposer))
  }
}