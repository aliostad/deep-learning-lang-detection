package models
package services.impl

import models.services._
import models.objects._

trait DefaultStaffServiceComponent extends StaffServiceComponent {
  this: UserRepositoryComponent /*with NotificationServiceComponent*/ =>
    
//  def staffService = new DefaultStaffService
  
  
  class DefaultStaffService extends StaffService{
    //added staffer to createResource Declaration
    def createResource(name: String, description: String, staffer: User): Option[Resource] = userRepository.addResource(userRepository.getLargestResourceID(), name, description, staffer)
    def removeResource(oldResource: Resource) = userRepository.removeResource(oldResource)

    def checkIn(returnedResource: Resource): Unit = {}
    //TODO fix the implementation of CheckOut here
    def checkOut(returnedResource: Resource): Boolean = {return true}
    def viewReservations(member: User): List[Reservation] = {userRepository.getReservations(member)}
    def viewReservations(resource: Resource): List[Reservation] = {resource.reservations}
    def viewReservations(): List[Reservation] = {userRepository.getReservations}
    def viewAllResources(): List[Resource] = {userRepository.getResources()}
    def getResource(id: Int): Option[Resource] = {userRepository.getResource(id)}
    def deleteReservation(oldReservation: Reservation): Boolean = {userRepository.removeReservation(oldReservation)}
    def deleteReservations(oldReservations: List[Reservation]): Boolean = oldReservations.map(userRepository.removeReservation(_)).reduceLeft((a,b) => a&&b)    
    def viewMembers():List[User ] = {userRepository.getAllUsers.filter(_.role.isMember == true)}
    def addMember(email: String, password: String, firstName: String, lastName: String, role: Role): Option[User] = {userRepository.addUser(email, password, firstName, lastName, role)}

  }
}