package controllers

import play.api.Play
import play.api.mvc._
import models._
import scala.xml.PCData
import org.joda.time.format.DateTimeFormat
import org.joda.time.DateTime
import javax.inject.Inject

class Rss @Inject() (
  dumpDb: DumpDB,
  tagDb: TagDB) extends Controller {
  
  def dumps = Action { request =>

    val baseUrl = "http://" + request.host;
    val feedUrl = baseUrl + request.uri;
    val dumps = dumpDb.all;

    val updatedTime =
      if (dumps.isEmpty)
        new DateTime()
      else
        dumps.map(d => d.timestamp).reduceLeft((lhs, rhs) => (if (lhs.compareTo(rhs) > 0) lhs else rhs))

    val feedXml =
      <feed xmlns="http://www.w3.org/2005/Atom">
        <author>
          <name>dmpster</name>
        </author>
        <title>All Dumps</title>
        <id>{ feedUrl }</id>
        <link href={ feedUrl } rel="self" type="application/atom+xml"/>
        <updated>{ updatedTime }</updated>
        {
          dumps.map(d => {
            val dumpDetailsUrl = baseUrl + "/dmpster/dmp/" + d.id + "/details"

            val tagsAsText = tagDb.forDump(d).map(tag => tag.name).mkString(", ");

            val timeFormatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
            val formattedTimestamp = timeFormatter.print(d.timestamp);
            val bucketName = d.bucket.name;

            val entryContent =
              <html>
                <body>
                  <h1>{ bucketName }<br/><a href={ dumpDetailsUrl }>{ d.filename }</a></h1>
                  <p>{ formattedTimestamp }</p>
                  <p>Tags: { tagsAsText }</p>
                  <p><pre>{ d.content }</pre></p>
                </body>
              </html>.toString;

            <entry>
              <id>{ dumpDetailsUrl + "__" + d.timestamp.toString() }</id>
              <title>{ d.filename }</title>
              <updated>{ d.timestamp }</updated>
              <link href={ dumpDetailsUrl }></link>
              <summary>{ d.filename + " (" + d.timestamp + ")  \n" + bucketName }</summary>
              <content type="html">{ new PCData(entryContent) }</content>
            </entry>
          })
        }
      </feed>;

    val prettyPrinter = new scala.xml.PrettyPrinter(100, 2)
    val feedFormatted = prettyPrinter.format(feedXml);

    Ok(feedFormatted).as("application/rss+xml, application/rdf+xml, application/atom+xml, application/xml, text/xml")
  }
}