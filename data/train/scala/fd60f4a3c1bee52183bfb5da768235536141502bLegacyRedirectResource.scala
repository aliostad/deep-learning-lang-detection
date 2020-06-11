package no.digipost.labs.legacy

import no.digipost.labs.{Settings, DigipostLabsStack}
import no.digipost.labs.items.ItemsService
import no.digipost.labs.errorhandling.ResponseHandler
import no.digipost.labs.util.Logging
import org.scalatra.{NotFound, MovedPermanently}

class LegacyRedirectResource(settings: Settings, itemsService: ItemsService) extends DigipostLabsStack with Logging with ResponseHandler {
  import LegacyRedirectResource._

  get("/") {
    MovedPermanently(settings.basePath)
  }

  get("/ideer/:idString") {
    generateRedirectResponse(params("idString"), "i")
  }

  get("/pages/:idString") {
     generateRedirectResponse(params("idString"), "n")
  }

  get("/pages/nor/:idString") {
    generateRedirectResponse(params("idString"), "n")
  }
  
  private def generateRedirectResponse(idString: String, oldIdPrefix: String) = {
    val oldId = parseLegacyIdString(idString).map(oldIdPrefix + _)
    val redirect = oldId.map { oldId =>
      val redirectUrl = itemsService.findByOldId(oldId, None).map(item => s"${settings.basePath}/#!/item/${item.id}")
      toResponse(redirectUrl)(MovedPermanently(_))
    }
    redirect match {
      case Some(response) => response
      case None => NotFound("Not found")
    }
  }
}

object LegacyRedirectResource {
  private val LegacyIdStringPattern = """^(\/[a-z]{2,3}\/)?(\d+).*$""".r

  def parseLegacyIdString(idString: String) = {
    idString match {
      case LegacyIdStringPattern(_, id) => Some(id)
      case _ => None
    }
  }
}
