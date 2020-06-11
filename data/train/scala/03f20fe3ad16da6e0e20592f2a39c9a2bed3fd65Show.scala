package models

import play.api.libs.json.Json
import org.ancelin.play2.couchbase.Couchbase
import com.couchbase.client.protocol.views.{Stale, ComplexKey, Query}
import play.api.Play.current
import scala.concurrent.Future
import net.spy.memcached.ops.OperationStatus

case class Show(id: Option[String], date: String, location: String, hour: String, price: Float)

object ShowObject {
	implicit val showReader = Json.reads[Show]
	implicit val showWriter = Json.writes[Show]
	implicit val ec = Couchbase.couchbaseExecutor

	def bucket = Couchbase.bucket("shows")

	def findById(id: String): Future[Option[Show]] = {
		bucket.get[Show](id)	
	}

	def findAll(): Future[List[Show]] = {
		bucket.find[Show]("show", "by_date")(new Query().setIncludeDocs(true).setStale(Stale.FALSE))
	}

	def save(show: Show): Future[OperationStatus] = {
		bucket.set[Show]( show.id.get, show )
	}

	def remove(id: String): Future[OperationStatus] = {
		bucket.delete(id)
	}

}
