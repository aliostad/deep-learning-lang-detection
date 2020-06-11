package org.showgregator.service.model

import com.datastax.driver.core.Row
import com.websudos.phantom.CassandraTable
import com.websudos.phantom.Implicits.{BooleanColumn, StringColumn, UUIDColumn, UUID}
import com.websudos.phantom.keys.PartitionKey

case class PendingEmailChange(id: UUID,
                              newToken: UUID,
                              newEmail: String,
                              newVerified: Boolean,
                              oldToken: UUID,
                              oldEmail: String,
                              oldVerified: Boolean)

sealed class PendingEmailChangeRecord extends CassandraTable[PendingEmailChangeRecord, PendingEmailChange] {
  object id extends UUIDColumn(this) with PartitionKey[UUID]
  object newToken extends UUIDColumn(this)
  object newEmail extends StringColumn(this)
  object newVerified extends BooleanColumn(this)
  object oldToken extends UUIDColumn(this)
  object oldEmail extends StringColumn(this)
  object oldVerified extends BooleanColumn(this)

  override def fromRow(r: Row): PendingEmailChange = PendingEmailChange(id(r),
    newToken(r), newEmail(r), newVerified(r), oldToken(r), oldEmail(r), oldVerified(r))
}

object PendingEmailChangeRecord extends PendingEmailChangeRecord with Connector {
  override val tableName: String = "pending_email_changes"
}

case class OldUserPendingEmailChange(oldToken: UUID, user: UUID)

sealed class OldUserPendingEmailChangeRecord extends CassandraTable[OldUserPendingEmailChangeRecord, OldUserPendingEmailChange] {
  object oldToken extends UUIDColumn(this) with PartitionKey[UUID]
  object user extends UUIDColumn(this)

  override def fromRow(r: Row): OldUserPendingEmailChange = OldUserPendingEmailChange(oldToken(r), user(r))
}

object OldUserPendingEmailChangeRecord extends OldUserPendingEmailChangeRecord with Connector {
  override val tableName: String = "old_user_pending_email_changes"
}

case class NewUserPendingEmailChange(newToken: UUID, user: UUID)

sealed class NewUserPendingEmailChangeRecord extends CassandraTable[NewUserPendingEmailChangeRecord, NewUserPendingEmailChange] {
  object newToken extends UUIDColumn(this) with PartitionKey[UUID]
  object user extends UUIDColumn(this)

  override def fromRow(r: Row): NewUserPendingEmailChange = NewUserPendingEmailChange(newToken(r), user(r))
}

object NewUserPendingEmailChangeRecord extends NewUserPendingEmailChangeRecord with Connector {
  override val tableName: String = "new_user_pending_email_changes"
}