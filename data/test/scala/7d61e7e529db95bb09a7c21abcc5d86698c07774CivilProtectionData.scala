package it.unibo.drescue.localModel

import java.util
import java.util.{ArrayList, List}

import it.unibo.drescue.model.RescueTeamImpl

/**
  * A class representing the civil protection local model
  */
case class CivilProtectionData() extends Observable {

  private var _cpID: String = _

  private var _lastAlerts: List[AlertEntry] = new ArrayList[AlertEntry]()

  private var _enrolledRescueTeams: List[RescueTeamImpl] = new ArrayList[RescueTeamImpl]()

  private var _notEnrolledRescueTeams: List[RescueTeamImpl] = new ArrayList[RescueTeamImpl]()

  private var _enrolledTeamInfoList: List[EnrolledTeamInfo] = new ArrayList[EnrolledTeamInfo]()

  /**
    * Gets the logged civil protection identifier.
    *
    * @return cpID
    */
  def cpID: String = _cpID

  /**
    * Sets the logged civil protection identifier.
    *
    * @param value identifier to set
    */
  def cpID_=(value: String): Unit = {
    _cpID = value
  }

  /**
    * TODO
    *
    * @return
    */
  def lastAlerts: List[AlertEntry] = _lastAlerts

  /**
    * TODO
    *
    * @param list
    */
  def lastAlerts_=(list: util.List[AlertEntry]): Unit = {
    _lastAlerts = list
    notifyObserver(Observers.Home)
  }

  /**
    * TODO
    *
    * @return
    */
  def enrolledRescueTeams: List[RescueTeamImpl] = _enrolledRescueTeams

  /**
    * TODO
    *
    * @param list
    */
  def enrolledRescueTeams_=(list: util.List[RescueTeamImpl]): Unit = {
    _enrolledRescueTeams = list
    notifyObserver(Observers.ManageRescue)
  }

  /**
    * TODO
    *
    * @return
    */
  def notEnrolledRescueTeams: List[RescueTeamImpl] = _notEnrolledRescueTeams

  /**
    * TODO
    *
    * @param list
    */
  def notEnrolledRescueTeams_=(list: util.List[RescueTeamImpl]): Unit = {
    _notEnrolledRescueTeams = list
    notifyObserver(Observers.EnrollTeam)
  }

  /**
    * Gets the list with all the info about availability of enrolled
    * rescue teams.
    *
    * @return the enrolledTeamInfoList
    */
  def enrolledTeamInfoList: List[EnrolledTeamInfo] = this.synchronized(_enrolledTeamInfoList)

  /**
    * Sets the given list as the list with all the info about availability
    * of enrolled rescue teams.
    *
    * @param list list to set into the model
    */
  def enrolledTeamInfoList_=(list: util.List[EnrolledTeamInfo]): Unit = {
    this.synchronized(_enrolledTeamInfoList = list)
    notifyObserver(Observers.ManageRescue)
  }

  /**
    * Replace the enrolledTeamInfo at given index with the given one.
    *
    * @param index            index of the element to replace
    * @param enrolledTeamInfo element to set
    */
  def modifyEnrollment(index: Int, enrolledTeamInfo: EnrolledTeamInfo): Unit = {
    this.synchronized(_enrolledTeamInfoList.set(index, enrolledTeamInfo))
    notifyObserver(Observers.ManageRescue)
  }

  /**
    * Add a new enrolledTeamInfo to enrolledTeamInfoList
    *
    * @param enrolledTeamInfo element to add
    */
  def addEnrollment(enrolledTeamInfo: EnrolledTeamInfo): Unit = {
    this.synchronized(_enrolledTeamInfoList.add(enrolledTeamInfo))
    notifyObserver(Observers.ManageRescue)
  }

}
