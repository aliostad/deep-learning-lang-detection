case class Transaction()

case class ReadTransaction()

case class ReadWriteTransaction()

case class ReadBatchTransaction()

case class ReadWriteBatchTransaction()

trait LowPriorityImplicit {
}

object Implicits extends LowPriorityImplicit {
  implicit val read = new (ReadTransaction <-< Transaction) {}

  implicit val readWrite = new (ReadWriteTransaction <-< ReadTransaction) {}

  implicit val readBatch = new (ReadBatchTransaction <-< ReadTransaction) {}

  implicit val readWriteBatch1 = new (ReadWriteBatchTransaction <-< ReadWriteTransaction) {}

  implicit val readWriteBatch2 = new (ReadWriteBatchTransaction <-< ReadBatchTransaction) {}
}

