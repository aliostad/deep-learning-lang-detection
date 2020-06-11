package libt.spreadsheet.writer

import libt._
import libt.spreadsheet.reader._
import org.apache.poi.ss.usermodel.Sheet
import libt.spreadsheet._
import libt.error._

/**
 * [[libt.spreadsheet.reader.SheetDefinition]] that delegates the writing action to
 * a custom write strategy
 *
 * @author mcorbanini
 */
trait CustomWriteSheetDefinition extends SheetDefinition {
  val writeStrategy: WriteStrategy
  def write(models: Seq[Model])(sheet: Sheet) =
    writeStrategy.write(models, this, sheet)

  def customWrite(models: Seq[Model], sheet: Sheet): Unit
}

trait WriteStrategy {
  def write(models: Seq[Model], area: CustomWriteSheetDefinition, sheet: Sheet): Unit
}

/**
 * [[libt.spreadsheet.writer.WriteStrategy]] that completelty delegates on the layout and
 * simply writes everything
 *
 * @author mcorbanini
 */
object FullWriteStrategy extends WriteStrategy {
  def write(models: Seq[Model], area: CustomWriteSheetDefinition, sheet: Sheet) =
    area.customWrite(models, sheet)
}

case class CustomWriteArea(
  schema: TModel,
  offset: Offset,
  limit: Option[Int],
  orientation: Layout,
  columns: Seq[Strip],
  writeStrategy: WriteStrategy = FullWriteStrategy) extends AreaLike with CustomWriteSheetDefinition {

  def read(sheet: Sheet): Validated[Seq[Model]] = ???

  def customWrite(models: Seq[Model], sheet: Sheet) =
    orientation.write(this, sheet, models)
}

