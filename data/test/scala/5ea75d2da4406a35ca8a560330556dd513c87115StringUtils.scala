package org.jaylib.scala.config.convert

object StringUtils {
  final def replaceFirst(input: String, replacements: Iterable[(String, String)]): String = {
    var buf: StringBuilder = null
    if (replacements.exists {
      case (oldStr, newStr) =>
        input.indexOf(oldStr) match {
          case -1 => false // string not found - check the next one
          case idx =>
            buf = new StringBuilder(input.length - oldStr.length + newStr.length).
            	append(input.substring(0, idx)).append(newStr)
            if (idx < input.length - oldStr.length)
              buf.append(input.substring(idx + oldStr.length))
            true // breaks the find operation
        }
    }) buf.toString
    else input
  }

  final def replaceFirst(input: String, oldStr: String, newStr: String): String = {
    input.indexOf(oldStr) match {
      case -1 => input
      case idx =>
        val buf = new StringBuilder(input.length - oldStr.length + newStr.length)
        buf.append(input.substring(0, idx))
        buf.append(newStr)
        if (idx < input.length - oldStr.length)
          buf.append(input.substring(idx + oldStr.length))
        buf.toString
    }
  }

  final def replaceAll(input: String, oldStr: String, newStr: String): String = {
    var oldIndex = 0
    var index = -1
    var buf: StringBuilder = null
    while (oldIndex < input.length) {
      index = input.indexOf(oldStr, oldIndex)
      index match {
        case -1 =>
          if (buf != null)
            buf.append(input.substring(oldIndex))
          index = input.length
        case idx =>
          if (buf == null) 
            buf = new StringBuilder(input.length - oldStr.length + newStr.length + 8)
          buf.append(input.substring(oldIndex, index)).append(newStr)
      }
      oldIndex = index + oldStr.length
    }
    if (buf != null) buf.toString
    else input
  }

}