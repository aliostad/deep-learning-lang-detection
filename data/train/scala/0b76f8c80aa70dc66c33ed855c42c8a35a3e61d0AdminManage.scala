package org.plummtw.avalon.model
 
import net.liftweb._
import net.liftweb.mapper._

class AdminManage extends LongKeyedMapper[AdminManage] with CreatedUpdated with IdPK {
  def getSingleton = AdminManage // what's the "meta" object
  //def primaryKeyField = id

  // the primary key
  //object id            extends MappedLongIndex(this)

  object param_name    extends MappedString(this, 256)
  object param_value   extends MappedString(this, 256)
}

object AdminManage extends AdminManage with LongKeyedMetaMapper[AdminManage] {
  override def fieldOrder = List(id, param_name, param_value)
}