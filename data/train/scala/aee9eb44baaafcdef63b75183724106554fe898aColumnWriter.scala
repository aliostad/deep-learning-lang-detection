package widebase.io.column

import java.nio.channels.FileChannel

import widebase.data.Datatype

import widebase.db.column. {

  BoolColumn,
  ByteColumn,
  CharColumn,
  DoubleColumn,
  FloatColumn,
  IntColumn,
  LongColumn,
  ShortColumn,
  MonthColumn,
  DateColumn,
  MinuteColumn,
  SecondColumn,
  TimeColumn,
  DateTimeColumn,
  TimestampColumn,
  SymbolColumn,
  StringColumn,
  TypedColumn

}

import widebase.io.VariantWriter
import widebase.io.filter. { MagicId, StreamFilter }
import widebase.io.filter.StreamFilter.StreamFilter

/** Writes columns into channel.
 *
 * @param writer self-explanatory
 * @param companion self-explanatory
 *
 * @author myst3r10n
 */
class ColumnWriter(writer: VariantWriter, companion: VariantWriter = null) {

  /** Closes writer and companion. */
  def close {

    if(companion != null)
      companion.close

    writer.close

  }

  /** Writes column into file.
    *
    * @param column to write
    * @param amount values to write, 0 write all
   */
  def write[A](column: TypedColumn[A], amount: Int = 0) {

    // Write magic
    if(writer.mode != Datatype.String)
      writer.mode = Datatype.String

    writer.write(MagicId.Column.toString)

    // Write column type
    writer.mode = Datatype.Byte
    writer.write(column.typeOf.id.toByte)

    // Write column length
    writer.mode = Datatype.Int
    if(amount > 0)
      writer.write(amount)
    else
      writer.write(column.length)

    // Write column values
    if(companion == null)
      writer.mode = column.typeOf
    else
      companion.mode = column.typeOf

    column match {

      case column: BoolColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: ByteColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: CharColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: DoubleColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: FloatColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: IntColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: LongColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: ShortColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: MonthColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: DateColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: MinuteColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: SecondColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: TimeColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: DateTimeColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: TimestampColumn =>
        if(amount > 0)
          for(i <- 0 to amount - 1)
            writer.write(column(i))
        else
          column.foreach(value => writer.write(value))

      case column: SymbolColumn =>
        if(companion == null) {

          if(amount > 0)
            for(i <- 0 to amount - 1)
              writer.write(column(i), true)
          else
            column.foreach(value => writer.write(value, true))

        } else {

          var lastEnded = 0L

          writer.mode = Datatype.Long

          if(amount > 0)
            for(i <- 0 to amount - 1) {

              lastEnded +=
                column(i).toString.getBytes(companion.charset).size - 1

              writer.write(lastEnded)
              companion.write(column(i), false)

            }
          else
            column.foreach { value =>

              lastEnded += value.toString.getBytes(companion.charset).size - 1

              writer.write(lastEnded)
              companion.write(value, false)

            }
        }

      case column: StringColumn =>
        if(companion == null) {

          if(amount > 0)
            for(i <- 0 to amount - 1)
              writer.write(column(i), true)
          else
            column.foreach(value => writer.write(value, true))

        } else {
          var lastEnded = 0L

          writer.mode = Datatype.Long

          if(amount > 0)
            for(i <- 0 to amount - 1) {
            
              lastEnded += column(i).getBytes(companion.charset).size

              writer.write(lastEnded)
              companion.write(column(i), false)

            }
          else
            column.foreach { value =>

              lastEnded += value.getBytes(companion.charset).size

              writer.write(lastEnded)
              companion.write(value, false)

            }
        }
    }
  }
}

