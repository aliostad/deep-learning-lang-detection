package org.opensplice.mobile.dev.paxos.event

import org.opensplice.mobile.dev.paxos.StatePaxosData
import java.util.UUID

case class ReceivedAdopted(override val instanceId: String, key: Long, acceptor: UUID, sn: Int, proposer: UUID, epoch: Int, value: Option[StatePaxosData], oldSn: Int, oldProposer: UUID) extends PaxosEvent(instanceId) {
  override def toString(): String = {
    "[%d] Received Adopted from %s for serial number %d, proposer id %s and epoch %d, last accepted value for this epoch is %s with serial number %d, proposer %s".
      format(key, acceptor, sn, toShortString(proposer), epoch, value, oldSn, toShortString(oldProposer))
  }
}