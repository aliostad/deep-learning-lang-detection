package com.aixforce.bulbasaur.core

import com.aixforce.bulbasaur.helper.Helper.attrStrOrElse

import model.{StateTrait, BaseState, Process, StateLike}
import xml.{Elem, XML}
import com.aixforce.bulbasaur.helper.Logger

/**
 * Parser for local file
 * Don't support version
 */
class Parser extends ParserLike with Logger {
  /**
   * return false always
   */
  override def needRefresh(processName: String, processVersion: Int, oldProcess: Process): Boolean = false

  override def parse(processName: String, processVersion: Int): Process = {
    val processXML = getXML(processName, processVersion)
    // local process definition version always 1
    parser0(processName, 1, processXML, true)
  }

  protected def parser0(name: String, version: Int, processXML: Elem, isDefault: Boolean): Process = {
    val innerName = processXML.attrStrOrElse("name") {
      throw new IllegalArgumentException("attribute name in process is required")
    }
    require(innerName == name,
      "name in process not equals given one\n" +
      "Inner: " + innerName + "\n" +
      "Given: " + name)

    val process = new Process(name, "start", version, isDefault)

    processXML.child.foreach {
      node =>
        node.label match {
          case "#PCDATA" => // do nothing for #PCDATA
          case label => Parser.stateMap.get(label) match {
            case None => throw new NullPointerException("no state find for label " + label)
            case Some(stateClass) => {
              val state = stateClass.newInstance().parse(node)
              if (!state.isInstanceOf[BaseState]) {
                logger.warn("state " + state.name + " is not instance of BaseState")
              } else {
                globalLife(state.asInstanceOf[BaseState])
              }
              process.addState(state)
              if (label.contains("start")) {
                process.first = state.name
              }
            }
          }
        }
    }

    process
  }

  protected def getXML(processName: String, processVersion: Int): Elem = {
    val url = this.getClass.getResource("/" + processName.replaceAll("""\.""", "/") + ".xml")
    XML.load(url)
  }

  private def globalLife(baseState: BaseState) {
    // TODO wtf?
  }
}

object Parser {
  var stateMap = Map.empty[String, Class[_ <: StateLike]]
  var stateLifeMap = Map.empty[String, StateTrait]
}
