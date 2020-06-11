package net.routestory.json

import com.javadocmd.simplelatlng.LatLng
import net.routestory.data.{Timed, Author, Story}
import net.routestory.data.Story._
import play.api.data.mapping.{To, Write}
import play.api.libs.json._
import play.api.data.mapping.json.Writes._
import play.api.libs.functional.syntax._
import play.api.libs.functional.Monoid

trait AuxiliaryWrites {
  implicit val latLngWrite = Write[LatLng, JsObject] { latLng ⇒
    Json.obj(
      "type" → "Point",
      "coordinates" → List(latLng.getLatitude, latLng.getLongitude)
    )
  }

  implicit def timedWrite[A](implicit write: Write[A, JsObject]) = Write[Timed[A], JsObject] { timed ⇒
    write.writes(timed.data) ++ Json.obj("timestamp" → timed.timestamp)
  }
}

trait WriteMonoid {
  implicit def `Write is a Monoid`[I, O: Monoid] = new Monoid[Write[I, O]] {
    def append(a1: Write[I, O], a2: Write[I, O]) = Write[I, O] { x ⇒
      a1.writes(x) |+| a2.writes(x)
    }
    def identity = Write[I, O] { _ ⇒
      implicitly[Monoid[O]].identity
    }
  }

  implicit class RichWrite[I, O](write: Write[I, O]) {
    def subtype[I1 <: I] = Write[I1, O](write.writes)
  }
}

trait ElementWrites extends AuxiliaryWrites with WriteMonoid {
  val elementTypeWrite = Write[Element, JsObject] {
    case _: Sound ⇒ Json.obj("type" → "sound")
    case _: VoiceNote ⇒ Json.obj("type" → "voice-note")
    case _: Photo ⇒ Json.obj("type" → "photo")
    case _: FlickrPhoto ⇒ Json.obj("type" → "flickr-photo")
    case _: InstagramPhoto ⇒ Json.obj("type" → "instagram-photo")
    case _: TextNote ⇒ Json.obj("type" → "text-note")
    case _: FoursquareVenue ⇒ Json.obj("type" → "foursquare-venue")
    case x: UnknownElement ⇒ Json.obj("type" → x.`type`)
  }

  val unknownElementWrite = Write.zero[JsObject]
    .contramap { x: UnknownElement ⇒ x.raw }

  val mediaElementWrite = Write[MediaElement, JsObject] { x ⇒
    Json.obj("url" → x.url)
  }

  val audioWrite = mediaElementWrite

  val imageWrite = mediaElementWrite.subtype[Image] |+| Write[Image, JsObject] {
    case x: Photo ⇒ Json.obj("caption" → x.caption)
    case x: FlickrPhoto ⇒ Json.obj("id" → x.id, "caption" → x.caption)
    case x: InstagramPhoto ⇒ Json.obj("id" → x.id, "caption" → x.caption)
  }

  val textNoteWrite = Write.gen[TextNote, JsObject]
  val foursquareVenueWrite = Write.gen[FoursquareVenue, JsObject]

  implicit val elementWrite = elementTypeWrite |+| Write[Element, JsObject] {
    case x: Audio ⇒ audioWrite.writes(x)
    case x: Image ⇒ imageWrite.writes(x)
    case x: TextNote ⇒ textNoteWrite.writes(x)
    case x: FoursquareVenue ⇒ foursquareVenueWrite.writes(x)
    case x: UnknownElement ⇒ unknownElementWrite.writes(x)
  }
}

object JsonWrites extends ElementWrites {
  implicit val metaWrite = Write.gen[Meta, JsObject]
  implicit val studyInfoWrite = Write.gen[StudyInfo, JsObject]

  implicit val chapterWrite = To[JsObject] { __ ⇒
    ((__ \ "start").write[Long] and
     (__ \ "duration").write[Int] and
     (__ \ "locations").write[List[Timed[LatLng]]].contramap { (_: Vector[Timed[LatLng]]).toList } and
     (__ \ "media").write[List[Timed[Element]]].contramap { (_: Vector[Timed[Element]]).toList })(unlift(Chapter.unapply))
  }

  implicit val storyWrite = To[JsObject] { __ ⇒
    ((__ \ "_id").write[String] and
     (__ \ "meta").write[Meta] and
     (__ \ "chapters").write[List[Chapter]] and
     (__ \ "authorId").write[Option[String]].contramap { a: Option[Author] ⇒ a.map(_.id) } and
     (__ \ "studyInfo").write[Option[StudyInfo]])(unlift(Story.unapply))
  }
}
