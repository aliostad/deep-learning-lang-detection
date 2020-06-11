 package net.liftweb.usermon.model

import _root_.net.liftweb.mapper._
import _root_.net.liftweb.util._
import _root_.net.liftweb.sitemap._
import _root_.net.liftweb.sitemap.Loc._
import _root_.net.liftweb.http._
import _root_.net.liftweb.http._
import SHtml._
import java.util.Date
import _root_.scala.xml._
import Helpers._
import _root_.scala.collection.mutable._


object Role extends Role with LongKeyedMetaMapper[Role] {  
  
  def listRolesMenu = 
    Menu(Loc("listRoles", "listRoles" :: Nil, S.??("List Roles"),                  
                  listRoles, User.testLogginIn)) 
  
  def addRoleMenu = 
	 Menu(Loc("addRole", "addRole" :: Nil, S.??("Add Role"), listRoles, Hidden))
  
  def menus:List[Menu] = listRolesMenu :: Nil
  
 
 def listRoles = Template({ () =>
  <lift:surround with="default" at="content">
   <h3>Site Roles</h3>
    <div id="entryform">      
      <table>
        <tr>
	        <th>Role</th>
            <th>Parent Role</th>
	        <th><lift:ManageRoles.addNew>        
         <role:addNew/>
       </lift:ManageRoles.addNew>	        	
            </th>	        	        
        </tr>        
         <lift:ManageRoles.list>
         	<role:entry>
		      <tr>
		        <td style="vertical-align: top"><role:name /></td>
	            <td style="vertical-align: top"><role:parent /></td>
		        <td style="vertical-align: top"><role:actions/></td>	               
		      </tr>
           </role:entry>           
          </lift:ManageRoles.list>
	  </table>
      </div>
      <hr />      
      <div id="role-save"/>      
      
</lift:surround>
  })
}

class Role extends LongKeyedMapper[Role] with IdPK {
	
  def getSingleton = Role
  
  
  
  object name extends MappedPoliteString(this, 50) {
    override def setFilter = notNull _ :: trim _ :: super.setFilter 
    override def displayName = "Name:" 
  }
  
  object parent extends MappedLongForeignKey(this, Role){
    override def dbIndexed_? = true   
    override def validSelectValues: Box[List[(Long, String)]] = 
      Full(
        List[(Long, String)]((-1, "NA")) ::: Role.findAll.map( x => (x.id.is, x.name.is) ))
    
    override def displayName = "Parent Role:"
  }
  
  def parentName =
	  parent.obj.map(_.name.is) openOr "NA"
  
  def parentId =
    parent.obj.map(_.id.is) openOr -1
  
  def parents = Role.findAll(By(Role.parent, this.id))
  
  def byName (name : String) = 
    Role.findAll(By(Role.name, name)) match {
      case role :: rest => role
      // create a role for the given name if it doesn't exist... 
      case Nil => Role.create.name(name).saveMe
    } 

}
