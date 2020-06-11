package com.davegurnell.play.php

/*
 * Adapted from the `serialized-php-parser` Java library:
 *
 *     https://code.google.com/p/serialized-php-parser/
 *     Copyright (c) 2007 Zsolt Szász <zsolt at lorecraft dot com>
 *     MIT License: http://opensource.org/licenses/mit-license.php
 */

import java.io._

/**
 * API for serializing `PhpValues` as `Array[Bytes]`.
 */
object PhpSerializer {
  import PhpParser._

  /** Serialize `value` as an `Arrah[Bytes]`. */
  def apply(value: PhpValue): Array[Byte] = {
    val output = new ByteArrayOutputStream
    apply(value, output)
    output.toByteArray
  }

  /** Write a serialized form of `value` to `output`. */
  def apply(value: PhpValue, output: OutputStream): Unit = value match {
    case PhpInt(value) =>
      output.write(IntStart)
      output.write(ArgDelim)
      output.write(value.toString.getBytes)
      output.write(ValueEnd)
    case PhpDouble(value) =>
      output.write(DoubleStart)
      output.write(ArgDelim)
      output.write(value.toString.getBytes)
      output.write(ValueEnd)
    case PhpBoolean(value) =>
      output.write(BooleanStart)
      output.write(ArgDelim)
      output.write(if(value) TrueValue else FalseValue)
      output.write(ValueEnd)
    case PhpString(value) =>
      output.write(StringStart)
      output.write(ArgDelim)
      output.write(value.length.toString.getBytes)
      output.write(ArgDelim)
      output.write(StringDelim)
      output.write(value)
      output.write(StringDelim)
      output.write(ValueEnd)
    case PhpArray(fields) =>
      output.write(ArrayStart)
      output.write(ArgDelim)
      output.write(fields.length.toString.getBytes)
      output.write(ArgDelim)
      output.write(FieldsStart)
      for((name, value) <- fields) {
        this.apply(name,  output)
        this.apply(value, output)
      }
      output.write(FieldsEnd)
    case PhpObject(className, fields) =>
      val classNameBytes = className.getBytes
      output.write(ObjectStart)
      output.write(ArgDelim)
      output.write(classNameBytes.length.toString.getBytes)
      output.write(ArgDelim)
      output.write(StringDelim)
      output.write(classNameBytes)
      output.write(StringDelim)
      output.write(ArgDelim)
      output.write(fields.length.toString.getBytes)
      output.write(ArgDelim)
      output.write(FieldsStart)
      for((name, value) <- fields) {
        this.apply(name,  output)
        this.apply(value, output)
      }
      output.write(FieldsEnd)
    case PhpNull =>
      output.write(NullStart)
      output.write(ValueEnd)
    case PhpUndefined =>
      output.write(NullStart)
      output.write(ValueEnd)
  }
}