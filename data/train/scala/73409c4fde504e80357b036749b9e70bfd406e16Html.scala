package org.zerngsn.opt.twitter.view

import java.util.Date
import org.zerngsn.opt.twitter._
import org.zerngsn.opt.twitter.TwitterUtils._
import twitter4j.{ResponseList, User, Status}
import collection.JavaConverters._

import scalax.file.Path

object Html extends Html
trait Html {
	import HtmlView._
	def statusList2Html(rs: ResponseList[Status]): String = statusList2Html(rs.asScala.toList)
	def statusList2Html(statusList: Seq[Status]): String = listHtml(statusList.map(status2Html))

	def status2Html(status: Status): String = status2Html(status.getUser, status)
	def status2Html(user: User, status: Status): String = statusHtml(
		user.getMiniProfileImageURL, user.getName, user.getScreenName, user2UserPageURL(user),
		status.getText, status2URL(user, status), status.getCreatedAt)


	def dump(rs: ResponseList[Status]): DumpTo = dump(statusList2Html(rs))
	def dump(sList: Seq[Status]): DumpTo = dump(statusList2Html(sList))
	def dump(html: String): DumpTo = DumpTo(html)

	protected case class DumpTo(html: String) {
		def apply(): Unit = apply(Path(dumpHtmlFile))
		def apply(file: String): Unit = apply(Path(file))
		def apply(path: Path): Unit = path.write(html)
	}
}

object HtmlView {
	def listHtml(htmls: Seq[String]) = htmls.mkString("<hr>")

	def statusHtml(imgURL: String, name: String, scName: String, userPageURL: String,
								 text: String, URL: String, date: Date): String = {
		s"""
			 |<div>
			 |	<div>
			 |	<img src="$imgURL">
			 |	<a href="$userPageURL"><span style="font-size: small;">$name@$scName</span></a>
			 |	</div>
			 |
			 | <div><span style="font-size: medium;">$text</span></div>
			 |
			 | <div><a href = $URL><span style="font-size: small;">${dateFormat(date)}</span></a></div>
			 |
			 |</div>
		""".stripMargin
	}

	def wholeHtml(body: String) =
		s"""
			 |<!DOCTYPE html>
			 |<html lang="ja">
			 |<head>
			 |    <meta charset="UTF-8">
			 |    <title></title>
			 |</head>
			 |<body>
			 |${body}
			 |</body>
			 |</html>
""".stripMargin


}
