package com.seanshubin.builder.process

import java.io.File
import java.util

class ProcessBuilderDelegate(delegate: ProcessBuilder) extends ProcessBuilderContract {
  override def command(command: String*): ProcessBuilderContract = new ProcessBuilderDelegate(delegate.command(command: _*))

  override def directory(directory: File): ProcessBuilderContract = new ProcessBuilderDelegate(delegate.directory(directory))

  override def environment: util.Map[String, String] = delegate.environment()

  override def start: ProcessContract = new ProcessDelegate(delegate.start())
}

object ProcessBuilderDelegate {
  def apply(): ProcessBuilderContract = new ProcessBuilderDelegate(new ProcessBuilder())
}
