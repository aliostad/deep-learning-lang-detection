/*
 * Copyright 2008-2012 Trung Dinh
 *
 *  This file is part of Ninthdrug.
 *
 *  Ninthdrug is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Nithdrug is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Ninthdrug.  If not, see <http://www.gnu.org/licenses/>.
 */
package ninthdrug.http

import java.net._
import java.io._
import java.util.Date
import org.jsoup.nodes.Document
import org.jsoup.nodes.Element
import Util._

class ScriptHandler(serverConfig: ServerConfig, siteConfig: SiteConfig) extends Handler {
  private val root = siteConfig.root
  private val sitename = siteConfig.name

  override def handle(req: Request, conn: Connection): RequestResult = {
    val base = stripExt(req.path, '.')
    val docPath = pathOf(root + base + ".html")
    val scriptPath = pathOf(root + base + ".taak")
    if (scriptPath == null) {
      RequestPassed
    } else {
      val doc = if (docPath != null) DocumentCache.getDocument(docPath) else null
      val script = ScriptCache.getScript(serverConfig.scriptcache, sitename, root, base + ".taak")
      val res = new Response(new Headers)
      script.execute(req, res, doc) match {
        case out: Document => {
          val xml = out.toString
          val writer = new BufferedWriter(
            new OutputStreamWriter(
              conn.socket.getOutputStream))
          writer.write("HTTP/1.1 200 OK\n")
          writer.write("Date: " + Util.formatHTTPDate(new Date()) + "\n")
          writer.write("Server: Scala Server\n")
          writer.write("Accept-Ranges: bytes\n")
          writer.write("Connection: close\n")
          writeHeaders(writer, res.headers)
          writer.write("Content-Type: text/html\n")
          writer.write("\n")
          writer.write(out.toString)
          writer.close()
        }
        case elem: Element => {
          val writer = new BufferedWriter(
            new OutputStreamWriter(
              conn.socket.getOutputStream))
          writer.write("HTTP/1.1 200 OK\n")
          writer.write("Date: " + Util.formatHTTPDate(new Date()) + "\n")
          writer.write("Server: Scala Server\n")
          writer.write("Accept-Ranges: bytes\n")
          writer.write("Connection: close\n")
          writeHeaders(writer, res.headers)
          writer.write("Content-Type: text/html\n")
          writer.write("\n")
          writer.write(elem.toString)
          writer.write("\n")
          writer.close()
        }
        case str: String => {
          val writer = new BufferedWriter(
            new OutputStreamWriter(
              conn.socket.getOutputStream))
          writer.write("HTTP/1.1 200 OK\n")
          writer.write("Date: " + Util.formatHTTPDate(new Date()) + "\n")
          writer.write("Server: Scala Server\n")
          writer.write("Accept-Ranges: bytes\n")
          writer.write("Connection: close\n")
          writeHeaders(writer, res.headers)
          writer.write("Content-Type: text/plain\n")
          writer.write("\n")
          writer.write(str)
          writer.write("\n")
          writer.close()
        }
        case redirect: Redirect => {
          val writer = new BufferedWriter(
            new OutputStreamWriter(
              conn.socket.getOutputStream))
          writer.write("HTTP/1.1 302 FOUND\n")
          writer.write("Location: " + redirect.url + "\n")
          writer.write("Date: " + Util.formatHTTPDate(new Date()) + "\n")
          writer.write("Server: Scala Server\n")
          writer.write("Accept-Ranges: bytes\n")
          writer.write("Connection: close\n")
          writeHeaders(writer, res.headers)
          writer.write("Content-Type: text/html\n")
          writer.write("\n")
          writer.write("<html>\n")
          writer.write("<head>\n")
          writer.write("<title>Moved</title>\n")
          writer.write("</head>\n")
          writer.write("<body>\n")
          writer.write("Moved to " + redirect.url + "\n")
          writer.write("</body>\n")
          writer.write("</html>\n")
          writer.close()
        }
        case _ => {
          // unregcognized return
        }
      }
      RequestHandled
    }
  }

  private def writeHeaders(writer: Writer, headers: Headers) {
    for (i <- 0 until headers.size) {
      writer.write(headers(i) + "\n")
    }
  }

  private def pathOf(path: String): String = {
    val file = new File(path)
    if (file.exists) path else null
  }
}
