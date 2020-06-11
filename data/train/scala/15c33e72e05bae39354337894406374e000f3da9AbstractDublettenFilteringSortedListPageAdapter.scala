package org.braingrow.gritterweb

import net.liftweb.json.Serialization
import akka.actor.{ActorRef, Actor}


abstract class AbstractDublettenFilteringSortedListPageAdapter[T](webSocketActor: ActorRef, historyManager: MessageHistoryManager[String])
  extends Actor {

  implicit val formats = net.liftweb.json.DefaultFormats

  private var getOrderedOldListOptionFromList = List[(String, T)]()
  private var oldMap = Map[String, Object]("list" -> List[(String, T)]())
  private var lock = new Object()

  def createPageMessage(word: String, list: T, pos: String): Map[String, Any]

  def createListMap(newList: scala.List[(String, T)], orderedOldWords: List[String]): Map[String, Any] = {

    val result = Map(
      "dateTime" -> System.currentTimeMillis(),
      "list" -> newList.view.zipWithIndex.map {
        case ((item, list), index) => {
          val indexInOld = orderedOldWords.indexOf(item)
          // determine whether the current item rose,fell or is new in top ten since the last list
          val pos = indexInOld match {
            case idx if idx < 0 => "new"
            case idx: Int => idx.compare(index) match {
              case i if i < 0 => "down"
              case i if i > 0 => "up"
              case _ => "level"
            }
          }
          createPageMessage(item, list, pos)

        }
      }.toList
    )
    result
  }

  def getOrderedOldListOptionFromList(newList: scala.List[(String, T)]): Option[List[String]] = {
    lock.synchronized {
      if (newList == getOrderedOldListOptionFromList) {
        None
      } else {
        val l = Some(getOrderedOldListOptionFromList.map(_._1))
        getOrderedOldListOptionFromList = newList
        l
      }
    }
  }

  def writeMessage(result: Map[String, Any]) {
    val message = Serialization.write(result)
    historyManager.notifyMessage(message)
    webSocketActor ! message
  }

  def receive = {

    case newMap: Map[String, Object] => {
      val orderedOldListOption = lock.synchronized {
        if (newMap == oldMap) {
          None
        } else {
          val l = Some(oldMap.get("list").get.asInstanceOf[List[(String, T)]].map(_._1))
          oldMap = newMap
          l
        }
      }
      if (orderedOldListOption != None) {
        val orderedOldWords = orderedOldListOption.get
        val result = createListMap(newMap.get("list").get.asInstanceOf[List[(String, T)]], orderedOldWords) + ("total" -> oldMap.get("count").get)
        writeMessage(result)
      }
    }

    case newList: List[(String, T)] => {
      // synchronized as we need to avoid two same lists sneaking through

      val orderedOldListOption = getOrderedOldListOptionFromList(newList)

      if (orderedOldListOption != None) {
        val orderedOldWords = orderedOldListOption.get
        val result: Map[String, Any] = createListMap(newList, orderedOldWords)

        writeMessage(result)

      }
    }
  }
}