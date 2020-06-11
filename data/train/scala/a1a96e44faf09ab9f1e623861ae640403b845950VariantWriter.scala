package widebase.io

import java.nio.channels.WritableByteChannel
import java.sql.Timestamp

import org.joda.time. {

  LocalDate,
  LocalDateTime,
  LocalTime,
  Minutes,
  Seconds,
  YearMonth

}

import widebase.data.Datatype
import widebase.io.filter. { CompressionLevel, StreamFilter }
import widebase.io.filter.StreamFilter.StreamFilter

/** Write variant types into [[java.nio.channels.WritableByteChannel]].
 *
 * @param channel @see [[java.lang.channels.WritableByteChannel]]
 * @param filter of writer, default is [[widebase.io.filter.StreamFilter.None]]
 * @param level of compression 0-9, default is [[CompressionLevel.Default]]
 *
 * @author myst3r10n
 */
class VariantWriter(
  channel: WritableByteChannel,
  filter: StreamFilter = StreamFilter.None,
  level: Int = CompressionLevel.Default)
  extends TypedWriter(channel, filter, level)
  with CharsetLike
  with ToggleVariantMode {

  import widebase.data.Datatype.Datatype

  /** Write [[org.joda.time.YearMonth]] into buffer
   *
   * @param value self-explanatory
  */
  def write(value: YearMonth) {

    val backupMode = mode
    mode = Datatype.Int
    write(value.getYear)
    mode = backupMode

    super.write(value.getMonthOfYear.toByte)

  }

  /** Write [[org.joda.time.LocalDate]] into buffer
   *
   * @param value self-explanatory
  */
  def write(value: LocalDate) {

    write((value.toDateMidnight(value.getChronology.getZone).getMillis / 1000).toInt)

  }

  /** Write array of [[scala.LocalDate]]s into buffer
   *
   * @param values self-explanatory
  */
  def write(values: Array[LocalDate]) {
  
    write(for(value <- values)
      yield((value.toDateMidnight(value.getChronology.getZone).getMillis / 1000).toInt))

  }

  /** Write [[org.joda.time.Minutes]] into buffer
   *
   * @param value self-explanatory
  */
  def write(value: Minutes) {

    write(value.getMinutes)

  }

  /** Write array of [[scala.Minutes]]s into buffer
   *
   * @param values self-explanatory
  */
  def write(values: Array[Minutes]) {
  
    write(for(value <- values)
      yield(value.getMinutes))

  }

  /** Write [[org.joda.time.Seconds]] into buffer
   *
   * @param value self-explanatory
  */
  def write(value: Seconds) {

    write(value.getSeconds)

  }

  /** Write array of [[scala.Seconds]]s into buffer
   *
   * @param values self-explanatory
  */
  def write(values: Array[Seconds]) {
  
    write(for(value <- values)
      yield(value.getSeconds))

  }

  /** Write [[org.joda.time.LocalTime]] into buffer
   *
   * @param value self-explanatory
  */
  def write(value: LocalTime) {

    write(value.getMillisOfDay)

  }

  /** Write array of [[scala.LocalTime]]s into buffer
   *
   * @param values self-explanatory
  */
  def write(values: Array[LocalTime]) {
  
    write(for(value <- values)
      yield(value.getMillisOfDay))

  }

  /** Write [[org.joda.time.LocalDateTime]] into buffer
   *
   * @param value self-explanatory
  */
  def write(value: LocalDateTime) {

    write(value.toDateTime.getMillis)

  }

  /** Write array of [[scala.LocalDateTime]]s into buffer
   *
   * @param values self-explanatory
  */
  def write(values: Array[LocalDateTime]) {
  
    write(for(value <- values)
      yield(value.toDateTime.getMillis))

  }

  /** Write [[java.sql.Timestamp]] into buffer
   *
   * @param value self-explanatory
  */
  def write(value: Timestamp) {

    write(value.getTime)

    val backupMode = mode
    mode = Datatype.Int
    write(value.getNanos)
    mode = backupMode

  }

  /** Write [[java.lang.Symbol]] into buffer
   *
   * @param value self-explanatory
   *
   * @return amount of bytes written
  */
  def write(value: Symbol): Int = write(value, false)

  /** Write [[java.lang.Symbol]] into buffer
   *
   * @param value self-explanatory
   * @param terminated if true, write null terminated [[java.lang.Symbol]]
   *
   * @return amount of bytes written
  */
  def write(value: Symbol, terminated: Boolean): Int =
    write(value.toString.drop(1), terminated)

  /** Write [[java.lang.String]] into buffer
   *
   * @param value self-explanatory
   *
   * @return amount of bytes written
  */
  def write(value: String): Int = write(value, false)

  /** Write [[java.lang.String]] into buffer
   *
   * @param value self-explanatory
   * @param terminated if true, write null terminated [[java.lang.String]]
   *
   * @return amount of bytes written
  */
  def write(value: String, terminated: Boolean): Int = {

    var bytes = value.getBytes(charset)

    if(terminated)
      bytes = bytes :+ (0: Byte)

    super.write(bytes)
    bytes.size

  }
}

