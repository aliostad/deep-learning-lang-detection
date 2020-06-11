package models
package services.impl

import models.services._
import models.objects._


trait  DefaultAdminServiceComponent extends AdminServiceComponent {
//  this: UserRepositoryComponent =>
   
//  def adminService = new DefaultAdminService
  
  class DefaultAdminService extends AdminService{
	 //TODO provide implementation of Admin Service functions
    def approveUser(user: User): Boolean = {true}
    def modifyUser(oldUser: User, newUser: User): Unit = {
//      oldUser.userID = newUser.userID
//      oldUser.email = newUser.email
//      oldUser.firstName = newUser.firstName
//      oldUser.lastName = newUser.lastName
//      oldUser.role = newUser.role
    }
    def deleteUser(user: User): Boolean = {true}
  }
}
