package nz.ubermouse.hummingbirdsyncer.printers

import api.Hummingbird.HummingbirdShow
import com.typesafe.scalalogging.slf4j.Logging

/**
 * Created by Taylor on 18/07/14.
 */
object HummingbirdShowPrinter extends Logging {
  def apply(shows:List[HummingbirdShow]) {
    for(show <- shows)
      logger.trace(stringRepresentation(show))
  }

  def stringRepresentation(show:HummingbirdShow) = {
    s"""
      | ${show.anime.title} (${show.anime.slug})
        - Episodes Watched: ${show.episodes_watched}
        - Last Updated: ${show.last_watched}
    """.stripMargin
  }
}
