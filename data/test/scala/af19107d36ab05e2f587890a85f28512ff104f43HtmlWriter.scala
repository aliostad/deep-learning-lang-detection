package pagemaker

import java.io.Writer
import java.io.IOException

class HtmlWriter(writer: Writer) {
  def title(title: String) = {
	writer.write("<html>")
	writer.write("<head>")
	writer.write("<title>" + title + "</title>")
	writer.write("</head>")
	writer.write("<body>\n")
	writer.write("<h1>" + title + "</h1>\n")
  }
  def paragraph(msg: String) = writer.write("<p>" + msg + "</p>\n")
  def link(href: String, caption: String) = paragraph("<a href=\"" + href + "\">" + caption + "</a>")
  def mailto(mailaddr: String, username: String) = link("mailto:" + mailaddr, username)
  def close = {
	writer.write("</body>")
	writer.write("</html>\n")
	writer.close
  }
}
