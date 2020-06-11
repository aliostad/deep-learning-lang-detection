package services

import java.util.UUID
import play.api.libs.json.JsValue
import scala.concurrent.{ExecutionContext, Future}
import slick.backend.DatabaseConfig
import db.Driver

import models.{Reference, Process, Step}

class Processes (protected val dbConfig: DatabaseConfig[Profile])(implicit ec: ExecutionContext) {
  import Driver.api._

  val db = dbConfig.db
  val processes = Processes.processes

  def all(): Future[Seq[Process]] = db.run(Processes.processesCompiled("").result)

  def findById(id: UUID): Future[Option[Process]] = db.run(Processes.processByIdCompiled(id).result).map(_.headOption)

  // Insert process
  def insert(process: Process): Future[Process] =
    db.run(processes += process).map(_ => process)
}

object Processes extends ReferenceSchema {
  import Driver.api._

  class ProcessesTable(tag: Tag) extends Table[Process](tag, "PROCESSES") with ReferenceFields {
    def title = column[String]("TITLE")
    def description = column[String]("DESCRIPTION")
    def steps = column[JsValue]("STEPS")

    def * = (
      ref_*, title, description, steps
    ).shaped <> ({ case (ref, title, description, steps) =>
      Process(Reference.fromTuple(ref), title, description, Step.stepRule.validate(steps).get)
    }, { process: Process =>
      Some((process.reference.toTuple, process.title, process.description, Step.stepWrite.writes(process.root)))
    })
  }

  val processes = TableQuery[ProcessesTable]
  val schema = processes.schema

  // Find processes
  def Processes(fake: Rep[String]) = for {
    process <- processes
  } yield process

  val processesCompiled = Compiled(Processes _)

  // Find process by id
  def processById(id: Rep[UUID]) = for {
    process <- processes if process.id === id
  } yield process

  val processByIdCompiled = Compiled(processById _)
}
