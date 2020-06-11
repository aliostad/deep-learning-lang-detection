package vep.controller

import vep.exception.FieldErrorException
import vep.model.common._
import vep.model.show.{ShowDetail, ShowForm, ShowSearch, ShowSearchResponse}
import vep.service.VepServicesComponent

/**
 * This controller defines actions querying or updating theaters.
 */
trait ShowControllerComponent {
  val showController: ShowController

  trait ShowController {
    /**
     * Inserts a show into database
     * @param showForm The show to insert
     * @return A list of errors if data are invalid or there is a database constraint error or a simple success
     */
    def create(showForm: ShowForm): Either[ResultErrors, ResultSuccess]

    /**
     * Updates an existing show from database
     * @param showForm The show to update
     * @return A list of errors if data are invalid or there is a database constraint error or simple success.
     */
    def update(showForm: ShowForm): Either[ResultErrors, ResultSuccess]

    /**
     * Searches all shows from database validating given search constraints.
     * @param showSearch The criteria of the search
     * @return
     */
    def search(showSearch: ShowSearch): Either[ResultError, ResultSuccessEntity[ShowSearchResponse]]

    /**
     * Returns detail of show by given canonical.
     * @param canonical The show canonical
     * @return The show with given canonical or an error when it does not exist
     */
    def detail(canonical: String): Either[ResultError, ResultSuccessEntity[ShowDetail]]
  }

}

trait ShowControllerProductionComponent extends ShowControllerComponent {
  self: VepServicesComponent =>

  override val showController: ShowController = new ShowControllerProduction

  class ShowControllerProduction extends ShowController {
    lazy val maxPerPage = 20

    override def create(showForm: ShowForm): Either[ResultErrors, ResultSuccess] = {
      if (showForm.verify) {
        try {
          showService.create(showForm)
          Right(ResultSuccess)
        } catch {
          case e: FieldErrorException => Left(e.toResultErrors)
        }
      } else {
        Left(showForm.toResult.asInstanceOf[ResultErrors])
      }
    }

    override def update(showForm: ShowForm): Either[ResultErrors, ResultSuccess] = {
      if (showForm.verify) {
        if (showService.exists(showForm.canonical)) {
          try {
            showService.update(showForm)
            Right(ResultSuccess)
          } catch {
            case e: FieldErrorException => Left(e.toResultErrors)
          }
        } else {
          Left(ResultErrors(Map(
            "canonical" -> Seq(ErrorCodes.undefinedShow)
          )))
        }
      } else {
        Left(showForm.toResult.asInstanceOf[ResultErrors])
      }
    }

    override def search(showSearch: ShowSearch): Either[ResultError, ResultSuccessEntity[ShowSearchResponse]] = {
      if (showSearch.verify) {
        Right(ResultSuccessEntity(ShowSearchResponse(
          shows = showSearchService.search(showSearch, maxResult = maxPerPage),
          pageMax = Math.ceil(showSearchService.count(showSearch).toDouble / maxPerPage.toDouble).toInt
        )))
      } else {
        Left(showSearch.toResult.asInstanceOf[ResultError])
      }
    }

    override def detail(canonical: String): Either[ResultError, ResultSuccessEntity[ShowDetail]] = {
      showService.findDetail(canonical) match {
        case Some(show) => Right(ResultSuccessEntity(show))
        case None => Left(ResultError(ErrorCodes.undefinedShow))
      }
    }
  }

}
