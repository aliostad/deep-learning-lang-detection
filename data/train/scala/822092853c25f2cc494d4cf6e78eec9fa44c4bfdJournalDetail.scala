package coba.ken.redmineapi.bean

/**
 * Redmine journal entry field. Actual set of fields depends on a redmine
 * responce and probably is not documented anywhere.
 * @author Kenichi Kobayashi
 * @version $Revision$
 * @lastmodified $Date$
 */
class JournalDetail extends Serializable {
  var newValue: String = _
  var name: String = _
  var property: String = _
  var oldValue: String = _

  override def toString(): String = {
    val builder = new StringBuilder
    builder ++= "JournalDetail [newValue="
    builder ++= newValue
    builder ++= ", name="
    builder ++= name
    builder ++= ", property="
    builder ++= property
    builder ++= ", oldValue="
    builder ++= oldValue
    builder ++= "]"
    builder.toString
  }
}
