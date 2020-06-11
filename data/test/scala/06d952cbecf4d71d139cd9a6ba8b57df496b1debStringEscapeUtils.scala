package com.cloud9ers.play2.sockjs

import java.io.StringWriter
import java.util.Locale

object StringEscapeUtils {
  /**
   * <p>Escapes the characters in a <code>String</code> using JavaScript String rules.</p>
   * <p>Escapes any values it finds into their JavaScript String form.
   * Deals correctly with quotes and control-chars (tab, backslash, cr, ff, etc.) </p>
   * <p/>
   * <p>So a tab becomes the characters <code>'\\'</code> and
   * <code>'t'</code>.</p>
   * <p/>
   * <p>The only difference between Java strings and JavaScript strings
   * is that in JavaScript, a single quote must be escaped.</p>
   * <p/>
   * <p>Example:
   * <pre>
   * input string: He didn't say, "Stop!"
   * output string: He didn\'t say, \"Stop!\"
   * </pre>
   * </p>
   * 
   * ref:
   *  - https://github.com/eclipse/vert.x/blob/master/vertx-core/src/main/java/org/vertx/java/core/impl/StringEscapeUtils.java#L110
   *
   * @param str String to escape values in, may be null
   * @return String with escaped values, <code>null</code> if null string input
   */
  def escapeJavaScript(str: String, escapeSingleQuote: Boolean = true, escapeForwardSlash: Boolean = true): String = {
    val out = new StringWriter(str.length() * 2)
    str.foreach { ch =>
      if (ch > 0xfff) out.write("\\u" + hex(ch))
      else if (ch > 0xff) out.write("\\u0" + hex(ch))
      else if (ch > 0x7f) out.write("\\u00" + hex(ch))
      else if (ch < 32) ch match {
        case '\b' => out.write('\\'); out.write('b')
        case '\n' => out.write('\\'); out.write('n')
        case '\t' => out.write('\\'); out.write('t')
        case '\f' => out.write('\\'); out.write('f')
        case '\r' => out.write('\\'); out.write('r')
        case _ =>
          if (ch > 0xf) out.write("\\u00" + hex(ch))
          else out.write("\\u000" + hex(ch))
      }
      else ch match {
        case '\'' =>
          if (escapeSingleQuote) {
        	  out.write('\\')
        	  out.write('\'')
          }
        case '"' => out.write('\\'); out.write('"')
        case '\\' => out.write('\\'); out.write('\\')
        case '/' =>
          if (escapeForwardSlash) {
            out.write('\\')
            out.write('/')
          }
        case _ =>
          out.write(ch);
      }
    }
    out.toString
  }

  def hex(ch: Char) = Integer.toHexString(ch).toUpperCase(Locale.ENGLISH)
}