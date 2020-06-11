package shine.st.dashboard

import shine.st.common.DateTimeUtils
import shine.st.dashboard.data.Model.Device.Device
import shine.st.dashboard.data.Model.Source.Source
import shine.st.dashboard.data.Model._
import org.joda.time.DateTime
import play.api.libs.functional.syntax._
import play.api.libs.json._

/**
  * Created by shinest on 06/07/2017.
  */
package object data {

  implicit val jodaDateWrites: Writes[DateTime] = (d: DateTime) => JsString(DateTimeUtils.formatDateHour(d))

  implicit val categoryWrites: Writes[Category] = (c: Category) => JsString(c.name)

  implicit val deviceWrites: Writes[Device] = (d: Device) => JsString(d.toString)

  implicit val sourceWrites: Writes[Source] = (s: Source) => JsString(s.toString)

  implicit val dailyDataWrites: Writes[DailyData] = (
    (JsPath \ "date").write[DateTime] and
      (JsPath \ "visitor").write[Int] and
      (JsPath \ "page_view").write[Int] and
      (JsPath \ "amount").write[Int] and
      (JsPath \ "order_count").write[Int] and
      (JsPath \ "customer").write[Int] and
      (JsPath \ "category").write[Category] and
      (JsPath \ "device").write[Device]
    ) (unlift(DailyData.unapply))

  implicit val hourlyDataWrites: Writes[HourlyData] = (
    (JsPath \ "date").write[DateTime] and
      (JsPath \ "hour").write[Int] and
      (JsPath \ "visitor").write[Int] and
      (JsPath \ "page_view").write[Int] and
      (JsPath \ "amount").write[Int] and
      (JsPath \ "order_count").write[Int] and
      (JsPath \ "customer").write[Int] and
      (JsPath \ "category").write[Category] and
      (JsPath \ "device").write[Device]
    ) (unlift(HourlyData.unapply))


  implicit val dailyOrderWrites: Writes[DailyOrder] = (
    (JsPath \ "date").write[DateTime] and
      (JsPath \ "amount").write[Int] and
      (JsPath \ "order_count").write[Int] and
      (JsPath \ "customer").write[Int] and
      (JsPath \ "category").write[Category] and
      (JsPath \ "source").write[Source]
    ) (unlift(DailyOrder.unapply))


  implicit val hourlyOrderWrites: Writes[HourlyOrder] = (
    (JsPath \ "date").write[DateTime] and
      (JsPath \ "hour").write[Int] and
      (JsPath \ "amount").write[Int] and
      (JsPath \ "order_count").write[Int] and
      (JsPath \ "customer").write[Int] and
      (JsPath \ "category").write[Category] and
      (JsPath \ "source").write[Source]
    ) (unlift(HourlyOrder.unapply))

  implicit val summarizeWrites: Writes[Summarize] = (
    (JsPath \ "date").write[DateTime] and
      (JsPath \ "visitor").write[Int] and
      (JsPath \ "conversionRate").write[Double] and
      (JsPath \ "device").write[Device]
    ) (unlift(Summarize.unapply))


}
