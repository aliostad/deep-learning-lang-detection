package Storable.Fields.FieldValue

import java.time.LocalDate
import java.time.format.DateTimeFormatter

import Services.{MysqlBroker, OracleBroker, PersistenceBroker}
import Storable.Fields.DateDatabaseField
import Storable.StorableClass

class DateFieldValue(instance: StorableClass, field: DateDatabaseField) extends FieldValue[LocalDate](instance, field) {
  def getPersistenceLiteral(implicit pbClass: Class[_ <: PersistenceBroker]): String = pbClass match {
    case x if x == classOf[MysqlBroker] => "'" + super.get.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + "'"
    case x if x == classOf[OracleBroker] => "TO_DATE('" + super.get.format(DateTimeFormatter.ofPattern("MM/dd/yyyy")) + "', 'MM/DD/YYYY')"
  }
}
