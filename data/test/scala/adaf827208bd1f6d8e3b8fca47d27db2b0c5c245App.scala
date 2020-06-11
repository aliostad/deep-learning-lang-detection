package com.meetup.jirastats

import com.meetup.jirastats.printer.FileWriter

object App {

  def main(args: Array[String]): Unit = {
    apply()
  }

  def apply(): Unit = {
    JiraHandler().fold[Unit]({ error =>
      println(error)
    }, { handler =>

      // Write issues and their transitions.
      val issuesFile = "issues.json.log"
      val transitionsFile = "transitions.json.log"

      val issuesWriter = new FileWriter(issuesFile)
      val transitionsWriter = new FileWriter(transitionsFile)

      println(s"Will write issues to $issuesFile")
      println(s"Will write transitions to $transitionsFile")

      new WriteIssues(handler, issuesWriter, transitionsWriter).write()
      issuesWriter.close()
      transitionsWriter.close()

      // Write epics
      val epicsFile = "epics.json.log"
      val epicsWriter = new FileWriter(epicsFile)

      println(s"Will write epics to $epicsFile")
      new WriteEpics(handler, epicsWriter).write()
      epicsWriter.close()

      // Write versions
      val versionsFile = "versions.json.log"
      val versionsWriter = new FileWriter(versionsFile)

      println(s"Will write versions to $versionsFile")
      new WriteVersions(handler, versionsWriter).write()
      versionsWriter.close()

      handler.close()
    })
  }

}

