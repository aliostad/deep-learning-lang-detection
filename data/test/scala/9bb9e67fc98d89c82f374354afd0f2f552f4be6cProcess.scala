package sysinterface.process

import java.io.{InputStream, OutputStream}


trait Process {

  def isAlive: Boolean

  def join(): Either[String, Int]

  def kill(): Unit

  def exitValue: Option[Int]
}

trait ProcessIoRedirection { self: Process =>
  def getStdIn(): OutputStream

  def getStdOut(): InputStream

  def getStdErr(): InputStream
}


trait ProcessExecutor {

  def execute(command: String, params: String*): Either[String, Process]

  def executeWithIoRedirection(command: String, params: String*): Either[String, Process with ProcessIoRedirection]

  def withUpdatedEnvironment(envUpdate: Map[String, String]): ProcessExecutor

  def withNewEnvironment(newEnv: Map[String, String]): ProcessExecutor

  def withWorkingDirectory(workingDirectory: String): ProcessExecutor
}
