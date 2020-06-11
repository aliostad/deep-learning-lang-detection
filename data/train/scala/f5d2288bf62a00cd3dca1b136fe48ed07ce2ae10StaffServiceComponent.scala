package domain
package services

import domain.objects._

trait StaffServiceComponent {
  
  def staffService: StaffService
  
  trait StaffService{
    //added user to create resource
    def createResource(resourceID: Int, name: String, description: String, staffer: User): Option[Resource]
    def removeResource(oldResource: Resource): Boolean
    def checkIn(returnedResource: Resource): Unit
    def checkOut(returnedResource: Resource): Boolean
    def viewReservations(member: User): List[Reservation]
    def viewReservations(resource: Resource): List[Reservation]
    def viewReservations(): List[Reservation]
    def deleteReservation(oldReservation: Reservation): Boolean
    def deleteReservations(oldReservations: List[Reservation]): Boolean
  }
  
}