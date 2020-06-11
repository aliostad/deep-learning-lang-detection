package com.seanshubin.detangler.contract

import java.io.File
import java.util

trait ProcessBuilderContract {
  def command(command: util.List[String]): ProcessBuilderContract

  def command(command: String*): ProcessBuilderContract

  def command: util.List[String]

  def environment: util.Map[String, String]

  def directory: File

  def directory(directory: File): ProcessBuilderContract

  def redirectInput(source: ProcessBuilder.Redirect): ProcessBuilderContract

  def redirectOutput(destination: ProcessBuilder.Redirect): ProcessBuilderContract

  def redirectError(destination: ProcessBuilder.Redirect): ProcessBuilderContract

  def redirectInput(file: File): ProcessBuilderContract

  def redirectOutput(file: File): ProcessBuilderContract

  def redirectError(file: File): ProcessBuilderContract

  def redirectInput: ProcessBuilder.Redirect

  def redirectOutput: ProcessBuilder.Redirect

  def redirectError: ProcessBuilder.Redirect

  def inheritIO: ProcessBuilderContract

  def redirectErrorStream: Boolean

  def redirectErrorStream(redirectErrorStream: Boolean): ProcessBuilderContract

  def start(): Process
}
