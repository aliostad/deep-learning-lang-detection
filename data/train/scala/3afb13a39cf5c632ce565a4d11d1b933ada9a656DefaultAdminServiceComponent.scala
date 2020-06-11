package domain
package services.impl

import domain.services._
import domain.objects._


trait  DefaultAdminServiceComponent extends AdminServiceComponent {
  this: UserRepositoryComponent =>
   
  def adminService = new DefaultAdminService
  
  class DefaultAdminService extends AdminService{
	//TODO provide implementation of Admin Service functions
    //TODO Users don't seem to have passwords!!! 
    def approveUser(user: User): Unit = {
      userRepository.addUser(user.userID, user.email, user.firstName, user.lastName, user.role)
    }
    def approveUser(userID: Int, email: String, firstName: String, lastName: String, role: Role): Unit = {
      userRepository.addUser(userID, email, firstName, lastName, role)
    }
    def modifyUser(oldUser: User, newUser: User): Unit = {
      userRepository.removeUser(oldUser)
      userRepository.addUser(newUser)
    }
//    def modifyUser(oldUser: User, newPassword: String): Unit = {
//      userRepository.removeUser(oldUser)
//      userRepository.addUser(oldUser.userID, oldUser.email, oldUser.firstName, oldUser.lastName)
//    }
    def deleteUser(user: User): Unit = {
      userRepository.removeUser(user)
    }
    def deleteUser(userID: Int): Unit = {
      userRepository.removeUser(userID)
    }
    def deleteUser(email: String): Unit = {
      userRepository.removeUser(email)
    }
  }
}
