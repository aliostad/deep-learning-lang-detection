package com.aixforce.bulbasaur.core

import com.aixforce.bulbasaur.helper.Logger
import model.Process
import com.aixforce.bulbasaur.framework.SpringSupport.__

object Place extends Logger {
  var parser: ParserLike = new Parser

  val parser2 = __[ParserLike]

  // the key of process will be
  // 1. process's name + "$" + process's version for specifically version | example: orderProcess$1
  // 2. process's name for default version | example: orderProcess
  var processes = Map.empty[String, Process]

  def +=(process: Process): this.type = {
    if (process.isDefault) {
      processes.get(process.name).foreach {
        oldDefaultP =>
          oldDefaultP.isDefault = false
      }
      processes += (process.name -> process)
    }
    processes += ((process.name + "$" + process.version) -> process)
    this
  }

  /**
   * 0 for default version
   */
  def apply(name: String, version: Int = 0): Process = {
    val key = if (version == 0) name else name + "$" + version

    val process = if (processes.isDefinedAt(key) && !parser.needRefresh(name, version, processes(key))) {
      processes(key)
    } else {
      logger.info("process: " + name + "$" + version + " can't find or need refresh, try to parse it")
      val newProcess = parser.parse(name, version)
      Place += newProcess
      newProcess
    }

    if (process == null) {
      throw new NullPointerException("no process find for name:" + name + "&" + version)
    }

    process
  }
}