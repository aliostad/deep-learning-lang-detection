package vog.substance.mutators

import vog.config.CacheManager
import java.awt.image.ImageObserver
import swing.Graphics2D
import vog.cache.Image


/**
 * Uses image [[vog.cache]] to receive image basing on name.
 * Retrieval happens when imageName or angle was changed.
 * @author Ivyl
 */
trait CacheMutator extends NamedImageMutator {

  private var oldImageName = name
  private var oldAngle = angle

  var image: Option[Image] = CacheManager.image.retrieveRotated(name, angle.toInt)

  protected abstract override def paint(g: Graphics2D, observer: ImageObserver) {
    if (oldImageName != imageName || oldAngle != angle) {
      oldAngle = angle
      oldImageName = imageName
      image = CacheManager.image.retrieveRotated(imageName, angle.toInt)
    }
    super.paint(g, observer)
  }
}
