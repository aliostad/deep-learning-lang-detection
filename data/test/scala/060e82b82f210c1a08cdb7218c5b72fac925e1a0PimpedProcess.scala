package com.joshcough.pimped

import java.io._


object PimpedProcess {
  implicit def stringToRunningProcess(command: String): PimpedProcess = Runtime.getRuntime.exec(command)
  implicit def pimpMyProcess(p: Process): PimpedProcess = new PimpedProcess(p)
}

class PimpedProcess(p: Process) {
  val br = new BufferedReader(new InputStreamReader(p.getInputStream))
  var str = br.readLine

  def hasNext = str != null
  def next = {val current = str; str = br.readLine; current}
  def watch(grep: Array[Char]) = while (hasNext) {println(next)}
}