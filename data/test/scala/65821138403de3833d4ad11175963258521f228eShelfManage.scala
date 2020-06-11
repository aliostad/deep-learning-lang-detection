package controllers.form

import play.api.data._
import play.api.data.Forms._

/**
 * 本棚管理に関するフォーム
 */

case class ShelfManage (shelf_id : Long, shelf_name : String, def_flag : Int, privacy : Int)
case class PlaceAdd (place_name: String, shelf_id: Long)
case class PlaceEdit (place_id: String, place_name: String, shelf_id: Long)
case class PlaceDel (place_id: String, shelf_id: Long)
case class GenreAdd (genre_name: String, shelf_id: Long)
case class GenreEdit (genre_id: String, genre_name: String, shelf_id: Long)
case class GenreDel (genre_id: String, shelf_id: Long)

object ShelfManageForm {
  val shelfForm = Form(
    mapping(
      "shelf_id" -> longNumber,
      "shelf_name" -> nonEmptyText,
      "def_flag" -> number,
      "privacy" -> number
    )(ShelfManage.apply)(ShelfManage.unapply)
  )
  
  /**
   * 場所に関するフォーム
   */
  val placeAddForm = Form(mapping("place_name" -> nonEmptyText, "shelf_id" -> longNumber)(PlaceAdd.apply)(PlaceAdd.unapply))
  val placeEditForm = Form(mapping("place_id" -> nonEmptyText, "place_name" -> nonEmptyText, "shelf_id" -> longNumber)(PlaceEdit.apply)(PlaceEdit.unapply))
  val placeDelForm = Form(mapping("place_id" -> nonEmptyText, "shelf_id" -> longNumber)(PlaceDel.apply)(PlaceDel.unapply))
  
  /**
   * ジャンルに関するフォーム
   */
  val genreAddForm = Form(mapping("genre_name" -> nonEmptyText, "shelf_id" -> longNumber)(GenreAdd.apply)(GenreAdd.unapply))
  val genreEditForm = Form(mapping("genre_id" -> nonEmptyText, "genre_name" -> nonEmptyText, "shelf_id" -> longNumber)(GenreEdit.apply)(GenreEdit.unapply))
  val genreDelForm = Form(mapping("genre_id" -> nonEmptyText, "shelf_id" -> longNumber)(GenreDel.apply)(GenreDel.unapply))
}
