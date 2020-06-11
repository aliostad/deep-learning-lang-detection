package com.arcusys.learn.liferay.update.version250

import com.arcusys.learn.liferay.LiferayClasses.LUpgradeProcess
import com.arcusys.learn.liferay.update.version250.slide.SlideTableComponent
import com.arcusys.learn.liferay.update.version250.model.{LFSlide, LFSlideEntity, LFSlideSet}
import com.arcusys.valamis.persistence.common.{SlickDBInfo, SlickProfile}
import com.arcusys.valamis.persistence.impl.file.FileTableComponent
import com.arcusys.valamis.slide.model.SlideEntityType._
import com.arcusys.valamis.web.configuration.ioc.Configuration
import com.escalatesoft.subcut.inject.Injectable
import slick.jdbc.GetResult

import scala.slick.driver.JdbcProfile
import scala.slick.jdbc.{JdbcBackend, StaticQuery}

class DBUpdater2405 extends LUpgradeProcess
  with FileTableComponent
  with SlickProfile
  with SlideTableComponent
  with Injectable {

  implicit val bindingModule = Configuration

  val dbInfo = inject[SlickDBInfo]

  override val driver: JdbcProfile = dbInfo.slickProfile
  import driver.simple._

  val createTables = Seq(slideSets, slides, slideElements)

  override def getThreshold = 2405

  override def doUpgrade(): Unit = dbInfo.databaseDef.withTransaction { implicit session =>
    createTables
      .map(_.ddl)
      .reduce(_ ++ _)
      .create

    migrateSlides()
  }

  private def slideSetLogoPath(id: Long, logo: String) = s"files/slideset_logo_$id/$logo"
  private def slideBGImagePath(id: Long, bgImage: String) = s"files/slide_$id/$bgImage"
  private val tempPrefix = "TEMP/"
  private val tempPattern = tempPrefix + "%"
  private val bgImageRegex = """url\(.*folderId=.*&file=([^&"]+).*"""

  private val fileNames = files.map(_.filename)

  implicit val getSlideSet = GetResult[LFSlideSet] { r => LFSlideSet(
    id = r.nextLong(),
    title = r.nextStringOption(),
    description = r.nextStringOption(),
    logo = r.nextStringOption(),
    courseId = r.nextLongOption()
  )}

  implicit val getSlide = GetResult[LFSlide] { r => LFSlide(
    id = r.nextLong(),
    bgColor = r.nextStringOption(),
    bgImage = r.nextStringOption(),
    questionFont = r.nextStringOption(),
    answerFont = r.nextStringOption(),
    answerBg = r.nextStringOption(),
    font = r.nextStringOption(),
    title = r.nextStringOption(),
    duration = r.nextStringOption(),
    slideSetId = r.nextLongOption(),
    topSlideId = r.nextLongOption(),
    leftSlideId = r.nextLongOption(),
    statementVerb = r.nextStringOption(),
    statementObject = r.nextStringOption(),
    statementCategoryId = r.nextStringOption()
  )}

  implicit val getSlideElement = GetResult[LFSlideEntity] { r => LFSlideEntity(
    id = r.nextLong(),
    top = r.nextStringOption(),
    left = r.nextStringOption(),
    width = r.nextStringOption(),
    height = r.nextStringOption(),
    zIndex = r.nextStringOption(),
    content = r.nextStringOption(),
    slideEntityType = r.nextStringOption(),
    slideId = r.nextLongOption(),
    correctLinkedSlideId = r.nextLongOption(),
    incorrectLinkedSlideId = r.nextLongOption(),
    notifyCorrectAnswer = r.nextBooleanOption()
  )}

  private def migrateSlides()(implicit session: JdbcBackend#Session) = {
    val slideSetColumns = "id_, title, description, logo, courseId"
    StaticQuery.queryNA[LFSlideSet](s"SELECT $slideSetColumns FROM Learn_LFSlideSet")
      .list
      .foreach(insertSlideSet)

    val tempSlidesFiles = fileNames
      .filter(_.like(tempPattern))
      .list

    tempSlidesFiles.foreach { logo =>
      files
        .filter(_.filename === logo.drop("TEMP/".length))
        .delete

      fileNames
        .filter(_ === logo)
        .update(logo.drop("TEMP/".length))
    }
  }

  private def insertSlideSet(oldEntry: LFSlideSet)(implicit session: JdbcBackend#Session) = {
    val newEntry = new SlideSet(
      Some(oldEntry.id),
      oldEntry.title.getOrElse(""),
      oldEntry.description.getOrElse(""),
      oldEntry.courseId.getOrElse(-1L),
      oldEntry.logo
    )
    val newSlideSetId = (slideSets returning slideSets.map(_.id)).insert(newEntry)

    oldEntry.logo.foreach { logo =>
      val oldLogoPath = slideSetLogoPath(oldEntry.id, logo)
      val newLogoPath = tempPrefix + slideSetLogoPath(newSlideSetId, logo)

      fileNames
        .filter(_ === oldLogoPath)
        .update(newLogoPath)
    }

    val slideColumns = "id_, bgcolor, bgimage, questionFont, answerFont, answerBg, font, title, duration, slideSetId, topSlideId, leftSlideId, statementVerb, statementObject, statementCategoryId"
    val slideList = StaticQuery.queryNA[LFSlide](s"SELECT $slideColumns FROM Learn_LFSlide WHERE slideSetId=${oldEntry.id}")
      .list

    slideList
      .foreach(insertSlide(slideList, _, newSlideSetId))
  }

  private var addedSlideIds: Map[Option[Long], Option[Long]] = Map()
  private def insertSlide(slideList: List[LFSlide], oldEntry: LFSlide, newSlideSetId: Long)(implicit session: JdbcBackend#Session): Option[Long] = {
    if(addedSlideIds.get(Some(oldEntry.id)).nonEmpty)
      return addedSlideIds.get(Some(oldEntry.id)).get

    val newLeftSlideId =
      if (oldEntry.leftSlideId.isEmpty || !slideList.exists(_.id == oldEntry.leftSlideId.get))
        None
      else
        insertSlide(slideList, slideList.filter(_.id == oldEntry.leftSlideId.get).head, newSlideSetId)

    val newTopSlideId =
      if (oldEntry.topSlideId.isEmpty || !slideList.exists(_.id == oldEntry.topSlideId.get))
        None
      else
        insertSlide(slideList, slideList.filter(_.id == oldEntry.topSlideId.get).head, newSlideSetId)

    val newEntry = new Slide(
      Some(oldEntry.id),
      oldEntry.title.getOrElse("Page"),
      oldEntry.bgColor,
      oldEntry.bgImage,
      oldEntry.font,
      oldEntry.questionFont,
      oldEntry.answerFont,
      oldEntry.answerBg,
      oldEntry.duration,
      newLeftSlideId,
      newTopSlideId,
      newSlideSetId,
      oldEntry.statementVerb,
      oldEntry.statementObject,
      oldEntry.statementCategoryId
    )


    val newSlideId = (slides returning slides.map(_.id)).insert(newEntry)
    addedSlideIds += (Some(oldEntry.id) -> Some(newSlideId))

    oldEntry.bgImage.foreach { bgImage =>
      val file = bgImageRegex.r.findFirstMatchIn(bgImage)
        .map(_.group(1))
        .getOrElse("")

      val oldBGImagePath = slideBGImagePath(oldEntry.id, file)
      val newBGImagePath = tempPrefix + slideBGImagePath(newSlideId, file)

      fileNames
        .filter(_ === oldBGImagePath)
        .update(newBGImagePath)
    }

    val slideElementColumns = "id_, top_, left_, width, height, zIndex, content, entityType, slideId, correctLinkedSlideId, incorrectLinkedSlideId, notifyCorrectAnswer"
    StaticQuery.queryNA[LFSlideEntity](s"SELECT $slideElementColumns FROM Learn_LFSlideEntity WHERE slideId=${oldEntry.id}")
      .list
      .foreach(insertSlideElement(_, newSlideId))

    Some(newSlideId)
  }

  private val imageRegexp = """.*slide_item_\d+&file=([^&"]+).*""".r
  private val pdfRegexp = """.*quizData\d+/(.+)""".r
  private def pdfPath(id: Long, fileName: String) = s"files/slideData$id/$fileName"
  private def imagePath(id: Long, fileName: String) = s"files/slide_item_$id/$fileName"

  private def insertSlideElement(oldEntry: LFSlideEntity, newSlideId: Long)(implicit session: JdbcBackend#Session) = {
    val newEntry = new SlideElement(
      Some(oldEntry.id),
      oldEntry.top.getOrElse("0"),
      oldEntry.left.getOrElse("0"),
      oldEntry.width.getOrElse("800"),
      oldEntry.height.getOrElse("auto"),
      oldEntry.zIndex.getOrElse("1"),
      oldEntry.content.getOrElse(""),
      oldEntry.slideEntityType.getOrElse(""),
      newSlideId,
      oldEntry.correctLinkedSlideId,
      oldEntry.incorrectLinkedSlideId,
      oldEntry.notifyCorrectAnswer
    )

    val newSlideElementId = (slideElements returning slideElements.map(_.id)).insert(newEntry)

    oldEntry.slideEntityType.getOrElse("") match {
      case Pdf =>
        if(oldEntry.content.isDefined) {
          pdfRegexp
            .findFirstMatchIn(oldEntry.content.getOrElse(""))
            .map(_.group(1))
            .foreach { fileNameWithoutPrefix =>
              val oldFilePath = pdfPath(oldEntry.id, fileNameWithoutPrefix)
              val newFilePath = tempPrefix + pdfPath(newSlideElementId, fileNameWithoutPrefix)

              fileNames
                .filter(_ === oldFilePath)
                .update(newFilePath)
          }
        }
      case Image =>
        if(oldEntry.content.isDefined) {
          imageRegexp
            .findFirstMatchIn(oldEntry.content.getOrElse(""))
            .map(_.group(1))
            .foreach { fileNameWithoutPrefix =>
              val oldFilePath = imagePath(oldEntry.id, fileNameWithoutPrefix)
              val newFilePath = tempPrefix + imagePath(newSlideElementId, fileNameWithoutPrefix)

              fileNames
                .filter(_ === oldFilePath)
                .update(newFilePath)
          }
        }
      case Text | Iframe | Question | Video | Math =>
    }
  }
}
