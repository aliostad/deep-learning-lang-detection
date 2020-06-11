package sppp.snippet

import sppp.service.ServiceFactory
import net.liftweb.http.{SHtml, RequestVar, S}
import spj.shared.domain.SpjDomainModel
import scala.collection.JavaConversions._
import xml.{NodeSeq, Text}
import net.liftweb.common.Full
import java.util.Date
import java.text.SimpleDateFormat
import net.liftweb.util.Helpers._

trait SpppSnippet
{
    val requestVar: RequestVar[SpjDomainModel]
    val manageEntryLoc: String
    val editEntryLoc: String

    def manage(xhtml: NodeSeq): NodeSeq

    def edit(xhtml: NodeSeq): NodeSeq

    def create(xhtml: NodeSeq): NodeSeq


    val dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    def selectedRecord[A <: SpjDomainModel]: A = requestVar.is.asInstanceOf[A]

    def calculateRedirectionPath(location: String) = "/" + location.replace("/", "%2F")

    implicit def transformeBooleanValue(value: java.lang.Boolean): String =
    {
        if (value)
            return "+"
        return "-"
    }

    implicit def integerToString(value: java.lang.Integer): String =
    {
        Option(value) match
        {
            case Some(int) => int.toString
            case None => ""
        }
    }

    implicit def parseDate(date: String): Date =
    {
        dateFormat.parse(date);
    }

    implicit def formatDate(date: Date): String =
    {
        dateFormat.format(date)
    }

    lazy val spjRemotingService = ServiceFactory.getSpjRemotingService

    def deleteRecord[A <: SpjDomainModel](record: A, childClasses: Class[_ <: SpjDomainModel]*)
    {
        try
        {
            val canBeDeleted = childClasses.map
            {

                childClass =>
                {
                    val children = spjRemotingService.findAllChildren(record, childClass)
                    if (children.isEmpty)
                        true
                    else
                    {
                        val title = record.getClass.getSimpleName + " " + record.getStringIdentifier + " can't be deleted because it have " + childClass.getSimpleName + " children!"
                        S.error(buildErrorDialog(title, children.toList))
                        false
                    }
                }


            }
                .forall(c => c)
            if (canBeDeleted)
            {
                spjRemotingService.delete(record.getId, record.getClass.asInstanceOf[Class[A]])
                S.notice(record.getClass.getSimpleName + " sucessfully deleted")
            }
        }
        catch
            {
                case _: RuntimeException => S.error(record.getClass.getSimpleName + " deletion failed!")
            }
    }

    def updateRecord[A <: SpjDomainModel](recordBuilder: SpjDomainModel.Builder)
    {

        if (!validateRecordFields(recordBuilder))
            return

        val record: A = recordBuilder.build();
        try
        {
            spjRemotingService.update(record)

        }
        catch
            {
                case e: RuntimeException => S.error(record.getClass.getSimpleName + " modification failed!")
                return
            }
        S.redirectTo(calculateRedirectionPath(manageEntryLoc), () => S.notice(record.getClass.getSimpleName + " sucessfully modified"))
    }

    def createRecord[A <: SpjDomainModel](recordBuilder: SpjDomainModel.Builder)
    {

        if (!validateRecordFields(recordBuilder))
            return

        val record: A = recordBuilder.build();

        try
        {
            spjRemotingService.exists(record.getId, record.getClass.asInstanceOf[Class[A]]) match
            {
                case true =>
                {
                    S.error(record.getClass.getSimpleName + " already exists!")
                    return
                }

                case false =>
                {
                    spjRemotingService.create(record)
                }
            }
        }
        catch
            {
                case e: RuntimeException => S.error(record.getClass.getSimpleName + " creation failed!" + e)
                return
            }
        S.redirectTo(calculateRedirectionPath(manageEntryLoc), () => S.notice(record.getClass.getSimpleName + " sucessfully created"))
    }

    def validateRecordFields[A <: SpjDomainModel.Builder](recordBuilder: A): Boolean =
    {

        val validationResult = recordBuilder.validate()
        if (validationResult.isEmpty)
            true
        else
        {
            validationResult.foreach(result => S.error(result))
            false
        }
    }

    def readAllRecords[A <: SpjDomainModel](recordClass: Class[A]): List[A] =
    {
        spjRemotingService.findAll(recordClass).toList
    }

    def createManageActions[A <: SpjDomainModel](record: A, childClasses: Class[_ <: SpjDomainModel]*) =
    {
        SHtml.link(calculateRedirectionPath(manageEntryLoc), () => deleteRecord(record, childClasses: _*), Text("Delete")) ++
            Text(" ") ++
            SHtml.link(calculateRedirectionPath(editEntryLoc), () => requestVar(record), Text("Edit"))
    }

    def generateRecordSelect[A <: SpjDomainModel](selected: String, clazz: Class[A], f: (A) => Unit) =
    {
        val recordsMap = readAllRecords(clazz).map(rec => (rec.getId.toString, rec)).toMap

        SHtml.select(recordsMap.map(rec => (rec._2.getId.toString, rec._2.getStringIdentifier)).toSeq, Full(selected), s => f(recordsMap.apply(s)))
    }

    def buildErrorDialog[T <: SpjDomainModel](title: String, children: List[T]): NodeSeq =
    {

        bind("children", XhtmlContainer.resultTable,
            "title" -> Text(title),
            "body" -> children.flatMap
            {
                child =>
                    bind("ch", chooseTemplate("child", "entry", XhtmlContainer.childBody),
                        "id" -> Text(child.getId().toString),
                        "naziv" -> Text(child.getStringIdentifier))
            })
    }
}
