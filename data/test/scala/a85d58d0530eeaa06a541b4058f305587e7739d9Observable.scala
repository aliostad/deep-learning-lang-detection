package de.htwg.se.wills_quest.util.observer

/**
  * Trait for a observable who want's to subscribe and get notifications from observer
  * @author Julian Raufelder, Lionel Kornberger
  * @version 02/12/16.
  */
trait Observable {
  var observers: List[Observer] = List()

  def updateObservers(): Unit = {
    for (observer <- observers)
      observer.update()
  }

  def attachObserver(observer: Observer): List[Observer] = {
    observers = observer :: observers
    observers
  }

  def detachObserver(observer: Observer): List[Observer] = {
    observers.filter(_ != observer) //Remove observer element from list
  }
}

/**
  * Trait for an observer which want's to manage the observables
  * @author Julian Raufelder, Lionel Kornberger
  * @version 02/12/16.
  */
trait Observer {
  def update()
}