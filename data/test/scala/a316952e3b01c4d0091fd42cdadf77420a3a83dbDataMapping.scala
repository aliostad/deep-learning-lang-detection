package models

import play.api.libs.json.Json
/**
 * Class used to manage data, that can gain another value, called mapping.
 * Maps one value to reference.
 * Created by kuzmentsov@gmail.com on 02.11.16.
 */

case class DataMapping(value: String, reference: String)

/**
* Representation for Sub Categories grouped by Category
* Created by kuzmentsov@gmail.com on 09.09.16.
*/
case class CategoryData(category: String, subcategories: Array[String])

object DataMapping {
  implicit val dataMappingFormat = Json.format[DataMapping]
  //implicit val categoryDataFormat = Json.format[CategoryData]
  //implicit val categoryDataArrayFormat = Json.format[Array[CategoryData]]
}
