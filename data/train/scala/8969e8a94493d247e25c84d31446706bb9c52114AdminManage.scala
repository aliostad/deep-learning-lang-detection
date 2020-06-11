package org.plummtw.jinrou.model 
 
import net.liftweb._ 
import mapper._ 
import http._ 
import SHtml._ 
import util._

class AdminManage extends LongKeyedMapper[AdminManage] with IdPK {
  def getSingleton = AdminManage // what's the "meta" object
  //def primaryKeyField = id

  // the primary key
  //object id            extends MappedLongIndex(this)

  object param_name    extends MappedString(this, 256)
  object param_value   extends MappedString(this, 256)

  object created       extends MappedDateTime(this) {
    override def defaultValue = new java.util.Date()
  }

  object updated       extends MappedDateTime(this) with LifecycleCallbacks {
    override def beforeCreate = this(new java.util.Date())
  }
  
}

object AdminManage extends AdminManage with LongKeyedMetaMapper[AdminManage] {
  override def fieldOrder = List(id, param_name, param_value, created, updated)
}

/*class AdminManage {
  String session_id
  static constraints = {
    session_id(blank:true, maxSize:34, unique:true)
    
    created(nullable:true)
    updated(nullable:true)
  }
  
  Date created
  Date updated
  def beforeInsert = {
    created = new Date()
  }
  def beforeUpdate = {
    updated = new Date()
  }
}
*/

/*
`session_id` varchar(34) default NULL,
				KEY `session_id` (`session_id`)
*/